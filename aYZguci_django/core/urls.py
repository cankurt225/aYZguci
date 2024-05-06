import re
from django.http import JsonResponse
from django.urls import path
from django.views.decorators.csrf import csrf_exempt
from .models import Q_A, S_M, Question_Answer_DataBase
from .Main_AI_core import Algorithm

algorithm = Algorithm()
@csrf_exempt
def questions_Page(request):
    question="question_"
    answer="answer_"
    if request.POST.get("question")==None:
        question="question_"
        answer="answer_"
        data_json={"question":question,"answer":answer}
        
    else:
        
        question_incoming = request.POST.get("question")
        password= request.POST.get("password")
        question_word = request.POST.get("question_word")
        model=request.POST.get("model")
        type=request.POST.get("type")        
        lang = request.POST.get("lang")
                #question = Question_Answer_DataBase.objects.filter(data_question=question_incoming)[0].data["question"]
                #answer = Question_Answer_DataBase.objects.filter(data_question=question_incoming)[0].data["answer"]
                #data_json=Question_Answer_DataBase.objects.filter(data_question=question_incoming)[0].data
                #print(answer,"try içine girildi")
                #except:
            
        if password=="1941":
            if model=="q_a":
                try:
                    #question = Q_A.objects.filter(data__question=question_incoming,data__model=model,data__type=type)[0].data["question"]
                    answer = Q_A.objects.filter(data__question=question_incoming,data__model=model,data__type=type,data__lang=lang)[0].data["answer"]
                    data_json={"question":question_incoming,"answer":answer}
                except:
                    print("try çalışmadı")                                      
                    #print("databse",Q_A.objects.filter(data__question=question_incoming)[0].data)
                    
                    question = question_incoming
                    try:
                        answer=algorithm.get_Answer_shortdefinition(question=question,question_word=question_word,type=type,lang=lang)
                    except:
                        answer="bulunamadı"
                    
                    data_json={"question":question,"answer":answer}
                    data_db=Q_A(data={"question":question,"answer":answer,"type":type,"model":model,"lang":lang})
                    data_db.save()
                    print(data_db)
            elif model=="s_m":
                try:
                    #a=str(12)
                    #question = Q_A.objects.filter(data__question=question_incoming,data__model=model,data__type=type)[0].data["question"]
                    answer = S_M.objects.filter(data__question=question_incoming,data__model=model,data__type=type,data__lang=lang)[0].data["answer"]
                    len = S_M.objects.filter(data__question=question_incoming,data__model=model,data__type=type,data__lang=lang)[0].data["len"]
                    data_json={"question":question_incoming,"answer":answer,"len":len}
                except:
                    print("try çalışmadı")                                      
                    #print("databse",Q_A.objects.filter(data__question=question_incoming)[0].data)
                    
                    question = question_incoming
                    try:
                        results=algorithm.get_Sumarization(question=question,index=type,lang=lang)
                    
                        answer=results[0]
                    except:
                        answer="bulunamadı"
                    try:
                        len_sentences= str(results[1])
                    except:
                        len_sentences="1"
                    
                    data_json={"question":question,"answer":answer,"len":len_sentences}
                    data_db=S_M(data={"question":question,"answer":answer,"type":type,"model":model,"len":len_sentences,"lang":lang})
                    data_db.save()
                    print(data_db)

                
        else:
            answer="ERROR"
            question=question_incoming
            data_json={"answer",answer}
    
        
    return JsonResponse(data_json)



def database_page(request):
    return JsonResponse(Question_Answer_DataBase.objects.values)
urlpatterns = [
    #path("database",database_page),
    path("questions", questions_Page),]
