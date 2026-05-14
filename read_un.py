#! /usr/bin/python
# -*- coding: utf-8 -*-

import csv
import os
import time
import sys
import hashlib
from datetime import datetime, timedelta


seznamKoduPodoblasti={}

def subareaToName(a,b):
   seznamKoduPodoblasti[b]=a 

subareaToName("32","Logic and sets")
subareaToName("33","Elementary arithmetics")
subareaToName("34","Polynomials and fractions")
subareaToName("35","Expressions with powers and roots")
subareaToName("36","Absolute value")
subareaToName("37","Linear equations and inequalities")
subareaToName("38","Quadratic equations and inequalities")
subareaToName("39","Higher degree equations and inequalities")
subareaToName("40","Systems of linear equations and inequalities")
subareaToName("41","Rational equations and inequalities")
subareaToName("42","Absolute value equations and inequalities")
subareaToName("43","Radical equations and inequalities")
subareaToName("44","Equations and inequalities with parameters")
subareaToName("45","Properties of functions")
subareaToName("46","Linear functions")
subareaToName("47","Quadratic functions")
subareaToName("48","Functions with absolute values")
subareaToName("49","Power and radical functions")
subareaToName("50","Rational functions")
subareaToName("51","Exponential functions")
subareaToName("52","Logarithmic functions")
subareaToName("53","Exponential equations and inequalities")
subareaToName("54","Logarithmic equations and inequalities")
subareaToName("55","Angles, arcs and sectors")
subareaToName("56","Sine, cosine, tangent and cotangent")
subareaToName("57","Trigonometric equations and inequalities")
subareaToName("58","Triangles")
subareaToName("59","Polygons")
subareaToName("60","Circles")
subareaToName("61","Lines and planes: intersecting, perpendicular, parallel")
subareaToName("62","Lines and planes: distances and angles")
subareaToName("63","Volume and surface area formulas")
subareaToName("64","Symmetry and geometric transformations")
subareaToName("65","Points and vectors")
subareaToName("66","Analytic geometry in a plane")
subareaToName("67","Analytic geometry in a space")
subareaToName("68","Conics")
subareaToName("69","Complex numbers in algebraic and trigonometric form")
subareaToName("70","Moivre's theorem")
subareaToName("71","Quadratic equations with complex roots")
subareaToName("72","Binomial equations")
subareaToName("73","Combinatorics")
subareaToName("74","Probability")
subareaToName("75","Statistics")
subareaToName("76","Introduction to sequences")
subareaToName("77","Arithmetic sequences")
subareaToName("78","Geometric sequences")
subareaToName("79","Limit of a sequence")
subareaToName("80","Infinite series")
subareaToName("81","Limits and continuity")
subareaToName("82","Derivative")
subareaToName("83","Applications of derivatives")
subareaToName("84","Primitive function")
subareaToName("85","Definite integral")
subareaToName("86","Applications of definite integral")
subareaToName("87","Percent problems")
subareaToName("144","Calculations with logarithms")
subareaToName("130","Analyzing function behavior")

langlist=['en','pl','cs','sk','es']


id=0

database=[]
database_easy=[]

with open("csv/problem_txt_un.csv", 'r') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['state']=="translation":
            database.append(row)
        if row['state']=="qa":
            database.append(row)
        if row['state']=="publish":
            database.append(row)
        if row['easy']=="1":
            database_easy.append(row['title'])
with open("csv/problem_img_un.csv", 'r') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['state']=="translation":
            database.append(row)
        if row['state']=="qa":
            database.append(row)
        if row['state']=="publish":
            database.append(row)
        if row['easy']=="1":
            database_easy.append(row['title'])

SORT_ORDER = {"A": 0, "B": 1, "C": 2}

database.sort(key=lambda val: (SORT_ORDER[val['level']],val['project_id']))

downloadfiles=True
#downloadfiles=False

#os.remove("*.out")

#for i in filenames:


os.system("rm tex_un_qa/* tex_un_qa_easy/*  tex_un_translation/*  html_un_qa/* html_un_qa_easy/* html_un_translation/* html_un_publish/* tex_un_publish/* unmatched_id.txt")
os.system("touch unmatched_id.txt")

typos=""    

txtspell = {'cs':"",'pl':"",'sk':"",'en':"",'es':""}
        
def filenameSVGtoPDF(filename):
    if filename[-9:]==".pdf_.svg":
        return filename[:-5]
    if filename[-4:]==".svg":
        return filename[:-4]+".pdf"
    return filename

def download_images(img):
    if img!="":
        filename=img.split("/")
        if downloadfiles:
            #print "Downloading "+img
            os.system("wget https://math4u.vsb.cz/"+img+" -q -O pics/"+str(filename[-1]))
            if filename[-1][-4:]==".svg":
                os.system("inkscape --file=pics/"+str(filename[-1])+" --export-area-page --without-gui --export-pdf=pics/"+filenameSVGtoPDF(str(filename[-1])))

                

for row in database:
#    if row['state']!="translation" and row['state']!="qa":
#        continue
    
    # fix for missing language in csv
#    if 'answer_1_es' not in row.keys():
#        row['answer_1_es']="NA"
#        row['answer_2_es']="NA"
#        row['answer_3_es']="NA"
#        row['answer_4_es']="NA"
#        row['answer_5_es']="NA"
#        row['answer_6_es']="NA"
#        row['question_es']="NA"


    if row['subarea'] in seznamKoduPodoblasti:
       kod_podoblasti = seznamKoduPodoblasti[row['subarea']]
    else:
       outstr = "Failed to match subarea "+row['subarea']+" in question "+row['project_id']
       print (outstr)
       with open("unmatched_id.txt", 'a') as the_file:
          the_file.write(outstr+"\n")
       continue
    id=id+1
    print("Question "+row['project_id'])
    download_images(row['question_image'])
    if "answer_1_image" in row:
        for number in ['1','2','3','4','5','6']:
            download_images(row['answer_'+str(number)+'_image'])
            for l in langlist:
                row['answer_'+str(number)+'_'+str(l)]=''
    outstr="\n"
    outstr=outstr+"\\Data\\ID{"+row['project_id']+"}\n"
    outstr=outstr+"\\Updated{"+row['updated']+"}\n"
    outstr=outstr+"\\Level{"+row['level']+"}\n"
    outstr=outstr+"\\SubArea{"+row['subarea']+"}\n"
    if row['question_image']!="":
        outstr=outstr+"\\IMG{"+filenameSVGtoPDF(str(row['question_image'].split("/")[-1]))+"}\n"
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
            typos=typos+"\n<br><br><a href='https://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> SPACE.<br>\n"+lang
        if " ," in langtest:
            typos=typos+"\n<br><br><a href='https://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> SPACE,<br>\n"+lang
        if "....." in lang:
            typos=typos+"\n<br><br><a href='https://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> .....<br>\n"+lang
        if "–" in lang:
            typos=typos+"\n<br><br><a href='https://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> – (skarede minus)<br>\n"+lang
        if "--" in lang:
            typos=typos+"\n<br><br><a href='https://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> -- (dve pomlcky z TeXu)<br>\n"+lang
        #if u"\u2061" in lang:
        #    typos=typos+"\n<br><br><a href='https://math4u.vsb.cz/problem/"+row['project_id']+"'>"+row['project_id']+"</a> neviditelny znak (U+2061)<br>\n"+lang
            
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
        outstr=outstr+"\\LANG"+lang+"{\n"
        outstr=outstr+"\\Question{\n"
        outstr=outstr+row['question_'+lang]
        outstr=outstr+"}\n"
        for i in [row['answer_1_'+lang],row['answer_2_'+lang],row['answer_3_'+lang],row['answer_4_'+lang],row['answer_5_'+lang],row['answer_6_'+lang]] :
            outstr=outstr+"{"+i+"}"
        outstr=outstr+"}\n"
    if "answer_1_image" in row:
        for num in ['1','2','3','4','5','6']:
            if row['answer_'+num+'_image']!='':
                outstr=outstr+"\n\\IMGanswer{"+filenameSVGtoPDF(str(row['answer_'+num+'_image'].split("/")[-1]))+"}"
    outstr=outstr+"\\End\n"
    with open("tex_un_"+row["state"]+"/"+(kod_podoblasti)+'.tex', 'a') as the_file:
        the_file.write(outstr)
    if row["state"]=="qa" or row["state"]=="translation":
       with open("tex_un_publish/"+(kod_podoblasti)+'.tex', 'a') as the_file:
          the_file.write(outstr)
    if row["state"]=="qa" and row["easy"]=="1":
       with open("tex_un_qa_easy/"+(kod_podoblasti)+'.tex', 'a') as the_file:
          the_file.write(outstr)

    outstr="\n"
    outstr=outstr+"<div class='Question'><span class='header'>"+str(id)+": <span class='id'>"+row['project_id']+"</span>\n"
    outstr=outstr+"<span class='updated'>"+row['updated']+"</span>\n"
    outstr=outstr+"<span class='level'>"+row['level']+"</span>\n"
    outstr=outstr+"<span class='subarea'>"+row['subarea']+"</span></span>\n"
    for lang in langlist:
        linklang=lang+"/"
        if lang=="en":
            linklang=""
        outstr=outstr+"<div class='container lang"+lang+"'><a href=\"https://math4u.vsb.cz/"+linklang+"problem/"+row['project_id']+"\" target=\"_blank\"><span class='lang'>"+lang+"</span></a><div class='question'>"
        outstr=outstr+row['question_'+lang]
        outstr=outstr+"</div>"
        for i in [row['answer_1_'+lang],row['answer_2_'+lang],row['answer_3_'+lang],row['answer_4_'+lang],row['answer_5_'+lang],row['answer_6_'+lang]] :
            if i!="":
                outstr=outstr+"<div class='answer'>"+i+"</div>"
        outstr=outstr+"</div>\n"
    if row['question_image']!="":
        outstr=outstr+"<img src=pics/"+str(row['question_image'].split("/")[-1])+">"
    if "answer_1_image" in row:
        for num in ['1','2','3','4','5','6']:
            if row['answer_'+num+'_image']!='':
                outstr=outstr+"<img src=pics/"+str(row['answer_'+num+'_image'].split("/")[-1])+">"
    outstr=outstr+"</div>\n"
    with open("html_un_"+row["state"]+"/"+(kod_podoblasti)+'.html', 'a') as the_file:
        the_file.write(outstr)
    if row["state"]=="qa" or row["state"]=="translation":
       with open("html_un_publish/"+(kod_podoblasti)+'.html', 'a') as the_file:
          the_file.write(outstr)
    if row["state"]=="qa" and row["easy"]=="1":
       with open("html_un_qa_easy/"+(kod_podoblasti)+'.html', 'a') as the_file:
          the_file.write(outstr)

