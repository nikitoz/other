import urllib2
import re

archive = "http://www.geeksforgeeks.org/archives/[0-9]{5}"
url = "http://www.geeksforgeeks.org/amazon-interview-set-"

hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Accept-Language': 'en-US,en;q=0.8',
       'Connection': 'keep-alive'}

set_no_begin = 9
set_no_end   = 10

def foo() :
    for i in range(set_no_begin, set_no_end):
        t = urllib2.Request("http://www.geeksforgeeks.org/archives/11024", headers = hdr)
        f = open("D:/aiq/" + "hello" + ".htm", "wt")
        f.write(urllib2.urlopen(url).read())
        f.close()

def bar() :
    f = open("D:/aiq/f.txt", "rt")
    data = f.read()
    a = re.findall(archive, data)
    name = "alg"
    add = 1
    for t in a :
        try:
            req = urllib2.Request(t, headers=hdr)
            f = open("d:/aiq/" + name + str(add) + ".htm", "wt")
            f.write(urllib2.urlopen(t).read())
            f.close()
            add = add + 1
        except urllib2.HTTPError:
            pass

def baz() :
    t = urllib2.Request("http://www.geeksforgeeks.org/archives/11064", headers = hdr)
    f = open("d:/aiq/" + "a" + ".htm", "wt")
    f.write(urllib2.urlopen(t).read())
    f.close()


bar()
