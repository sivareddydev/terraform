#!/usr/bin/python
import os
base = '/home/vagrant/'
base_count = 1 - base.count('/')
new_path = base
k = open('inputdirname.json')
cc = 0
oc = 0
line_no = 1
for i in k.readlines():
    cc = i.count(' ')
    if oc < cc:
        new_paths = os.path.join(new_path , i.strip())
    elif cc<oc:
        count = new_path.count('/')
        new_paths = os.path.join(new_path.rsplit('/', count-cc+base_count)[0], i.strip())
    else:
        if line_no == 1 :
            new_paths = os.path.join(new_path, i.strip())
        else:
            new_paths = os.path.join(os.path.dirname(new_path), i.strip())
    print(str(line_no) +'  DIR   '+ new_paths)
    os.mkdir(new_paths, 0755)
    line_no +=1
    oc = cc
    new_path = new_paths

