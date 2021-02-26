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

#print len(definice_otazek)
#print subarea,language

database=[]
databasedict={}

filenames=set()

with open('csv/all_text.csv', 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['answer_5_en']!="":
            print row['project_id']


with open("csv/problem_img.csv", 'rb') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if row['answer_5_image']!="":
            print row['project_id']

