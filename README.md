# LOFTune-Agent

Implement LOFTune with LLM Agent

# Requirements
***
- python 3.10.2
- **agent**
- langgraph
- langchain
- langchain-openai
- langchain-community
- python-dotenv
- **sql encoder**
- torch 1.12.1
- tree-sitter 0.20.1
- sqlglot 1.16.1
- transformer
- **regression model**
- optuna 3.5.0
- quantile-forest 1.1.3
- scikit-learn 1.0.2
- **mysql**
- sqlalchemy 1.4.22
- sqlahchemy-utils 0.41.1
- pymysql 1.0.3
- pandas 2.0.3
- **spark**
- hdfs
# Usage
***
1. create `.env` file in the root directory and type in `OPENAI_API_KEY=<YOUR OWN API>`.







<!-- This repository contains the source code for our paper: **LOFTune: A Low-overhead and Flexible Approach for Spark SQL Configuration Tuning**.

# Requirements
***
- langchain-openai
- langgraph
- python-dotenv

- tokenizers 0.11.4
- optuna 3.5.0
- quantile-forest 1.1.3
- scikit-learn 1.0.2
- torch 1.12.1
- tree-sitter 0.20.1
- sqlglot 20.7.1
***

# Datasets
***
- [TPCDS(100G and 300G)](https://www.tpc.org/tpcds/)
- [TPCH(100G)](https://www.tpc.org/tpch/)
- [IMDB](http://homepages.cwi.nl/~boncz/job/imdb.tgz)

# Structure
***
- config: The parameters of the algorithm and model.
- data: Part of datasets used in the experiments.
- modules: Knowledge Base Updater, Configuration Recommender, Controller and some helper functions.
- sql_encoder: Convert sql to vector, i.e. Multi-task SQL Representation Learning.
- main.py: A complete function entrance, including all callable related interfaces.
- run_tests.sh: A shell test script that can be run directly.
- scripts and utils.py: Some commonly used helper functions.
***

# Usage
***
1. Download datasets
2. Set mode and workloads in run_tests.sh
3. Execute run_tests.sh -->
