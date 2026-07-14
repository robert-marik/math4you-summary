#! /usr/bin/python
# -*- coding: utf-8 -*-

import csv
import os
import time
import sys
import hashlib
from datetime import datetime, timedelta

limit=5000
csvsoubor='csv/problem_img_un.csv'


# subarea=str(sys.argv[1])
# if subarea=="":
#     subarea="50"

id=0

flag=0

def fixset(text):
    out = text
    out = out.replace("2{,}3{,}4{,}5","2, 3, 4, 5")
    out=out.replace("{,}1{,}",", 1, ")
    out=out.replace("{,}2{,}",", 2, ")
    out=out.replace("{,}3{,}",", 3, ")
    out=out.replace("{,}4{,}",", 4, ")
    out=out.replace("{,}5{,}",", 5, ")
    out=out.replace("{,}6{,}",", 6, ")
    out=out.replace("{,}7{,}",", 7, ")
    out=out.replace("{,}8{,}",", 8, ")
    out=out.replace("{,}9{,}",", 9, ")
    out=out.replace("{,}0{,}",", 0, ")
    return out


def nahrad(text):
    global flag
    out=text
    out=fixset(out)
    out=out.replace("\\text{, }",",\\ ")
    out=out.replace("\\text{ , }",",\\ ")
    out=out.replace("\\text{ ,}",",\\ ")
    out=out.replace("\\text{,}",", ")
    if out!=text:
        #print out
        flag=1
    return out
    

def nahraden(text):
    global flag
    out=text
    #return out
    out=out.replace("1{,}","1.")
    out=out.replace("2{,}","2.")
    out=out.replace("3{,}","3.")
    out=out.replace("4{,}","4.")
    out=out.replace("5{,}","5.")
    out=out.replace("6{,}","6.")
    out=out.replace("7{,}","7.")
    out=out.replace("8{,}","8.")
    out=out.replace("9{,}","9.")
    out=out.replace("0{,}","0.")
    out=out.replace("\\langle","[")
    out=out.replace("\\rangle","]")
    if out!=text:
        #print out
        flag=1
    return out

def row_to_str(row):
    outputstring=""
    for j in ("nid","question_en","question_cs","question_pl","question_sk","question_es"):
        outputstring=outputstring+"\""+row[j]+"\","
    outputstring= outputstring[:-1]
    return outputstring+"\n"
    

database=[]
databaseori=[]
filenames=set()

oricsv="nid,question_en,question_cs,question_pl,question_sk,question_es\n"
newcsv=oricsv

with open(csvsoubor, 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        orioutput=row_to_str(row)
        fixedrow=row
        flag=0
        print row['state']
        if row['state']!='qa':
            continue;
        for key in row.keys():
            fixedrow[key]=nahrad(fixedrow[key])
            if str(key)[-3:]=="_en":
                fixedrow[key]=nahraden(fixedrow[key])
            if str(key)[-3:]=="_es":
                fixedrow[key]=nahraden(fixedrow[key])
        if flag > 0:
            id = id+1
            print row['project_id']
            oricsv=oricsv+orioutput
            newcsv=newcsv+row_to_str(row)
        if id>limit:
            break
print id

with open("import.csv", 'w') as the_file:
     the_file.write(newcsv)

with open("importori.csv", 'w') as the_file:
     the_file.write(oricsv)


sys.exit()

