from transformers import pipeline
from transformers import logging
logging.set_verbosity_error()
logging.set_verbosity_warning()
summarizer = pipeline("summarization",model="t5-base",use_fast=True)



def Text_Sumarization(context):
    return summarizer(context)[0]["summary_text"]
#print("print: print")
#print(summarizer("Artificial intelligence (AI) is intelligence demonstrated by machines, as opposed to the natural intelligence displayed by animals and humans. AI research has been defined as the field of study of intelligent agents, which refers to any system that perceives its environment and takes actions that maximize its chance of achieving its goals"))
#print("sumarzie",Text_Sumarization("Artificial intelligence (AI) is intelligence demonstrated by machines, as opposed to the natural intelligence displayed by animals and humans. AI research has been defined as the field of study of intelligent agents, which refers to any system that perceives its environment and takes actions that maximize its chance of achieving its goals"))