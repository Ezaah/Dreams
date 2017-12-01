from urllib.request import Request, urlopen
from urllib.parse import urlencode
from random import randint
from time import sleep, localtime, strftime
from json import dumps
url = 'http://dreams.cuy.cl/users/1/measurements'
for i in range(11520):
    data = {'light': randint(0, 1024), 'sound': randint(0, 1), 'temperature': randint(0, 50), 'humidity': randint(0, 100)}
    req = Request(url=url, data=urlencode(data).encode(), method='POST')
    f = urlopen(req)
    print("Request {}/11520\t{}".format(i+1, strftime("%Y-%m-%d %X", localtime())))
    print("Status: {}".format(f.status))
    print(dumps(data))
    sleep(15)
