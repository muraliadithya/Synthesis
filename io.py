#import sys
from utilities import *

def model_parser(model_string,model_id):
    model = model_string.split('\n')[1:-1]
    names_and_confidence = model[0::2]
    bounding_boxes = model[1::2]
    parsed_model = {}
    for i in range(len(bounding_boxes)):
        name =  names_and_confidence[i].split(': ')[0]
        confidence = names_and_confidence[i].split(': ')[1].split('%')[0]
        boundaries = bounding_boxes[i].split(': ')[1].split(', ')
        left = boundaries[0].split('=')[1]
        top = boundaries[1].split('=')[1]
        right = boundaries[2].split('=')[1]
        bottom = boundaries[3].split('=')[1]
        parsed_model[model_id+"_o"+str(i+1)] = (name, int(confidence), {'left':int(left), 'right':int(right), 'top':int(top), 'bottom':int(bottom)})
    return parsed_model


def parse_input(string, mode):
  if mode == 'train':
    prefix = 't'
  elif mode == 'test':
    prefix = 's'
  else:
    raise ValueError('Must specify if the given models and training models or testing models using \'train\' or \'test\' in the second argument')
  
  each_model = string.split('Enter')[1:-1]
  all_models = {}
  for i in range(len(each_model)):
    model_id = prefix+str(i+1)
    all_models[model_id] = model_parser(each_model[i],model_id)

  return all_models


def input_files(trainfile, testfile):
  train_file = open(trainfile, 'r')
  train_str = train_file.read()
  test_file = open(testfile, 'r')
  test_str = test_file.read()

  train_dict = parse_input(train_str, 'train')
  test_dict = parse_input(test_str, 'test')
  problem_dict = {}
  problem_dict['train'] = train_dict
  problem_dict['test'] = test_dict

  smtdict = {}
  smtdict['elem'] = make_elem(problem_dict)
  smtdict['label'] = make_feature(problem_dict, 'label')
  smtdict['top_border'] = make_feature(problem_dict, 'top_border')
  smtdict['bottom_border'] = make_feature(problem_dict, 'bottom_border')
  smtdict['left_border'] = make_feature(problem_dict, 'left_border')
  smtdict['right_border'] = make_feature(problem_dict, 'right_border')

  return (problem_dict,smtdict)