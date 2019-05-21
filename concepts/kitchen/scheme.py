trlist = 'abcde'
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
        
        for i in [1,2]:
          for j in [1,2,3]:
            result = result + tr1 + " " + tr2 + " " + tr3 + " | " + ("1." + str(j)) + " " + ("2." + str(i)) + " " + tr4 + "\n"

res = len(result.split("\n")[:-1])

print result 
#print res


