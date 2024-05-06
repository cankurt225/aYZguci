"""
WELCOME TO HAKANAI
"""



from .QuestinAnswering import Question_Answer
from .TextSumarization import Text_Sumarization
from .WebScrap_HakanAI import WebScrap_HakanAI
import core.translation as tr


"""
Section 1 : Web Scrap
"""
translator=tr.Translate()
webscrap = WebScrap_HakanAI()
class Algorithm:
    def DataScrap(self,search,lang):
        
        paragraphs=webscrap.ScrapWiki(search,lang)
        #sentences_other = webscrap.Scrap_RandomSites(search)




        
        return paragraphs

    def get_Answer_shortdefinition(self,question,type,lang):
        print("question: ",question)
        new_question=question.lower()
        new_question_word="what is the"

            
            
        print(new_question)
        try:
            sentences=webscrap.getWikiAPI(new_question,lang,index=5)
    
            print("len sentences",len(sentences))
            sentence=" "
            if type=="1":
                sentence=sentences[0]
                outsentence=[sentence]
                
    
                
            elif type=="2":
                sentence=" ".join([i for i in sentences])

                outsentence=[sentence]
            if lang != "en":
                outsentence=translator.translate_text(outsentence,"en")
                
            print("question",outsentence)
            #print("\n word question",new_question_word)
            results_definition =  Question_Answer(outsentence,question=new_question_word+" "+new_question,model=1)
            results_definition1= translator.translate_text([results_definition],"tr")
            return results_definition1[0]
        except:
            return "bulunamadı"
    def get_Sumarization(self,question,index,lang):
        new_question=question.lower()
        if lang=="en":
            new_question=translator.translate_text([new_question],"en")[0]
        try:
            sentences=webscrap.getWikiAPI(new_question,lang,index=0)
    
            outsentence=" ".join([i for i in sentences])
            if lang != "en":
                outsentence=translator.translate_text([outsentence],"en")
            print("OUTSENTENCE",outsentence)
            if int(index)==0:
                results_summarization = Text_Sumarization(outsentence)
                results_summarization1=translator.translate_text([results_summarization],"tr") 
                returns=[results_summarization1[0],len(sentences)]
            else:
                results_summarization = Text_Sumarization(sentences[int(index)]) 
                returns=[results_summarization1]
        except:
            returns=["bulunmadı"]
        return returns
algorithm=Algorithm()
#print("type1: ",algorithm.get_Answer_shortdefinition(question="matrix",question_word="nedir",type="1",lang="en"))
#print("type1: ",algorithm.get_Answer_shortdefinition(question="matrix",question_word="nedir",type="0",lang="en"))


#print("type1: ",algorithm.get_Answer_shortdefinition(question="erzurum",question_word="nedir",type="1",lang="tr"))
#print("type2: ",algorithm.get_Answer_shortdefinition(question="erzurum",question_word="nedir",type="2",lang="tr"))

#print("RESULTS",algorithm.get_Answer_shortdefinition(question="qweqewqe",question_word="What is",type="2",lang="tr"))
#print("-----------------")
print(algorithm.get_Sumarization(question="Java",index="0",lang="en"))
"""
print(algorithm.get_Answer_shortdefinition(question="fizik",type="2",lang="en"))
print(algorithm.get_Answer_shortdefinition(question="Yapay Zeka",type="2",lang="en"))
print(algorithm.get_Answer_shortdefinition(question="Makine Öğrenmesi",type="2",lang="en"))
print(algorithm.get_Answer_shortdefinition(question="Derin Öğrenme",type="2",lang="en"))
print(algorithm.get_Answer_shortdefinition(question="Üniversite",type="2",lang="en"))"""


