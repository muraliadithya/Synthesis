import sys
import os

from io import *
from problem import *
from smtoutput import *


# print sys.argv
num_vars = int(sys.argv[2])
num_rels = int(sys.argv[3])
arity = 2
existential = sys.argv[4]
conjuncts = sys.argv[5]
labelconstraint = sys.argv[6]
case = sys.argv[1]

folder = "./concepts/" + case + "/"
instance = case + '_' + str(num_vars) + 'v' + '-' + str(num_rels) + 'r'
if existential == 'yes':
    instance = instance + '_' + 'exist'
if conjuncts == 'yes':
    instance = instance + '_' + 'and'
if labelconstraint != 'no':
    instance = instance + '_' + labelconstraint

trainfile_name = folder + case+"_train_out.txt"
testfile_name = folder + case+"_test_out.txt"
smt_infile_name = folder + instance + '_smtinput.smt2'
smt_outfile_name = folder + instance + '_smtoutput.txt'
resultfile_name = folder + 'results_'+ instance +'.txt'

#(problem_dict,smtdict) = input_files(sys.argv[1],sys.argv[2])
(problem_dict,smtdict) = input_files(trainfile_name,testfile_name)
#print problem_dict['test']
smt_input = smt_file_gen(problem_dict,smtdict,num_vars,num_rels,arity,existential,conjuncts,labelconstraint)

smt_in_file = open(smt_infile_name,'w')
smt_in_file.write(smt_input)
smt_in_file.close()

print 'SMT query generated. Querying..'

smt_call = '../z3/bin/z3 ' + smt_infile_name + ' > ' + smt_outfile_name
os.system(smt_call)

print 'SMT query returned. Writing results ..'

results  = read_smt_output(smt_outfile_name,num_rels,num_vars,arity)
resultfile = open(resultfile_name,'w')
resultfile.write(results)
resultfile.close()

print 'Done.'