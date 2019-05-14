from parsetree import *
from absformula_datatypes import *
from absformula_gen import *
from rels import *
from objs_and_imgs import *
from io import *
from smtinput import *
from alternaterels import *
#from smtoutput import *

import sys


# Dictionary has to store the following key-value pairs:
# elem -> points to a dictionary of type image id -> [listof object ids belonging to that image] 
# label -> points to a dictionary of type obj id -> label
# top_border -> points to a dictionary of type obj id -> top coordinate
# similarly for bottom_border, left_border and right_border
# obj id, img id, labels are all strings
# borders are numbers

def input_files(trainfile,testfile):
  train_file = open(trainfile, 'r')
  train_str = train_file.read()
  test_file = open(testfile, 'r')
  test_str = test_file.read()
  
  train_dict = parse_input(train_str,'train')
  test_dict = parse_input(test_str,'test') 
  problem_dict = {}
  problem_dict['train'] = train_dict
  problem_dict['test'] = test_dict
  
  smtdict = {}
  smtdict['elem'] = make_elem(problem_dict)
  smtdict['label'] = make_feature(problem_dict,'label')
  smtdict['top_border'] = make_feature(problem_dict,'top_border')
  smtdict['bottom_border'] = make_feature(problem_dict,'bottom_border')
  smtdict['left_border'] = make_feature(problem_dict,'left_border')
  smtdict['right_border'] = make_feature(problem_dict,'right_border')
  
  return (problem_dict,smtdict)


def assert_truth(train_imgs,test_imgs):
  result = ""
  for img in train_imgs:
    result = result + "(assert (formula_level_1 "+ img + "))\n"
  for img in test_imgs:
    result = result + "(assert (not (formula_level_1 " + img + ")))\n"
  
  print result


# arg = {'elem':{'t1':['t1_1','t1_2'],'t2':['t2_1','t2_2']}, 'label': {'t1_1':'cat','t1_2':'sofa'}, 'top_border':{'t1_1': 0,'t1_2':0},'bottom_border':{'t1_1': 0,'t1_2':0},'left_border':{'t1_1': 0,'t1_2':0},'right_border':{'t1_1': 0,'t1_2':0}}

# print sys.argv

num_vars = int(sys.argv[3])
num_rels = int(sys.argv[4])
arity = 2
existential = sys.argv[5]
conjuncts = sys.argv[6]
# case = sys.argv[1]

(problem_dict,arg) = input_files(sys.argv[1],sys.argv[2])

# (problem_dict,arg) = input_files("./concepts/"+case+"/"+case+"_train_out.txt","./concepts/"+case+"/"+case+"_test_out.txt")



# num_vars indicating number of variables quantified in the formula
# num_rels indicating the number of relation instances in the formula
# arity denoting the uniform arity of all relations
# Given num_vars = k, formula will contain the variables x1, x2... xk
# It will also contain the quantifier variables b1, b2... bk
# Given num_rels = k and arity = m, abstract formula will contain the relation type variables r1, r2... rk and each rj will contain the arguments argj_1, argj_2... argj_m

#def print_smt(arg,num_vars,num_rels,arity,train_imgs,test_imgs):
declare_datatype_Img(arg)
declare_datatype_Obj(arg)
define_fun_inImg(arg)
define_fun_label(arg)
# define_fun_border(arg,'top')
# define_fun_border(arg,'bottom')
# define_fun_border(arg,'left')
# define_fun_border(arg,'right')
declare_datatype_rels()
# define_fun_re(arg)
define_fun_precompute_re(problem_dict)
declare_datatype_quantifier()
declare_datatype_binding(arg,num_vars)
define_fun_bindlook(arg,num_vars)
define_operator_meanings()
define_quantifier_vars(num_vars)
if existential == 'yes':
  for i in range(1,num_vars+1):
    print "(assert (= q" + str(i) + " one))"

define_operator_vars(num_rels)
if conjuncts == 'yes':
  for i in range(1,num_rels):
    print "(assert (= op" + str(i) + " opand))"
define_negation_vars(num_rels)
define_relation_vars(num_rels)
define_relarg_vars(num_rels,arity)

define_baseformula(num_rels,num_vars,arity)
for i in range(num_vars,0,-1):
  define_formula_level(i,num_vars)

assert_truth(problem_dict['train'].keys(),problem_dict['test'].keys())
print("(check-sat)\n")
print("(get-model)")


# smtfile = 'sat.txt'
# read_smt_output(smtfile,num_rels,num_vars,arity)

    
   