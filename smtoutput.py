from parsetree import *
import sys

# Consider implementing in a more general fashion using regexes
# Or interfacing temporarily with Z3Py
# Extend to include when variables are not present in smt model

opstr = lambda i: '  (define-fun op' + str(i) + ' () Ops'
bindstr = lambda i,j: '  (define-fun arg' + str(i) + '_' + str(j) + ' () Binding'
negstr = lambda i: '  (define-fun n' + str(i) + ' () IfNeg'
relstr = lambda i: '  (define-fun r' + str(i) + ' () Rels'
quantstr = lambda i: '  (define-fun q' + str(i) + ' () Quantifier'
    
oplookup = lambda i,lst: lst[lst.index(opstr(i))+1].split(' ')[-1][:-1]
bindlookup = lambda i,j,lst: lst[lst.index(bindstr(i,j))+1].split(' ')[-1][:-1]
neglookup = lambda i,lst: lst[lst.index(negstr(i))+1].split(' ')[-1][:-1]
rellookup = lambda i,lst: lst[lst.index(relstr(i))+1].split(' ')[-1][:-1]
quantlookup = lambda i,lst: lst[lst.index(quantstr(i))+1].split(' ')[-1][:-1]



def recover_baseformula(lst,dt,arity):
  result = ""
  if type(dt) == list:
    op = oplookup(dt[0],lst)[2:]
    result = result + '(' + op +'\n' + recover_baseformula(lst,dt[1],arity) + '\n' + recover_baseformula(lst,dt[2],arity) + ')'
    return result
  else:
    rel = rellookup(dt,lst)
    neg = neglookup(dt,lst)
    
    for i in range(1,arity+1):
      result = result + bindlookup(dt,i,lst)[5:] + ","
    
    result = rel + "(" + result[:-1] + ")"
    if neg == 'yes':
      result = "Not " + result
    return "[" + result + "]"  
  


def read_smt_output(smtfile,treearg,num_vars,arity):
  smt_file = open(smtfile, 'r')
  smt_str = smt_file.readline()
  
  if 'unsat' in smt_str:
    print 'Unsat\n'

  else:
    if type(treearg) == int:
      pt = gen_default_parsetree(treearg)
    elif type(treearg) == list:
      pt = treearg
    else:
      raise ValueError('You must specify either a number of relations or a parsetree.')
    
    dt = decorate_parsetree(pt)[0]
    lst = smt_file.read().split('\n')

    result = ""
    
    for i in range(1,num_vars+1):
      quant_i = quantlookup(i,lst)
      if quant_i == 'all':
        result = result + 'Forall x' + str(i) + '. '
      else: #quant_i == 'one':
        result = result + 'Exists x' + str(i) + '. '

    result = result + "\n" + recover_baseformula(lst,dt,arity)
    print result

smt_outfile = sys.argv[1]
num_rels = int(sys.argv[2])
num_vars = int(sys.argv[3])
arity = 2

read_smt_output(smt_outfile,num_rels,num_vars,arity)