#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Feb 26 11:12:55 2023

@author: marik
"""

import pandas as pd

file = "csv/all_text.csv"

df_ = pd.read_csv(file)


df = df_[df_['question_en'].str.contains(r"\\vec")]

#print(df)

head = """
<script>
MathJax = {
  svg: {
    fontCache: 'global'
  }
};
</script>
<script
  type="text/javascript" id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js">
</script>
"""

print(head)
for index,row in df[['title','question_en']].iterrows():
    print ("<li><a href='https://math4u.vsb.cz/problem/"+row['title']+"'>"+row['title']+"</a><div class='otazka'>"+row['question_en']+"</div><pre>"+row['question_en']+"</pre>")