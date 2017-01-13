import sys
import re

commentRegex = re.compile(r"COMMENT.*[\"\'].*[\"\']")
textRegex = re.compile(r"LONGTEXT|MEDIUMTEXT")
indexRegex = re.compile(r" [oO][nN] ")

# strip COMMENT and mysql comments

src = sys.stdin.readlines()
dest = []
for i in range(0,len(src)):
	line = src[i].strip()
	if len(line) > 0 and not line.startswith("#"):
		line = commentRegex.sub("", line).strip()
		if len(line) > 0:
			if line == ",":
				dest[len(dest)-1] = dest[len(dest)-1] + ","
			else:
				dest.append(line)

# find CREATE TABLE

src = dest
dest = []
inCreateTable = False

for i in range(0,len(src)):
	line = src[i]
	if inCreateTable:
		if line.startswith(')'):
			dest.append(');')
			inCreateTable = False
		else:
			dest.append(line)
	else:
		if line.startswith("CREATE TABLE "):
			dest.append("CREATE TABLE immport." + line[len("CREATE TABLE "):])
			inCreateTable = True
		if line.startswith("CREATE INDEX"):
			if not line.endswith(";"):
				line = line + ";"
			line = indexRegex.sub(" ON immport.", line)
			dest.append(line)

# TYPES
src = dest
dest = []
for i in range(0,len(src)):
	dest.append(textRegex.sub("TEXT",src[i]))

# print

lines = dest
for i in range(0,len(lines)):
	print(lines[i])
