#!/usr/bin/env python
# -*- coding:UTF-8 -*-
import os
# 第一种方法
	#os.rename(file, 'MB' + file[nPos:])‘

def mywalk(path):
	for rt, dirs, files in os.walk(path):
		for dir in dirs:
			if path == './':
				subdir =  path + dir
			else:
				subdir =  path + '/' + dir
			print 'subdir: ' + subdir
			mywalk(subdir)
		for file in files:
			
			nPos = file.find('MB')
			if nPos == 0:
				newName = path + '/LJX' + file[2:]
				print 'rename '  + path + file + ' to ' + newName
				os.rename(path + '/' + file, newName)
			else:
				nPos = file.find('MOB')
				if 0 == nPos:
					newName = path + '/LJX' + file[3:]
					print 'rename '  + path + file + ' to ' + newName
					os.rename(path + '/' + file, newName)

mywalk('./')