#import pandas as pd


import csv
import random
import os

def filenameSVGtoPDF(filename):
    if filename[-9:]==".pdf_.svg":
        return filename[:-5]
    if filename[-4:]==".svg":
        return filename[:-4]+".pdf"
    return filename

def remove_leading_star(x):
    if x[0]=="*":
        return x[1:]
    else:
        return x

def find_leading_star(fa):
    fj=0
    for fjj in fa:
        fj=fj+1
        if fjj[0]=="*":
            return chr(96+fj)

def get_questions(definice_otazek,language='en'):
  """
  Extracts the equations for the language. Returns the content od the questions environment.
  """

  database = []
  databasedict={}
  #filenames=set()

  with open('csv/all_text.csv', 'r') as csvfile:
      spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
      for row in spamreader:
          if row['nid'] in definice_otazek:
              #print row['title']
              database.append(row)
              databasedict[row['nid']]=row

  with open("csv/problem_img.csv", 'r') as csvfile:
      spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
      for row in spamreader:
          if row['nid'] in definice_otazek:
              #print row['title']
              database.append(row)
              databasedict[row['nid'].split('"')[0]]=row

  vyjimky={}
  with open("vyjimky.txt", 'r') as vyjimkyfile:
    for line in vyjimkyfile:
        if line[0]!="%":
            linesplit=line.strip().split(":")
            vyjimky[linesplit[0]]=linesplit[1]

  n=0
  output=""
  klic=""

  for rrow in definice_otazek:

      if rrow in databasedict:
          row = databasedict[rrow]
      else:
          print ("%Chybi otazka "+str(rrow))
          continue
      n=n+1
      if "answer_1_cs" in row:  # text answer
          if row["question_image"]!="":
              opt_picture="image="+filenameSVGtoPDF(str(row['question_image'].split("/")[-1]))
          else:
              opt_picture=""
          optvyjimka=""
          if row['title'] in vyjimky:
              optvyjimka=","+vyjimky[row['title']]
          output=output+"\n\n{"
          if row['fixed_answer']=="1" or row['fixed_answer']=="2": 
              output=output+"\\NepermutujKonec\n"
          output=output+"\\sablona["+opt_picture+optvyjimka+"]{"+row['question_'+language]+"}"
          answers=[]
          for i in ['1','2','3','4','5','6']:
              if row['answer_'+i+'_'+language]!="":
                  answers=answers+["{"+row['answer_'+i+'_'+language]+"}"]
          answers[0]="*"+answers[0]
          if row['fixed_answer']=="1":
              answers=answers[::-1] #reverse
          if row['fixed_answer']=="1" or row['fixed_answer']=="2": 
              copy=answers[:-1]
              random.shuffle(copy)
              answers=copy+[answers[-1]]
          else:
              random.shuffle(answers)
          klic=klic+str(n)+find_leading_star(answers)+", "    
          output=output+"\n{"+', '.join(str(x) for x in answers)+"}\n"
          output=output+"}\n"
      else: # image answer
          optvyjimka=""
          if row['title'].replace('<a href="/problem/',"").split('"')[0] in vyjimky:
              optvyjimka=","+vyjimky[row['title'].replace('<a href="/problem/',"").split('"')[0]]
          if row["question_image"]!="":
              opt_picture="[image="+filenameSVGtoPDF(str(row['question_image'].split("/")[-1]))+",sablona=B"+optvyjimka+"]"
          else:
              opt_picture="["+optvyjimka+"]"
          output=output+"\n\n\\sablonaIMG"+opt_picture+"{"+row['question_'+language]+"}"
          answers=[]
          for i in ['1','2','3','4','5','6']:
              if row['answer_'+i+'_image']!="":
                  answers=answers+["\MYincludegraphics{%s}"%filenameSVGtoPDF(str(row['answer_'+i+'_image'].split("/")[-1]))]
          answers[0]="*"+answers[0]
          if row['fixed_answer']=="1":
              answers=answers[::-1] #reverse
          if row['fixed_answer']=="1" or row['fixed_answer']=="2": 
              copy=answers[:-1]
              random.shuffle(copy)
              answers=copy+[answers[-1]]
          else:
              random.shuffle(answers)
          klic=klic+str(n)+find_leading_star(answers)+", "    
          output=output+"\n{"+', '.join(str(x) for x in answers)+"}\n"

  return output + r"\gdef\mfuAnswers{"+klic+"}"




from string import Template

template_perm = r"""
\pdfminorversion=4
\nonstopmode
%options
$options
\documentclass{vsb_m4u}

%%MSR
\def\projectID#1{}

\title{$TITLE}
\Oblast{}
\renewcommand{\parallel}{\mathrel{|\mkern-.8mu|}} 
%%MSR


\begin{document} 

\begin{quiz}{msr}
\begin{questions}

$questions

\end{questions} \end{quiz} \end{document}
"""
template_noperm = r"""
\pdfminorversion=4
\nonstopmode
%options
$options
\documentclass[nepermutuj]{vsb_m4u}

\def\projectID#1{}
%%MSR

\title{$TITLE}
\Oblast{}
\renewcommand{\parallel}{\mathrel{|\mkern-.8mu|}} 
%%MSR


\begin{document} 

\begin{quiz}{msr}
\begin{questions}

$questions

\end{questions} \end{quiz} \end{document}
"""
template_paper = r"""
\nonstopmode

\documentclass[10pt,twoside]{article}
\def\projectID#1{\par\bigskip #1\par}
\def\projectID#1{}
\usepackage{hyperref, graphicx, xcolor}
\usepackage[forpaper,pdftex]{exerquiz}
\usepackage{geometry, mi21, m4u-skeletons, amsmath, amsfonts, tikz}
\geometry{margin=1in}
\geometry{a5paper, margin=0.75cm, bottom=1.5cm, top=1.5cm}
\def\thepage{}

%BABEL
%options

$BABEL

\usepackage{eurosym}
\DeclareUnicodeCharacter{20AC}{\euro}

\input m4u-spolecne.tex
\newcommand\NepermutujKonec[1][1]{}
\newcommand\Nepermutuj{}

\newenvironment{blok}{\bigskip\bigskip\item\begin{minipage}[t]{\linewidth}}{\end{minipage}}
\makeatletter
\newif\if@msr@pointsfield
\renewcommand\eq@bqlabel{}
\renewcommand\eq@eqlabel{}

\def\MYincludegraphics#1{\setbox0=\hbox{\includegraphics[width=0.85\linewidth]{#1}}%
\ifdim\ht0>0.35\vsize \setbox0=\hbox{\includegraphics[height=0.35\vsize]{#1}}\fi
\setbox1=\hbox{\includegraphics{#1}}%
\ifdim\wd1>\wd0 \(\vcenter{\box0}\) \else \(\vcenter{\box1}\) \fi}

\makeatother

\def\projectID#1{}

%%MSR

\title{$TITLE}
\def\savetitle{$TITLE}
\date{}
\author{}

%%MSR
\pagestyle{myheadings}
\markboth{\footnotesize \LangStrana\ \protect\arabic{page}}{\footnotesize\LangStrana\ \protect\arabic{page}}

\rowsepDefault{10pt}
\setlength\aboveanswersSkip{20pt}
\renewcommand{\parallel}{\mathrel{|\mkern-.8mu|}} 
\begin{document} 

\definecolor{myblue}{HTML}{6487D2}

\vspace*{-1cm}
\hbox to \hsize{%\vrule
  \begin{minipage}[t]{3cm}
    \leavevmode     
  %\includegraphics[width=3cm]{MATH4T_logo_print.pdf}
  \includegraphics[width=3cm]{Math4Teacher_logo.png}
\end{minipage}
\hss {\color{myblue} \vrule}\hss
\begin{minipage}[t]{9cm}
  \vspace*{-1cm}
  \footnotesize
  \MFUmanifest
\end{minipage}%\vrule
}

\bigskip
\bigskip

\noindent {\Large  \bfseries \savetitle

  }

  \vspace*{-0.5cm}
  \thispagestyle{empty}
  
\begin{quiz}{msr}
\begin{questions}
  
$questions

\end{questions} \end{quiz} 

\makeatletter
\clearpage
\ifodd\c@page\else  \hbox{}\thispagestyle{empty}\newpage\fi
\makeatother

\thispagestyle{empty}



\OdpovediFinal (\savetitle):
\mfuAnswers

\makeatletter
\clearpage
\ifodd\c@page\else  \hbox{}\thispagestyle{empty}\newpage\fi
\makeatother

\end{document}
"""


def get_file_latex(title="title",lang='en', questions=[], template=template_perm, options=''):

  jazyk={}
  jazyk['cs']=r"""
  \usepackage[czech]{babel}  
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{lmodern}
  
  \def\MFUmanifest{Tento test byl vygenerován v aplikaci Math4Teacher,\\ která je součástí vzdělávacího portálu \texttt{math4u.vsb.cz}.}
  \def\OdpovediFinal{Odpovědi}
  \def\LangStrana{Strana}
  """

  jazyk['sk']=r"""
  \usepackage[slovak]{babel}
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{lmodern}
  
  \def\MFUmanifest{Tento test bol vygenerovaný v aplikácii Math4Teacher,\\ ktorá je súčasťou vzdelávacieho portálu \url{math4u.vsb.cz}.}
  \def\OdpovediFinal{Riešenie}
  \def\LangStrana{Strana}
  """

  jazyk['pl']=r"""
  \usepackage[polish]{babel}
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{lmodern}
  
  \def\MFUmanifest{Ten test został wygenerowany w aplikacji Math4Teacher,\\ czesci portalu edukacyjnego \url{math4u.vsb.cz}.}
  \def\OdpovediFinal{Odpowiedzi}
  \def\LangStrana{Strona}
  """

  jazyk['es']=r"""
  \usepackage[spanish]{babel}
  \decimalpoint
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{lmodern}
  
  \def\MFUmanifest{Este test se ha generado con la sección Math4Teacher,\\ una parte del portal educativo \url{math4u.vsb.cz}.}
  \def\OdpovediFinal{Respuestas}
  \def\LangStrana{Página}
  """

  jazyk['en']=r"""
  \usepackage[T1]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{lmodern}
  
  \def\LangStrana{Page}
  \def\MFUmanifest{This test has been generated in the Math4Teacher application,\\ a part of the educational portal \texttt{math4u.vsb.cz}.}
  \def\OdpovediFinal{Answers}
  """

  s = Template(template)
  a = s.substitute(TITLE=title, questions=get_questions(questions, language = lang), lang = lang, options=options, BABEL=jazyk[lang])
  return(a)



import requests
from requests.auth import HTTPBasicAuth

#from pprint import pp
from pprint import pprint as pp
#def pp(a):
#  print(a)

host = 'https://api.math4u.vsb.cz/'
api = 'jsonapi/'

# Login
pp('Login')
payload = {
    "name": "tex",
    "pass": "texarka@math4u"
}

r = requests.post(host + 'user/login?_format=json', json=payload)

if r.status_code != 200:
    pp(r.status_code)
    pp('exiting ...')
    exit
else:
    accessToken = r.json()['access_token']

pp(r.status_code)
#pp(accessToken)


# Get changes
pp('Get')

headers = {
    'Accept': 'application/vnd.api+json',
    'Authorization': 'Bearer ' + accessToken,
    'Content-Type': 'application/vnd.api+json'
}


params = {
    'fields[node--pdf_test]': 'drupal_internal__nid,title,field_test_problems,created,changed,langcode,field_pdf_test_type,field_pdf_test_link,field_pdf_test_generate',
    'filter[field_pdf_test_generate]': 1
}

r = requests.get(host + api + 'node/pdf_test', headers= headers, params=params)

pp(r.status_code)
pp(r.json())
data = r.json()['data']
pocitadlo = 0


for i in data:
    pocitadlo = pocitadlo + 1    
    title = i['attributes']['title']
    lang = i['attributes']['langcode']
    id = i['id']
    questions = [str(j) for j in i['attributes']['field_test_problems']]
    nid = i['attributes']['field_test_problems']
    pdflink = i['attributes']['field_pdf_test_link']
    typ = i['attributes']['field_pdf_test_type']
    options = ""
    if typ == 'w':
        template = template_paper
    elif typ == 'i':
        template = template_noperm
        options = r"\PassOptionsToClass{"+lang+"}{vsb_m4u}"
    else:
        template = template_perm
        options = r"\PassOptionsToClass{"+lang+"}{vsb_m4u}"
    print(title+" "+lang+" "+id+" "+str(pdflink))
    test = get_file_latex(questions=questions,lang=lang, title=title, template = template, options=options)
    text_file = open("buildAPI/"+id+".tex", "w")
    n = text_file.write(test)
    text_file.close()
    if typ == 'w':
        os.system("bash prelatex_substitution.sh buildAPI/%s.tex; cd buildAPI ; export TEXINPUTS=\".:..//:\" ; pdflatex %s.tex > /dev/null ; pdflatex %s.tex > /dev/null ; pdfnup --batch --suffix 2up %s.pdf ; rm %s.pdf; mv %s-2up.pdf /var/www/m4uproject/m4u-cache/pdf/api/%s.pdf ; mv %s.log log/ ; echo Finished written test"%(id,id,id,id,id,id,id,id))
    else:
        os.system("bash prelatex_substitution.sh buildAPI/%s.tex; cd buildAPI ; export TEXINPUTS=\".:..//:\" ; pdflatex %s.tex > /dev/null ; pdflatex %s.tex > /dev/null ; pdflatex %s.tex > /dev/null ; mv %s.pdf /var/www/m4uproject/m4u-cache/pdf/api/ ; mv %s.log log/ ; echo Finished etest"%(id,id,id,id,id,id))



    pp('Patch')
    uri = 'https://msr-latex.vsb.cz/m4uproject/m4u-cache/pdf/api/'+id+'.pdf'
    
    payload = {
        "data": {
            "type": "node--pdf_test",
            "id": id,
            "attributes": {
                "field_pdf_test_generate": 0,
                "field_pdf_test_link": {
                    "uri": uri
                }
            }
        }
    }
    r = requests.patch(host + api + 'node/pdf_test/' + id, headers= headers, json=payload)
    pp(r.status_code)
    

os.system("bash generuj_hlasky.sh ; cd buildAPI && rm *.aux *.cut *.reseni")


# TODO extract values from r.json

# Patch values demo

#pp( r.json())

