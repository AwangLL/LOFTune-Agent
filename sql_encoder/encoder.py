from typing import List

import torch
from transformers import BertModel, BertTokenizer

from config.encoder_config import *

tokenizer = None
model = None

def encode_sql(query: str) -> List[float]:
    if encoding_model == 'bert':
        global tokenizer
        global model
        if tokenizer is None:
            tokenizer = BertTokenizer.from_pretrained('bert-base-uncased', clean_up_tokenization_spaces=False)
            model = BertModel.from_pretrained('bert-base-uncased')

        inputs = tokenizer(query, return_tensors='pt', padding=True, truncation=True, max_length=512)
        with torch.no_grad():
            outputs = model(**inputs)
        last_hidden_states = outputs.last_hidden_state
        cls_embedding = last_hidden_states[0, 0, :].numpy()

        return cls_embedding.tolist()
    else:
        raise NotImplementedError