#! /usr/bin/python
# -*- coding: utf-8 -*-

import csv
import os
import time
import sys
import hashlib
from datetime import datetime, timedelta


langlist=['en','pl','cs','sk','es']

subarea=str(sys.argv[1])
if subarea=="":
    subarea="77"

id=0


seznam_vzoru=[]
with open("csv/"+subarea+'.csv', 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['source_nid']!="":
            seznam_vzoru.append(row['source_nid'])

print seznam_vzoru
          
with open("html_clonable/report_clonable.php", 'a') as the_file:
            the_file.write("<?php \n polozka( "+str(subarea)+","+str(len(seznam_vzoru))+"); \n ?> \n\n")

database=[]
filenames=set()
with open("csv/"+subarea+'.csv', 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        database.append(row)
        filenames.add(row['subarea_id'])

databasemd5={}

if os.path.isfile("csv/"+subarea+'.md5'):
    with open("csv/"+subarea+'.md5') as f:
        for lline in f:
            line=lline.split(";")
            databasemd5[line[0]]=[line[1],line[2].strip()]


with open("csv/problem_img.csv", 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['subarea_id'] == subarea:
            if "href" in row['title']:
                row['title'] = row['title'][30:-4]
            database.append(row)

database_easy=[]
with open("easy.csv", 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        database_easy.append(row['title'])

database_clonable=[]
with open("clonable.csv", 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        database_clonable.append(row['title'])

SORT_ORDER = {"A": 0, "B": 1, "C": 2}

database.sort(key=lambda val: (SORT_ORDER[val['level']],val['project_id']))

downloadfiles=True
#downloadfiles=False

#os.remove("*.out")

#for i in filenames:

open("tex/"+subarea+'.tex', 'w')
open("html/"+subarea+'.html', 'w') 
open("tex_easy/"+subarea+'.tex', 'w')
open("html_easy/"+subarea+'.html', 'w') 
open("tex_clonable/"+subarea+'.tex', 'w')
open("html_clonable/"+subarea+'.html', 'w') 
open("html/"+subarea+'_recent_7.html', 'w') 
open("html/"+subarea+'_recent_14.html', 'w') 
open("csv/"+subarea+'.md5', 'w') 
typos=""    

txtspell = {'cs':"",'pl':"",'sk':"",'en':"",'es':""}
    
    
def filenameSVGtoPDF(filename):
    if filename[-9:]==".pdf_.svg":
        return filename[:-5]
    if filename[-4:]==".svg":
        return filename[:-4]+".pdf"
    return filename

def download_images(img):
    global downloadfiles
    if img!="":
        filename=img.split("/")
        if downloadfiles:
            print "Downloading "+img
            os.system("wget http://math4u.vsb.cz/"+img+" -q -O pics/"+str(filename[-1]))
            if filename[-1][-4:]==".svg":
                os.system("inkscape --file=pics/"+str(filename[-1])+" --export-area-page --without-gui --export-pdf=pics/"+filenameSVGtoPDF(str(filename[-1])))


for row in database:
    # fix for missing language in csv
    if 'answer_1_es' not in row.keys():
        row['answer_1_es']="NA"
        row['answer_2_es']="NA"
        row['answer_3_es']="NA"
        row['answer_4_es']="NA"
        row['answer_5_es']="NA"
        row['answer_6_es']="NA"
        row['question_es']="NA"
        
    id=id+1
    download_images(row['question_image'])
    if "answer_1_image" in row:
        for number in ['1','2','3','4','5','6']:
            download_images(row['answer_'+str(number)+'_image'])
            for l in langlist:
                row['answer_'+str(number)+'_'+str(l)]=''
    outstr="\n"
    outstr=outstr+"\Data\ID{"+row['project_id']+"}\n"
    outstr=outstr+"\Updated{"+row['updated']+"}\n"
    outstr=outstr+"\Level{"+row['level']+"}\n"
    outstr=outstr+"\SubArea{"+row['subarea']+"}\n"
    if row['question_image']!="":
        outstr=outstr+"\IMG{"+filenameSVGtoPDF(str(row['question_image'].split("/")[-1]))+"}\n"
    testen=row['answer_1_en']+row['answer_2_en']+row['answer_3_en']+row['answer_4_en']+row['answer_5_en']+row['answer_6_en']+row['question_en']
    testcs=row['answer_1_cs']+row['answer_2_cs']+row['answer_3_cs']+row['answer_4_cs']+row['answer_5_cs']+row['answer_6_cs']+row['question_cs']
    testsk=row['answer_1_sk']+row['answer_2_sk']+row['answer_3_sk']+row['answer_4_sk']+row['answer_5_sk']+row['answer_6_sk']+row['question_sk']
    testpl=row['answer_1_pl']+row['answer_2_pl']+row['answer_3_pl']+row['answer_4_pl']+row['answer_5_pl']+row['answer_6_pl']+row['question_pl']
    testes=row['answer_1_es']+row['answer_2_es']+row['answer_3_es']+row['answer_4_es']+row['answer_5_es']+row['answer_6_es']+row['question_es']
    testenmd5=hashlib.md5(testen).hexdigest()
    testcsmd5=hashlib.md5(testcs).hexdigest()
    testplmd5=hashlib.md5(testpl).hexdigest()
    testskmd5=hashlib.md5(testsk).hexdigest()
    testesmd5=hashlib.md5(testes).hexdigest()    
    for lang in [testen,testcs,testpl,testsk,testes]:
        langtest=lang.replace("\\text{ ,","").replace("\\text{ .","").replace(" ...","")
        if " ." in langtest:
            typos=typos+"\n<br><br><a href='http://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> SPACE.<br>\n"+lang
        if " ," in langtest:
            typos=typos+"\n<br><br><a href='http://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> SPACE,<br>\n"+lang
        if "....." in lang:
            typos=typos+"\n<br><br><a href='http://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> .....<br>\n"+lang
        if "–" in lang:
            typos=typos+"\n<br><br><a href='http://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> – (skarede minus)<br>\n"+lang
        if "--" in lang:
            typos=typos+"\n<br><br><a href='http://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> -- (dve pomlcky z TeXu)<br>\n"+lang
        #if u"\u2061" in lang:
        #    typos=typos+"\n<br><br><a href='http://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> neviditelny znak (U+2061)<br>\n"+lang
            
#    if testen==testcs:
#        row['answer_1_cs']=""
#        row['answer_2_cs']=""
#        row['answer_3_cs']=""
#        row['answer_4_cs']=""
#        row['answer_5_cs']=""
#        row['answer_6_cs']=""
#        row['question_cs']="NOT TRANSLATED"
#    if testen==testsk:
#        row['answer_1_sk']=""
#        row['answer_2_sk']=""
#        row['answer_3_sk']=""
#        row['answer_4_sk']=""
#        row['answer_5_sk']=""
#        row['answer_6_sk']=""
#        row['question_sk']="NOT TRANSLATED"
#    if testcs==testsk:
#        row['answer_1_sk']=""
#        row['answer_2_sk']=""
#        row['answer_3_sk']=""
#        row['answer_4_sk']=""
#        row['answer_5_sk']=""
#        row['answer_6_sk']=""
#        row['question_sk']="NOT TRANSLATED"
#    if testen==testpl:
#        row['answer_1_pl']=""
#        row['answer_2_pl']=""
#        row['answer_3_pl']=""
#        row['answer_4_pl']=""
#        row['answer_5_pl']=""
#        row['answer_6_pl']=""
#        row['question_pl']="NOT TRANSLATED"
#    if testcs==testpl:
#        row['answer_1_pl']=""
#        row['answer_2_pl']=""
#        row['answer_3_pl']=""
#        row['answer_4_pl']=""
#        row['answer_5_pl']=""
#        row['answer_6_pl']=""
#        row['question_pl']="NOT TRANSLATED"
    for lang in langlist:
        if row['question_'+lang]!="NOT TRANSLATED":
            txtspell[lang]=txtspell[lang]+"\n----------------------------\n\n"+row['project_id']+"\n\n"
            txtspell[lang]=txtspell[lang]+row['question_'+lang]+"\n\n"
            for i in [row['answer_1_'+lang],row['answer_2_'+lang],row['answer_3_'+lang],row['answer_4_'+lang],row['answer_5_'+lang],row['answer_6_'+lang]] :
                if i!="":
                    txtspell[lang]=txtspell[lang]+"\n@ "+i+"\n"
        outstr=outstr+"\LANG"+lang+"{\n"
        outstr=outstr+"\Question{\n"
        outstr=outstr+row['question_'+lang]
        outstr=outstr+"}\n"
        for i in [row['answer_1_'+lang],row['answer_2_'+lang],row['answer_3_'+lang],row['answer_4_'+lang],row['answer_5_'+lang],row['answer_6_'+lang]] :
            outstr=outstr+"{"+i+"}"
        outstr=outstr+"}\n"
    if "answer_1_image" in row:
        for num in ['1','2','3','4','5','6']:
            if row['answer_'+num+'_image']!='':
                outstr=outstr+"\n\IMGanswer{"+filenameSVGtoPDF(str(row['answer_'+num+'_image'].split("/")[-1]))+"}"
    outstr=outstr+"\End\n"
    with open("tex/"+row['subarea_id']+'.tex', 'a') as the_file:
        the_file.write(outstr)
    if row['title'] in database_easy:    
        with open("tex_easy/"+row['subarea_id']+'.tex', 'a') as the_file:
            the_file.write(outstr)
    if row['title'] in database_clonable:    
        with open("tex_clonable/"+row['subarea_id']+'.tex', 'a') as the_file:
            the_file.write(outstr)
    outstr="\n"
    outstr=outstr+"<div class='Question'><span class='header'>"+str(id)+": <span class='id'>"+row['project_id']+"</span>\n"
    outstr=outstr+"<span class='updated'>"+row['updated']+"</span>\n"
    outstr=outstr+"<span class='level'>"+row['level']+"</span>\n"
    outstr=outstr+"<span class='subarea'>"+row['subarea']+"</span></span><div class='original'>\n"
    for lang in langlist:
        linklang=lang+"/"
        if lang=="en":
            linklang=""
        outstr=outstr+"<div class='container lang"+lang+"'><a href=\"http://math4u.vsb.cz/"+linklang+"problem/"+row['project_id']+"\" target=\"_blank\"><span class='lang'>"+lang+"</span></a><div class='question'>"
        outstr=outstr+row['question_'+lang]
        outstr=outstr+"</div>"
        for i in [row['answer_1_'+lang],row['answer_2_'+lang],row['answer_3_'+lang],row['answer_4_'+lang],row['answer_5_'+lang],row['answer_6_'+lang]] :
            if i!="":
                outstr=outstr+"<div class='answer'>"+i+"</div>"
        outstr=outstr+"</div>\n"
    outstr=outstr+"</div>\n"
    if row['nid'] in seznam_vzoru:
        outstr=outstr+"<div class='klon'>\n"
        for hledamklon in database:
            if hledamklon['source_nid']==row['nid']:
                for lang2 in langlist:
                    linklang2=lang2+"/"
                    if lang2=="en":
                        linklang2=""
                    outstr=outstr+"<div class='container lang"+lang2+"'><a href=\"http://math4u.vsb.cz/"+linklang2+"problem/"+hledamklon['project_id']+"\" target=\"_blank\"><span class='lang'>"+lang2+"</span></a><div class='question'>"
                    outstr=outstr+hledamklon['question_'+lang2]
                    outstr=outstr+"</div>"
                    for i in [hledamklon['answer_1_'+lang2],hledamklon['answer_2_'+lang2],hledamklon['answer_3_'+lang2],hledamklon['answer_4_'+lang2],hledamklon['answer_5_'+lang2],hledamklon['answer_6_'+lang2]] :
                        if i!="":
                            outstr=outstr+"<div class='answer'>"+i+"</div>"
                    outstr=outstr+"</div>\n"
        outstr=outstr+"</div>\n"
    if row['question_image']!="":
        outstr=outstr+"<img src=pics/"+str(row['question_image'].split("/")[-1])+">"
    if "answer_1_image" in row:
        for num in ['1','2','3','4','5','6']:
            if row['answer_'+num+'_image']!='':
                outstr=outstr+"<img src=pics/"+str(row['answer_'+num+'_image'].split("/")[-1])+">"
    outstr=outstr+"</div>\n"
    with open("html/"+row['subarea_id']+'.html', 'a') as the_file:
        the_file.write(outstr)
    if row['title'] in database_easy:    
        with open("html_easy/"+row['subarea_id']+'.html', 'a') as the_file:
            the_file.write(outstr)
    if row['title'] in database_clonable:    
        with open("html_clonable/"+row['subarea_id']+'.html', 'a') as the_file:
            the_file.write(outstr)

    updatedtime=time.strptime(row['updated'].split(" ")[0], "%Y-%m-%d") 
    testtime=time.strptime((str(datetime.now() + timedelta(days=-14))).split(" ")[0], "%Y-%m-%d") 
    if updatedtime > testtime:
        with open("html/"+row['subarea_id']+'_recent_14.html', 'a') as the_file:
            the_file.write(outstr)
    testtime=time.strptime((str(datetime.now() + timedelta(days=-7))).split(" ")[0], "%Y-%m-%d") 
    if updatedtime > testtime:
        with open("html/"+row['subarea_id']+'_recent_7.html', 'a') as the_file:
            the_file.write(outstr)
    

    if not databasemd5.has_key(row['project_id']+"_en") or databasemd5[row['project_id']+"_en"][0]!=testenmd5:
        databasemd5[str(row['project_id'])+"_en"]=[testenmd5,str(datetime.now()).split(" ")[0]]
        with open("html/"+row['subarea_id']+"/"+row['project_id']+"_en.html", 'w') as the_file:
            the_file.write(outstr)

    if not databasemd5.has_key(row['project_id']+"_cs") or databasemd5[row['project_id']+"_cs"][0]!=testcsmd5:
        if testcsmd5 != testenmd5:
            databasemd5[str(row['project_id'])+"_cs"]=[testcsmd5,str(datetime.now()).split(" ")[0]]
            with open("html/"+row['subarea_id']+"/"+row['project_id']+"_cs.html", 'w') as the_file:
                the_file.write(outstr)

    if not databasemd5.has_key(row['project_id']+"_sk") or databasemd5[row['project_id']+"_sk"][0]!=testskmd5:
        if testskmd5 != testenmd5 and testskmd5 != testcsmd5:
            databasemd5[str(row['project_id'])+"_sk"]=[testskmd5,str(datetime.now()).split(" ")[0]]
            with open("html/"+row['subarea_id']+"/"+row['project_id']+"_sk.html", 'w') as the_file:
                the_file.write(outstr)

    if not databasemd5.has_key(row['project_id']+"_pl") or databasemd5[row['project_id']+"_pl"][0]!=testplmd5:
        if testplmd5 != testenmd5 and testplmd5 != testcsmd5:
            databasemd5[str(row['project_id'])+"_pl"]=[testplmd5,str(datetime.now()).split(" ")[0]]
            with open("html/"+row['subarea_id']+"/"+row['project_id']+"_pl.html", 'w') as the_file:
                the_file.write(outstr)


with open("csv/"+row['subarea_id']+'.md5', 'a') as the_file:
    for i in  databasemd5:
        the_file.write("%s;%s;%s\n"%(i, databasemd5[i][0], databasemd5[i][1]))

with open("html/typo.html",'a') as typosfile:
    typosfile.write(typos)


for lang in langlist:
    with open("txt/"+subarea+"_"+lang+".txt", 'w') as the_file:
        the_file.write(txtspell[lang])
