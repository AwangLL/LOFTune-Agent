from enum import Enum
from copy import deepcopy
from config.config import data_size, workload

# 资源使用阈值，为公平起见，最小资源阈值设置为0
MEMORY_MIN = 0
CORE_MIN = 0
MEMORY_MAX = 192000 if data_size < 250 else 288000
CORE_MAX = 144


class KnobType(Enum):
    INTEGER = 'integer'
    NUMERIC = 'numeric'
    CATEGORICAL = 'categorical'


class Unit(Enum):
    MB = 'm'
    KB = 'k'
    MILLISECOND = 'ms'


RESOURCE_KNOB_DETAILS = {
    # Number of cores by driver process
    'spark.driver.cores': {
        'type': KnobType.INTEGER,  # 数据类型
        'range': [5, 12, 1],  # [最小值, 最大值, 步长]
        'default': 1,  # Spark默认值
        'range_adjustable': True,  # 历史采样的过程中，取值范围是否可以基于最优值变化
        'limit_exceed': [False, False],
    },
    # Memory size for driver process
    'spark.driver.memory': {
        'type': KnobType.INTEGER,
        'range': [6 * 1024, 16 * 1024, 64],
        'default': 1 * 1024,
        'range_adjustable': True,
        'limit_exceed': [False, False],
        'unit': Unit.MB.value
    },
    # Number of cores per executor
    'spark.executor.cores': {
        'type': KnobType.INTEGER,
        'range': [5, 12, 1],
        'default': 1,
        'range_adjustable': True,
        'limit_exceed': [False, False],
    },
    # Total number of Executor processes used for the Spark job
    'spark.executor.instances': {
        'type': KnobType.INTEGER,
        'range': [5, 12, 1],
        'default': 2,
        'range_adjustable': True,
        'limit_exceed': [False, False],
    },
    # Memory size per executor process
    'spark.executor.memory': {
        'type': KnobType.INTEGER,
        'range': [6 * 1024, 16 * 1024, 64],
        'default': 1 * 1024,
        'range_adjustable': True,
        'limit_exceed': [False, False],
        'unit': Unit.MB.value
    },
    # Memory size which can be used for off-heap allocation
    'spark.memory.offHeap.size': {
        'type': KnobType.INTEGER,
        'range': [1024, 4 * 1024, 64],
        'default': 0,
        'range_adjustable': False,
        'limit_exceed': [False, False],
        'unit': Unit.MB.value
    }
}
if data_size < 50:
    RESOURCE_KNOB_DETAILS['spark.driver.cores']['range'] = [2, 8, 1]
    RESOURCE_KNOB_DETAILS['spark.driver.memory']['range'] = [4 * 1024, 12 * 1024, 64]
    RESOURCE_KNOB_DETAILS['spark.executor.cores']['range'] = [2, 8, 1]
    RESOURCE_KNOB_DETAILS['spark.executor.instances']['range'] = [2, 8, 1]
    RESOURCE_KNOB_DETAILS['spark.executor.memory']['range'] = [4 * 1024, 12 * 1024, 64]
elif data_size > 250:
    RESOURCE_KNOB_DETAILS['spark.driver.cores']['range'] = [3, 12, 1]
    RESOURCE_KNOB_DETAILS['spark.driver.memory']['range'] = [4 * 1024, 20 * 1024, 64]
    RESOURCE_KNOB_DETAILS['spark.executor.cores']['range'] = [3, 12, 1]
    RESOURCE_KNOB_DETAILS['spark.executor.instances']['range'] = [3, 12, 1]
    RESOURCE_KNOB_DETAILS['spark.executor.memory']['range'] = [4 * 1024, 20 * 1024, 64]
    RESOURCE_KNOB_DETAILS['spark.memory.offHeap.size']['range'] = [1 * 1024, 4 * 1024, 64]

# 以下参数可以不调范围
NON_RESOURCE_KNOB_DETAILS = {
    # Size of each piece of a block for TorrentBroadcastFactory
    'spark.broadcast.blockSize': {
        'type': KnobType.INTEGER,  # 数据类型
        'range': [1, 16, 1],  # 取值范围，[最小值, 最大值, 步长]
        'default': 4,  # Spark的默认值
        'range_adjustable': True,  # 历史采样的过程中，取值范围是否可以基于最优值变化
        'limit_exceed': [False, False],  # 历史采样的过程中，变化的取值范围能否超过`range`，
                                       # 第一个值表示能否＜最小值，第二个值表示能否＞最大值
        'unit': Unit.MB.value  # 单位（如果有的话）
    },
    # Number of RDD partitions
    'spark.default.parallelism': {
        'type': KnobType.INTEGER,
        'range': [24, 600, 1],
        'default': 100,
        'range_adjustable': True,
        'limit_exceed': [False, False]
    },
    # Memory overhead of each executor
    'spark.executor.memoryOverhead': {
        'type': KnobType.INTEGER,
        'range': [384, 4 * 1024, 64],
        'default': 384,
        'range_adjustable': True,
        'limit_exceed': [False, False]
    },
    # Wait time to launch task in data-local before in a less-local node
    'spark.locality.wait': {
        'type': KnobType.INTEGER,
        'range': [1000, 6 * 1000, 100],
        'default': 3 * 1000,
        'range_adjustable': True,
        'limit_exceed': [False, False],
        'unit': Unit.MILLISECOND.value
    },
    # Fraction for execution and storage memory
    'spark.memory.fraction': {
        'type': KnobType.NUMERIC,
        'range': [0.35, 0.85, 0.01],
        'default': 0.6,
        'range_adjustable': True,
        'limit_exceed': [False, False]
    },
    # Storage memory percent exempt from eviction
    'spark.memory.storageFraction': {
        'type': KnobType.NUMERIC,
        'range': [0.35, 0.85, 0.01],
        'default': 0.5,
        'range_adjustable': True,
        'limit_exceed': [False, False]
    },
    # Max map outputs to collect concurrently per reduce task
    'spark.reducer.maxSizeInFlight': {
        'type': KnobType.INTEGER,
        'range': [24, 144, 1],
        'default': 48,
        'range_adjustable': True,
        'limit_exceed': [False, False],
        'unit': Unit.MB.value
    },
    # In-memory buffer size per output stream
    'spark.shuffle.file.buffer': {
        'type': KnobType.INTEGER,
        'range': [16, 96, 1],
        'default': 32,
        'range_adjustable': True,
        'limit_exceed': [False, False],
        'unit': Unit.KB.value
    },
    # Specifies the maximum size for a broadcasted table
    'spark.sql.autoBroadcastJoinThreshold': {
        'type': KnobType.INTEGER,
        'range': [8 * 1024, 32 * 1024 if workload != 'IMDB' else 16 * 1024, 128],
        'default': 10 * 1024,
        'range_adjustable': True,
        'limit_exceed': [False, False],  # IMDB不能够超过16m
        'unit': Unit.KB.value
    },
    # Specifies the size of the batch used for column caching
    'spark.sql.inMemoryColumnarStorage.batchSize': {
        'type': KnobType.INTEGER,
        'range': [5000, 20000, 100],
        'default': 10000,
        'range_adjustable': True,
        'limit_exceed': [False, False]
    },
    # Default partition number when shuffling data for join/aggregations
    'spark.sql.shuffle.partitions': {
        'type': KnobType.INTEGER,
        'range': [24, 600, 1],
        'default': 200,
        'range_adjustable': True,
        'limit_exceed': [False, False]
    },
    # Specifies mapped memory size when read a block from the disk
    'spark.storage.memoryMapThreshold': {
        'type': KnobType.INTEGER,
        'range': [1, 10, 1],
        'default': 2,
        'range_adjustable': True,
        'limit_exceed': [False, False],
        'unit': Unit.MB.value
    },
    # Decides whether to compress broadcast variables before sending
    'spark.broadcast.compress': {
        'type': KnobType.CATEGORICAL,  # 数据类型
        'candidates': ['false', 'true'],  # [可选值1, 可选值2, ...]
        'default': 'true',  # Spark默认值
        'range_adjustable': False  # 历史采样的过程中，取值范围是否可以基于最优值变化
    },
    # Decides whether to compress serialized RDD partitions
    'spark.rdd.compress': {
        'type': KnobType.CATEGORICAL,
        'candidates': ['false', 'true'],
        'default': 'false',
        'range_adjustable': False
    },
    # Whether to use Sort Merge Join over Shuffle Hash Join
    'spark.sql.join.preferSortMergeJoin': {
        'type': KnobType.CATEGORICAL,
        'candidates': ['false', 'true'],
        'default': 'true',
        'range_adjustable': False
    },
    # The codec of compression in Spark
    'spark.io.compression.codec': {
        'type': KnobType.CATEGORICAL,
        'candidates': ['lz4', 'snappy'],
        'default': 'lz4',
        'range_adjustable': False
    }
}

KNOB_DETAILS = deepcopy(NON_RESOURCE_KNOB_DETAILS)
KNOB_DETAILS.update(RESOURCE_KNOB_DETAILS)
KNOBS = sorted(list(KNOB_DETAILS.keys()))

# 正常运行spark任务所需的其他参数，不需要调优
EXTRA_KNOBS = {
    'spark.master': 'yarn',
    'spark.submit.deployMode': 'cluster',
    'spark.eventLog.enabled': 'true',
    'spark.eventLog.compress': 'false',
    'spark.yarn.jars': 'hdfs://node183:9000/home/yjh/spark_tune/environment/spark-3.2.4/jars/*.jar',
    'spark.eventLog.dir': 'hdfs://node183:9000/home/yjh/spark_tune/environment/spark-3.2.4/log',
    'spark.yarn.maxAppAttempts': 1,
    'spark.sql.catalogImplementation': 'hive',
    'spark.memory.offHeap.enabled': 'true',
    'spark.sql.sources.parallelPartitionDiscovery.parallelism': 270
}
