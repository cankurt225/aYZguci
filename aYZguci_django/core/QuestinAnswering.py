from transformers import pipeline
from transformers import logging , TFLongformerForQuestionAnswering
import pandas as pd
logging.set_verbosity_error()
logging.set_verbosity_warning()
#nlp1 = pipeline("question-answering",model="bert-large-uncased-whole-word-masking-finetuned-squad")
nlp1 = pipeline("question-answering")
#nlp3 = pipeline("question-answering",model="roberto-large")


def Question_Answer(contexts,question,model=1):
    results=[]
    for context in contexts:
        #print("context",context)
        context =str(context)
        if context !=" " and context!="":
            if model==1:

                result = nlp1(question=question, context=context)
                results.append(result)
            elif model==2:
                #result = nlp1(question=question, context=context,)
                result=""
                results.append(result)

    df=pd.DataFrame(results).groupby("score").max()
    return df.loc[df.index.max()].answer

#print(Question_Answer(contexts=["Artificial intelligence (AI) is intelligence demonstrated by machines, as opposed to the natural intelligence displayed by animals and humans. AI research has been defined as the field of study of intelligent agents, which refers to any system that perceives its environment and takes actions that maximize its chance of achieving its goals","The term 'artificial intelligence' had previously been used to describe machines that mimic and display 'human' cognitive skills that are associated with the human mind, such as 'learning' and 'problem-solving'. This definition has since been rejected by major AI researchers who now describe AI in terms of rationality and acting rationally, which does not limit how intelligence can be articulated."],question="What is Artificial intelligence"))