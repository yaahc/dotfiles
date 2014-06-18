#! /bin/python3

import subprocess
import shlex
import threading

def worker():
    proc = subprocess.Popen(shlex.split('animate /home/jlusby/Dropbox/Pictures/sexy/Archive/6erF2Jc.gif'))
    proc.communicate()

t = threading.Thread(target = worker)
t.daemon = True
t.start()
print("howdy")
a = input("what?")
print("derp")
