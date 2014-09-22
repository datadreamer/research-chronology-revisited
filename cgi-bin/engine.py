#!/usr/bin/python

# RESEARCH CHRONOLOGY 2
# by Aaron Siegel

import cgi, string, pydelicious

revision = "03"

#----------------------------------------------------------

def getAll(u,p):
    d = pydelicious.apiNew(u,p)
    posts = d.posts_all()
    return posts

#----------------------------------------------------------

def makeXML(postlist):
    xml_out = "<postlist>"
    for p in postlist:
        #print p
        xml_out += "<post>"
        xml_out += "<date>"
        date,time = p["dt"].split("T")
        xml_out += str(date)
        xml_out += "</date>"
        xml_out += "<time>"
        xml_out += str(time.rstrip("Z"))
        xml_out += "</time>"
        xml_out += "<desc>"
        xml_out += p["description"].encode("ascii", "replace").replace("&", "and")
        xml_out += "</desc>"
        xml_out += "<url>"
        xml_out += str(p["href"].replace("&", "%26"))
        xml_out += "</url>"
        xml_out += "<tags>"
        xml_out += p["tags"].encode("ascii", "replace").replace("&", "")
        xml_out += "</tags>"
        xml_out += "</post>"
    xml_out += "</postlist>"
    print xml_out

#----------------------------------------------------------
# INITIALIZE PROGRAM

def main():
    #print "Content-Type: text/plain\n"
    print "Content-Type: text/xml\n"                # define output type for web browser
    form = cgi.parse()                              # seperate query string into dictionary
    if form.has_key("user"):
        username = form["user"][0]
        password = form["pass"][0]
    else:
        username = "USERNAME_GOES_HERE"
        password = "PASSWORD_GOES_HERE"
    posts = getAll(username, password)
    makeXML(posts)

main()
