import requests
from bs4 import BeautifulSoup
import core.translation as tr
translator=tr.Translate()
class WebScrap_HakanAI:

    def Scrap_SitesLink(self,search):

        url = "https://www.google.com/search?q=What+is+{}".format(search)

        r = requests.get(url)

        soup = BeautifulSoup(r.content,"html.parser")

        tags= soup.find_all("div",attrs={"class":"yuRUbf"})
        links = []
        for i in soup.find_all("a",href=True):
            links.append(i["href"])

        site_links= [i for i in links if "/url" in i ]
        site_links_set = [i.split("=")[1] for i in site_links]
        site_links_set = [i.split("&")[0] for i in site_links_set]
        return site_links_set

    def ScrapWiki(self,search,lang):
        print("LANG",lang)
        print("search",search)

        if lang=="tr":
            try:

                response = requests.get(
                    url="https://tr.wikipedia.org/wiki/{}".format(search),
                )
                soup = BeautifulSoup(response.content, 'html.parser')
            except:
                response = requests.get(
                    url="https://en.wikipedia.org/wiki/{}".format(search),
                )
                soup = BeautifulSoup(response.content, 'html.parser')
        else:
            response = requests.get(
                    url="https://{}.wikipedia.org/wiki/{}".format(lang,search),
                )
            soup = BeautifulSoup(response.content, 'html.parser')

        p_lists= soup.find_all("p")
        text_list=[i.text for i in p_lists]
        sentences = [i.split(".") for i in text_list]

        if sentences[0] == ["\n"]:
            sentences_set = [i for i in sentences[1:11]]
            
        elif sentences[0] == ["\n"] and sentences[1] == ["\n"]:
            sentences_set = [i for i in sentences[2:12]]

        else:
            sentences_set = [i for i in sentences[:10]]
        #sentences_set=" ".join([ i for i in sentences_set])
        sentences_set1=[]
        sentences_set2=[]
        for i in sentences_set:
            new_sentence= " ".join([ a.translate(str.maketrans('', '', '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~')) for a in i])
            sentences_set1.append(new_sentence)
        #print("se",sentences_set1)
        for i in sentences_set1:
            new_sentence= i.split("\n")
            if i == sentences_set1[-1]:
                try:
                    new_sentence=new_sentence[1]
                except: 
                    new_sentence=new_sentence[0]

            else:
                new_sentence=new_sentence[0]
            sentences_set2.append(new_sentence)
            
        #sentences_set3 = " ".join([str(i) for i in sentences_set2])
  
        return sentences_set2
    def Scrap_RandomSites(self,search):
        links=self.Scrap_SitesLink(search)
        All_sentences_list=[]
        for i in links:
            response = requests.get(
                    url=i
                )
            soup = BeautifulSoup(response.content, 'html.parser')
            p_lists= soup.find_all("p")
            text_list=[i.text for i in p_lists]
            sentences = [i.split(".") for i in text_list]
            All_sentences_list.append(sentences)
        return All_sentences_list
    def getHeadsWikiAPI(self,query,lang):

        url_tr="https://tr.wikipedia.org/w/api.php"
        url_en = 'https://en.wikipedia.org/w/api.php'
        params = {
                    'action':'query',
                    'format':'json',
                    'list':'search',
                    'utf8':1,
                    'srsearch':query
                }
        if lang=="en":
            url=url_en
        else:
            url=url_tr
        data = requests.get(url, params=params).json()
        title_list=[]
        for i in data['query']['search']:
            print("title",i["title"])
            title_list.append(i['title'])
        return title_list[0]
    def getWikiAPI(self,search,lang,index):
        url_en = 'https://en.wikipedia.org/w/api.php'
        url_tr="https://tr.wikipedia.org/w/api.php"

        if lang=="en":
            url=url_en
            search=translator.translate_text([search],"en")
        else:
            url=url_tr
        
        subject=self.getHeadsWikiAPI(search,lang)

        params = {
                'action': 'query',
                'format': 'json',
                'titles': subject,
                'prop': 'extracts',
                'exintro': True,
                'explaintext': True,
            }
        
        response = requests.get(url, params=params)
        data = response.json()
        
        page = next(iter(data['query']['pages'].values()))
        text=page['extract']
        
        print("TEXT ",text.split(".")[:index])
           
            
        return text.split(".")[:index]

#webscrap = WebScrap_HakanAI()
#sentences_wiki=webscrap.getHeadsWikiAPI(query="a",lang="tr")
#print(sentences_wiki)