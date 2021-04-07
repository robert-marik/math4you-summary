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
subareaToName("40","Systems of equations and inequalities")
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

langlist=['en','pl','cs','sk','es']


id=0

database=[]

with open("csv/problem_txt_un.csv", 'r') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        database.append(row)
        #if row['state']=="translation":
        #    database.append(row)
        #if row['state']=="qa":
        #    database.append(row)
            
with open("csv/problem_img_un.csv", 'r') as csvfile:
    spamreader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    for row in spamreader:
        if "href" in row['title']:
           row['title'] = row['title'][0:-4]
           row['title'] = row['title'][-10:]
        database.append(row)
        # if row['state']=="translation":
        #     database.append(row)
        # if row['state']=="qa":
        #     database.append(row)

      
import pandas as pd

df = pd.DataFrame(database)
df1 = df[['project_id','level','subarea_id','subarea','clonable','easy','source_nid','state']]
df1 = df[['subarea','state','clonable','easy']]

dfEasy=df1[df1['easy']=="1"]
dfClon=df1[df1['clonable']=="1"]
#dfBoth=df1[(df1['clonable']=="1") & (df1['easy']=="1") ]


#pd.set_option('display.max_rows', df1.shape[0]+1)
#print(df1)
#print (df1.groupby(by=["state","subarea"]).size())

print ("Easy\n")
print ("--------------------------------------\n")
results = dfEasy.groupby(by=["state","subarea"]).size()
results_df = pd.DataFrame(results)
results_df.to_html('output.html')
print (results)

print ("Clonable\n")
print ("--------------------------------------\n")

results = dfClon.groupby(by=["state","subarea"]).size()
print (results)
results_df = pd.DataFrame(results)
# then, export to html
results_df.to_html('output.html')
print (results)
