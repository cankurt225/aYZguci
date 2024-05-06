
from googletrans import Translator

class Translate(Translator):
    def translate_text(self,text_list,dest):
     
        translated_list=[]
        for i in text_list:
            translated= self.translate(i,dest=dest)
            translated_list.append(translated.text)
        return translated_list
    
translator = Translate()



"""   if type(text)=="list":
            translated_list=[]
            for i in text:
                translated= self.translate(i,dest=dest)
                translated_list.append(translated.text)
            return translated_list
        else:

            translated= self.translate(text,dest=dest)
            return translated.text"""