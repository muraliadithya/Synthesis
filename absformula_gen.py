from parsetree import *

def define_formula_level(level,num_vars):
  if (level > num_vars):
    raise ValueError('Depth of quantifier does not make sense.')
  args = ""
  for i in range(1,level):
    args = args + "(x" + str(i) + " Obj) "
  
  nextargs = ""
  for i in range(1,level+1):
    nextargs = nextargs + " x" + str(i)
  if (level != num_vars):
    nextlevel = "formula_level_" + str(level+1)
    nextargs = nextargs + " img"
  else:
    nextlevel = "baseformula"
  
  result = \
  "(define-fun formula_level_" + str(level) + " (" + args + "(img Img)) Bool\n" + \
  "(ite (= q"+ str(level) + " all)\n" + \
  " (forall ((x" + str(level) + " Obj)) (=> (inImg x" + str(level) + " img) (" + nextlevel + nextargs + ")))\n" + \
  " (exists ((x" + str(level) + " Obj)) (and (inImg x" + str(level) + " img) (" + nextlevel + nextargs + ")))\n" + \
  "))"

  preamble = ";Formula at quantifier level " + str(level) + "\n"
  print preamble + result 


def define_baseformula(treearg,num_vars,arity):
  if type(treearg) == int:
    pt = gen_default_parsetree(treearg)
  else:
    if type(treearg) == list:
      pt = treearg
    else:
      raise ValueError('You must specify either a number of relations or a specific parsetree.')

  if num_vars == 0:
    name = "formula_level_1"
  else:
    name = "baseformula"

  dec_ps = decorate_parsetree(pt)[0]
  formula = annotate_parsetree(dec_ps,num_vars,arity)

  args = ""
  for i in range(1,num_vars+1):
    args = args + "(x" + str(i) + " Obj)"



  result = "(define-fun " + name + " ("+ args + ") Bool\n" + formula + "\n)"

  preamble = ";Defines the innermost (quantifier-free) formula\n"
  print preamble + result
