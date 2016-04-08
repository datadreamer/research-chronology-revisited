#!/home/asiegel/dev/bin/python

import sys
from datetime import datetime
from BeautifulSoup import BeautifulSoup

infile = open("delicious.html")
html = BeautifulSoup(infile)
entries = html.findAll("a")
print("Content-Type: text/xml\n")
print("<postlist>")
for entry in entries:
    title = entry.text.encode("ascii", "replace").decode("utf-8")
    href = entry["href"].encode("ascii", "replace").decode("utf-8")
    dt = int(entry["add_date"]) + 21600
    fulldt = datetime.fromtimestamp(int(dt)).strftime('%Y-%m-%d %H:%M:%S')
    date,time = fulldt.split()
    tags = entry["tags"].replace(" ","").replace(","," ")
    print("<post>")
    print("<date>"+str(date)+"</date>")
    print("<time>"+str(time)+"</time>")
    print("<desc>"+title+"</desc>")
    print("<url>"+str(href)+"</url>")
    print("<tags>"+str(tags)+"</tags>")
    print("</post>")
print("</postlist>")
