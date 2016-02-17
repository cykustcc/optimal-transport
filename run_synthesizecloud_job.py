import glob
import os
import re
import argparse
from sys import platform as _platform

def get_imlist(path):
    """    Returns a list of filenames for
		all jpg images in a directory. """
    return [os.path.join(path,f) for f in os.listdir(path) if (f.lower().endswith('.jpg') or f.lower().endswith('.png'))]

def readlist(filename):
	with open(filename,'rb') as segmodel_file:
		img_file_list=segmodel_file.read().splitlines();
	return img_file_list

def run(INTERVAL):
	if _platform == "linux" or _platform == "linux2" or _platform=="linux3":
		synthesizecloud_root="/home/yzc147/Projects/optimal-transport/original_preview/";
		synthesizecloudflow_root="/home/yzc147/Projects/optimal-transport/original_preview_momentumflow/";
		synthesizecloudflow_mislaneous_root="/home/yzc147/Projects/optimal-transport/original_preview_momentumflow_mislaneous/";
		color_flow="/home/yzc147/Projects/epic_flow/flow-code/color_flow";
	elif _platform == "darwin":
		synthesizecloud_root="/Users/MAC/Documents/Code/explore/optimal-transport/original_preview/";
		synthesizecloudflow_root="/Users/MAC/Documents/Code/explore/optimal-transport/original_preview_momentumflow/";
		synthesizecloudflow_mislaneous_root="/Users/MAC/Documents/Code/explore/optimal-transport/original_preview_momentumflow_mislaneous/";
		color_flow="/Users/MAC/Dropbox/recent/epic_flow/flow-code/color_flow";
	flw_fld=synthesizecloudflow_root
	if not os.path.exists(flw_fld):
		os.makedirs(flw_fld)
	flw_mise_fld=synthesizecloudflow_mislaneous_root
	if not os.path.exists(flw_mise_fld):
		os.makedirs(flw_mise_fld)
	img_file_list=get_imlist(synthesizecloud_root);
	for i in xrange(int(len(img_file_list))/INTERVAL-1):#,len(img_file_list)-1):
		i=i*INTERVAL;
		#imgfile1=img_file_list[i];imgfile1=re.sub(" ","\ ",imgfile1);
		imgfile1=synthesizecloud_root+"density_fullxy_0%03d"%(i);
		imgfile1name=os.path.basename(imgfile1);
		#imgfile2=img_file_list[i+1];imgfile2=re.sub(" ","\ ",imgfile2);
		imgfile2=synthesizecloud_root+"density_fullxy_0%03d"%(i+INTERVAL);
		basename=re.sub(".png","",imgfile1name);
		outputfile=flw_mise_fld+basename+"-momentum.flo";outputfile=re.sub(" ","\ ",outputfile);
		outputfile2=flw_mise_fld+basename+"-velocity.flo";outputfile=re.sub(" ","\ ",outputfile);
		edgefile=flw_mise_fld+basename+"_edge.mat";edgefile=re.sub(" ","\ ",edgefile);
		flowcolorfile=flw_fld+basename+"_momentum_flow.png";flowcolorfile=re.sub(" ","\ ",flowcolorfile);
		flowcolorfile2=flw_fld+basename+"_velocity_flow.png";flowcolorfile2=re.sub(" ","\ ",flowcolorfile2);
		arrowfile=flw_mise_fld+basename+"_match.png";arrowfile=re.sub(" ","\ ",arrowfile);
		command = "julia demo.jl "+imgfile1+" "+imgfile2+" "+"12 0.4 -"+" "+synthesizecloudflow_mislaneous_root
		# print command
		os.system(command)
		command2 = color_flow+" "+outputfile+" "+flowcolorfile;
		# print command2
		os.system(command2)
		command3 = color_flow+" "+outputfile2+" "+flowcolorfile2;
		os.system(command3)

		#transfer_command="scp -r -i ~/.ssh/id_comet_from_cyberstar "+synthesizecloudflow_mislaneous_root+month_folder+" yzc147@comet.sdsc.xsede.org:~/data/weather_processed_data/weather_flow_misc/*.mat"+month_folder
		#os.system(transfer_command)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='run_job.py is a python script to run epicflow experiments on weather data')
    parser.add_argument('-i', '--interval', help='interval for the loop.')
    args = parser.parse_args();
    interval=args.interval;
    run(int(interval));
