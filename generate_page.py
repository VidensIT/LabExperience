from urllib2 import urlopen
my_ip = urlopen('http://ip.42.pl/raw').read()

html = open('page.html','r')

new_html = (html.read().replace('<<IP>>', my_ip))
html.close()

file = open('index.html', 'w')

file.write(new_html)
file.close()
