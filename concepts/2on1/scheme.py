trlist = 'abcdef'
result = ""

for tr1 in trlist:
  for tr2 in trlist:
    if tr2 == tr1:
      continue
    for tr3 in trlist:
      if tr3 == tr1 or tr3 == tr2:
        continue
      for tr4 in trlist:
        if tr4 == tr1 or tr4 == tr2 or tr4 == tr3:
          continue
        
        if ((tr1 in "aef") or (tr2 in "aef") or (tr3 in "aef")) and (tr4 in "aef"):
          continue
        
        result = result + tr1 + " " + tr2 + " " + tr3 + " | " + tr4 + " 1 2 3\n"

res = len(result.split("\n")[:-1])

print result 
print res
