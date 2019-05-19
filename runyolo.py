import sys
import os


case = sys.argv[1]

# if len(sys.argv) == 3:
#     run_yolo_in_silence = sys.argv[2]

pwd = os.getcwd()
folder = pwd + "/concepts/" + case + "/"
train_file_in = folder + case + "_train_in.txt"
train_file_out = folder + case + "_train_out.txt"
test_file_in = folder + case + "_test_in.txt"
test_file_out = folder + case + "_test_out.txt"

suppress = ""
# if run_yolo_in_silence == 'silent':
#     suppress = " &"

yolo_path = "/home/adithya/darknet/"
os.chdir(yolo_path)

darknet_command = "./darknet detect cfg/yolov3.cfg yolov3.weights "
darknet_trainfile_command = darknet_command + " < " + train_file_in + " > " + train_file_out + suppress
darknet_testfile_command = darknet_command + " < " + test_file_in + " > " + test_file_out + suppress




print "Running YOLO on training files..."
os.system(darknet_trainfile_command)

print "Running YOLO on testing files..."
os.system(darknet_testfile_command)

print "Done."