import os
import datetime
import logging.config

from config.common import cwd

BASE_DIR = cwd

# 自动创建目录
if not os.path.exists(f'{BASE_DIR}/logs/history_tuner/'):
    os.makedirs(f'{BASE_DIR}/logs/history_tuner/')

if not os.path.exists(f'{BASE_DIR}/logs/recommender/'):
    os.makedirs(f'{BASE_DIR}/logs/recommender/')

LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(module)s:%(funcName)s] [%(levelname)s] %(message)s'
        }
    },
    'filters': {
    },
    'handlers': {
        'history_tuner': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': f'{BASE_DIR}/logs/history_tuner/{datetime.date.today()}.log',
            'maxBytes': 1024 * 1024 * 5,
            'backupCount': 5,
            'formatter': 'standard',
        },
        'recommender': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': f'{BASE_DIR}/logs/recommender/{datetime.date.today()}.log',
            'maxBytes': 1024 * 1024 * 5,
            'backupCount': 5,
            'formatter': 'standard',
        }
    },
    'loggers': {
        'history_tuner': {
            'handlers': ['history_tuner'],
            'level': 'INFO',
            'propagate': False,
        },
        'recommender': {
            'handlers': ['recommender'],
            'level': 'INFO',
            'propagate': False,
        },
    }
}

logging.config.dictConfig(LOGGING_CONFIG)