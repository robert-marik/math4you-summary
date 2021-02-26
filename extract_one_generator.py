#! /usr/bin/python
# -*- coding: utf-8 -*-

import csv
import os
import time
import sys
import hashlib
import random
from datetime import datetime, timedelta

definice_otazek=[]

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
    
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-f", "--file")

args = parser.parse_args()
soubor_def=args.file

if soubor_def==None:
    soubor_def="soubor.def"

with open(soubor_def) as f:
    for lline in f:
        definice_otazek=definice_otazek+[lline.strip()]

subarea=definice_otazek.pop(0)
language=definice_otazek.pop(0)

#print len(definice_otazek)
#print subarea,language

database=[]
databasedict={}

filenames=set()

with open('csv/all_text.csv', 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['title'] in definice_otazek:
            #print row['title']
            database.append(row)
            databasedict[row['title']]=row


with open("csv/problem_img.csv", 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['title'].replace('en/problem/',"problem/").replace('<a href="/problem/',"").split('"')[0] in definice_otazek:
            #print row['title']
            database.append(row)
            databasedict[row['title'].replace('en/problem/',"problem/").replace('<a href="/problem/',"").split('"')[0]]=row


vyjimky={}
with open("vyjimky.txt", 'r') as vyjimkyfile:
   for line in vyjimkyfile:
       if line[0]!="%":
           linesplit=line.strip().split(":")
           vyjimky[linesplit[0]]=linesplit[1]

databasemd5={}

#print len(database)
#print database

n=0

output=""
klic=""

for rrow in definice_otazek:
    if rrow in databasedict:
        row = databasedict[rrow]
    else:
        print "%Chybi otazka "+str(rrow)
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
            #a1=answers.pop(0)
            #random.shuffle(answers)
            #answers=[a1]+answers # shuffle answers and keep the first one
            #if len(answers)>4:
            #    answers=answers[:4]
            random.shuffle(answers)
        klic=klic+str(n)+find_leading_star(answers)+", "    
        output=output+"\n{"+', '.join(str(x) for x in answers)+"}\n"
        output=output+"}\n"
        #get_index = [i for (y, i) in zip(answers, range(len(answers))) if y[0]=="*"]
        #print get_index[0]+1
        #print [remove_leading_star(i) for i in answers]
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
            #a1=answers.pop(0)
            #random.shuffle(answers)
            #answers=[a1]+answers # shuffle answers and keep the first one
            #if len(answers)>4:
            #    answers=answers[:4]
            random.shuffle(answers)
        klic=klic+str(n)+find_leading_star(answers)+", "    
        output=output+"\n{"+', '.join(str(x) for x in answers)+"}\n"


print output
print
print "\\gdef\\mfuAnswers{"+klic+"}"

exit()

