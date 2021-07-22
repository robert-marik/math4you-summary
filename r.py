#! /usr/bin/python
# -*- coding: utf-8 -*-

import csv
import os
import time
import sys
import hashlib
from datetime import datetime, timedelta

subarea=str(sys.argv[1])
if subarea=="":
    subarea="50"


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
            database.append(row)

SORT_ORDER = {"A": 0, "B": 1, "C": 2}

database.sort(key=lambda val: SORT_ORDER[val['level']])

downloadfiles=True
#downloadfiles=False

#os.remove("*.out")

#for i in filenames:

open("tex/"+subarea+'.tex', 'w')
open("html/"+subarea+'.html', 'w') 
open("html/"+subarea+'_recent_7.html', 'w') 
open("html/"+subarea+'_recent_14.html', 'w') 
open("csv/"+subarea+'.md5', 'w') 

    
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
            print "Downloading "+img
            os.system("wget https://math4u.vsb.cz/"+img+" -q -O pics/"+str(filename[-1]))
            if filename[-1][-4:]==".svg":
                os.system("inkscape --file=pics/"+str(filename[-1])+" --export-area-page --without-gui --export-pdf=pics/"+filenameSVGtoPDF(str(filename[-1])))


for row in database:
    download_images(row['question_image'])
    if "answer_1_image" in row:
        for number in ['1','2','3','4','5','6']:
            download_images(row['answer_'+str(number)+'_image'])
            for l in ['en','cs','pl','sk']:
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
    testenmd5=hashlib.md5(testen).hexdigest()
    testcsmd5=hashlib.md5(testcs).hexdigest()
    testplmd5=hashlib.md5(testpl).hexdigest()
    testskmd5=hashlib.md5(testsk).hexdigest()
    if testen==testcs:
        row['answer_1_cs']=""
        row['answer_2_cs']=""
        row['answer_3_cs']=""
        row['answer_4_cs']=""
        row['answer_5_cs']=""
        row['answer_6_cs']=""
        row['question_cs']="NOT TRANSLATED"
    if testen==testsk:
        row['answer_1_sk']=""
        row['answer_2_sk']=""
        row['answer_3_sk']=""
        row['answer_4_sk']=""
        row['answer_5_sk']=""
        row['answer_6_sk']=""
        row['question_sk']="NOT TRANSLATED"
    if testcs==testsk:
        row['answer_1_sk']=""
        row['answer_2_sk']=""
        row['answer_3_sk']=""
        row['answer_4_sk']=""
        row['answer_5_sk']=""
        row['answer_6_sk']=""
        row['question_sk']="NOT TRANSLATED"
    if testen==testpl:
        row['answer_1_pl']=""
        row['answer_2_pl']=""
        row['answer_3_pl']=""
        row['answer_4_pl']=""
        row['answer_5_pl']=""
        row['answer_6_pl']=""
        row['question_pl']="NOT TRANSLATED"
    if testcs==testpl:
        row['answer_1_pl']=""
        row['answer_2_pl']=""
        row['answer_3_pl']=""
        row['answer_4_pl']=""
        row['answer_5_pl']=""
        row['answer_6_pl']=""
        row['question_pl']="NOT TRANSLATED"
    for lang in ['en','pl','cs','sk']:
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
    outstr="\n"
    outstr=outstr+"<div class='Question'><span class='header'><span class='id'>"+row['project_id']+"</span>\n"
    outstr=outstr+"<span class='updated'>"+row['updated']+"</span>\n"
    outstr=outstr+"<span class='level'>"+row['level']+"</span>\n"
    outstr=outstr+"<span class='subarea'>"+row['subarea']+"</span></span>\n"
    for lang in ['en','pl','cs','sk']:
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
    with open("html/"+row['subarea_id']+'.html', 'a') as the_file:
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
        with open("html/"+row['subarea_id']+"/"+row['project_id']+"_en.html", 'a') as the_file:
            the_file.write(outstr)

    if not databasemd5.has_key(row['project_id']+"_cs") or databasemd5[row['project_id']+"_cs"][0]!=testcsmd5:
        if testcsmd5 != testenmd5:
            databasemd5[str(row['project_id'])+"_cs"]=[testcsmd5,str(datetime.now()).split(" ")[0]]
            with open("html/"+row['subarea_id']+"/"+row['project_id']+"_cs.html", 'a') as the_file:
                the_file.write(outstr)

    if not databasemd5.has_key(row['project_id']+"_sk") or databasemd5[row['project_id']+"_sk"][0]!=testskmd5:
        if testskmd5 != testenmd5 and testskmd5 != testcsmd5:
            databasemd5[str(row['project_id'])+"_sk"]=[testskmd5,str(datetime.now()).split(" ")[0]]
            with open("html/"+row['subarea_id']+"/"+row['project_id']+"_sk.html", 'a') as the_file:
                the_file.write(outstr)

    if not databasemd5.has_key(row['project_id']+"_pl") or databasemd5[row['project_id']+"_pl"][0]!=testplmd5:
        if testplmd5 != testenmd5 and testplmd5 != testcsmd5:
            databasemd5[str(row['project_id'])+"_pl"]=[testplmd5,str(datetime.now()).split(" ")[0]]
            with open("html/"+row['subarea_id']+"/"+row['project_id']+"_pl.html", 'a') as the_file:
                the_file.write(outstr)


with open("csv/"+row['subarea_id']+'.md5', 'a') as the_file:
    for i in  databasemd5:
        the_file.write("%s;%s;%s\n"%(i, databasemd5[i][0], databasemd5[i][1]))


