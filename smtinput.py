# From a dictionary given by the model parser, this function creates a new dictionary of images and the corresponding objects that will be used in the SMT generation
def make_elem(d):
  d_train = d['train']
  d_test = d['test']
  
  result = {}
  training_imgs = d_train.keys()
  for img in training_imgs:
    result[img] = d_train[img].keys()
  
  testing_imgs = d_test.keys()
  for img in testing_imgs:
    result[img] = d_test[img].keys()

  return result

# From dictionary given by the model parser, this functions returns a dictionary of objects and various features like label, top_border, etc that will be used in SMT generation
def make_feature(d,feature):
  if feature == 'label':
    featurefunc = lambda x: x[0]
  elif feature == 'top_border':
    featurefunc = lambda x: x[2]['top']
  elif feature == 'bottom_border':
    featurefunc = lambda x: x[2]['bottom']
  elif feature == 'left_border':
    featurefunc = lambda x: x[2]['left']
  elif feature == 'right_border':
    featurefunc = lambda x: x[2]['right']
  else:
    raise ValueError('Feature not supported.')

  d_train = d['train']
  d_test = d['test']

  result = {}
  training_imgs = d_train.keys()
  for img in training_imgs:
    train_objs = d_train[img].keys()
    for obj in train_objs:
      result[obj] = featurefunc(d_train[img][obj])
  
  testing_imgs = d_test.keys()
  for img in testing_imgs:
    test_objs = d_test[img].keys()
    for obj in test_objs:
      result[obj] = featurefunc(d_test[img][obj])

  return result