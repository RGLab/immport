#!/usr/bin/python

import sys, getopt
from os import listdir, mkdir
from os.path import isfile, join, exists
from shutil import copy, copytree, ignore_patterns, move, rmtree
import re
from sets import Set
from datetime import datetime

def main(argv):
	src_archive_dir = '.'
	dest_archive_dir = '.'
	include_docs = False
	verbose = False
	try:
		opts, args = getopt.getopt(argv,"i:o:d:v")
	except getopt.GetoptError:
		print 'immport_shrink.py [-i <src_archive_dir>] [-o <dest_archive_dir>] [-d]'
		sys.exit(2)

	for opt, arg in opts:
		if opt == "-i":
			src_archive_dir = arg
		elif opt == "-o":
			dest_archive_dir = arg
		elif opt == "-d":
			include_docs = True
		elif opt == "-v":
			verbose = True

	source_mysql_dir = join(src_archive_dir, "MySQL")
	dest_mysql_dir = join(dest_archive_dir, "MySQL")
	in_place = src_archive_dir == dest_archive_dir

	if not exists(src_archive_dir):
		print 'Immport archive does not exist: ' + src_archive_dir
	if not exists(source_mysql_dir):
		print 'Not an Immport study archive, MySQL does not exist in ' + src_archive_dir

	if not in_place:
		if exists(dest_archive_dir):
			print 'destination already exists'
			sys.exit(2)
		copytree(src_archive_dir, dest_archive_dir, ignore=ignore_patterns("MySQL"))
		mkdir(dest_mysql_dir)
	else:
		print "Minimizing Immport archive in place"

	study_prefix = "SDY"
	subject_prefix = "SUB"
	arm_prefix = "ARM"
	field_sep = "~@~"
	re_field_sep = re.compile(field_sep)
	line_sep = "~@@~\n"
	re_line_sep = re.compile(line_sep)

	# These study accessions are the animal studies from ALLSTUDIES-DR11_MySQL.zip
	# Update these accessions if you intend to run this against a different archive
	all_animal_studies = [21, 29, 30, 31, 32, 35, 62, 64, 78, 95, 99, 139, 147, 208, 215, 217, 241, 259, 271, 286, 288]
	# These are the studies used by StudyFinderTest
	animal_studies = [99, 139, 147, 208, 215, 217]
	junction_file_sep = "_2_"
	special_junction_files = ["study_2_panel.txt"] # No 'panel.txt', treat like a normal data file to filter study accessions

	file_names = [f for f in listdir(source_mysql_dir) if isfile(join(source_mysql_dir,f))]
	data_file_names = [f for f in file_names if junction_file_sep not in f or f in special_junction_files]
	junction_file_names = [f for f in file_names if junction_file_sep in f and f not in special_junction_files]
	skipped_data_file_names = []


	# given list of studies, generate list of subject_accessions

	included_studies = Set()
	included_arms = Set()
	included_subjects = Set()
	included_biosamples = Set()
	included_expsamples = Set()
	
	for s in animal_studies:
		included_studies.add(study_prefix + str(s))
	
	regexp_study = re.compile("^" + study_prefix + "[0-9]+$")
	regexp_subject = re.compile("^" + subject_prefix + "[0-9]+$")
	regexp_arm =  re.compile("^" + arm_prefix + "[0-9]+$")
	regexp_bs = re.compile("^BS[0-9]+$")
	regexp_es = re.compile("^ES[0-9]+$")
	regexp_accession = re.compile("^(SDY|SUB|ARM|ES|BS)[0-9]+$")

	# get included_arms 
	src_file_path = join(source_mysql_dir, "arm_or_cohort.txt")
	src_file = open(src_file_path, "r")
	data = src_file.read()
	src_file.close()
	lines = re_line_sep.split(data)
	for line in lines:
		if len(line) == 0:
			continue
		split_line = re_field_sep.split(line)
		arm = split_line[0]
		sdy = split_line[3]
		if not arm.startswith("ARM") or not sdy.startswith("SDY"):
		  raise Exception("wrong columns: arm_or_cohort.txt")
		if sdy in included_studies:
			included_arms.add(arm)
			
	
	# get included subjects
	src_file_path = join(source_mysql_dir, "arm_2_subject.txt")
	src_file = open(src_file_path, "r")
	data = src_file.read()
	src_file.close()
	lines = re_line_sep.split(data)
	for line in lines:
		if len(line) == 0:
			continue
		split_line = re_field_sep.split(line)
		arm = split_line[0]
		sub = split_line[1]
		if not arm.startswith("ARM") or not sub.startswith("SUB"):
		  raise Exception("wrong columns: arm_2_subject.txt")
		if arm in included_arms:
			included_subjects.add(sub)
			
	# biosamples
	# get included subjects
	src_file_path = join(source_mysql_dir, "biosample.txt")
	src_file = open(src_file_path, "r")
	data = src_file.read()
	src_file.close()
	lines = re_line_sep.split(data)
	for line in lines:
		if len(line) == 0:
			continue
		split_line = re_field_sep.split(line)
		bs = split_line[0]
		sdy = split_line[4]
		if not bs.startswith("BS") or not sdy.startswith("SDY"):
		  raise Exception("wrong columns: biosample.txt")
		if sdy in included_studies:
			included_biosamples.add(bs)
				
	# expsamples
	# get included subjects
	src_file_path = join(source_mysql_dir, "expsample_2_biosample.txt")
	src_file = open(src_file_path, "r")
	data = src_file.read()
	src_file.close()
	lines = re_line_sep.split(data)
	for line in lines:
		if len(line) == 0:
			continue
		split_line = re_field_sep.split(line)
		bs = split_line[0]
		es = split_line[1]
		if not bs.startswith("BS") or not es.startswith("ES"):
		  raise Exception("wrong columns: expsample_2_biosample.txt")
		if bs in included_biosamples:
			included_expsamples.add(es)


	if verbose:
		print included_studies
	print "STUDIES: ", len(included_studies)
	print "ARMS   : ", len(included_arms)
	print "SUBJETS: ", len(included_subjects)
	print "BIOSAMP: ", len(included_biosamples)
	print "EXPSAMP: ", len(included_expsamples)
	sys.stdout.flush()


	for data_file_name in data_file_names:
		start_time = datetime.now()
		print data_file_name
		sys.stdout.flush()
		src_file_path = join(source_mysql_dir, data_file_name)
		dest_file_path = join(dest_mysql_dir, data_file_name)

		has_documents = False
		document_accessions = []
		document_dir_name = data_file_name.split('.')[0] + 's'
		src_doc_dir_path = join(source_mysql_dir, document_dir_name)
		dest_doc_dir_path = join(dest_mysql_dir, document_dir_name)
		if exists(src_doc_dir_path):
			has_documents = True

		src_file = open(src_file_path, "r")
		data = src_file.read()
		src_file.close()

		## COPY .txt file
		
		# TODO better/faster to check ddl file
#		if not re.match("[^~]SDY[0-9]+~") and not re.match("[^~]SUB[0-9]+~") and "Homo sapiens" not in data:
		is_lookup = data_file_name.startswith("lk_")
		has_sdy = re.search("SDY[0-9]+~",data)
		has_sub = re.search("SUB[0-9]+~",data)
		has_arm = re.search("ARM[0-9]+~",data)
		has_es = re.search("ES[0-9]+~",data)
		has_bs = re.search("BS[0-9]+~",data)
		has_human = "Homo sapiens" in data
		if is_lookup or (not has_sdy and not has_sub and not has_es and not has_bs and not has_human):
			skipped_data_file_names.append(data_file_name)
			if is_lookup:
				print "  Lookup table. Including all data"
			else:
				print "  No study, subject, or species identifiers. Including all data"
			if not in_place:
				copy(src_file_path, dest_file_path)
				if include_docs and has_documents:
					print "  Including all related documents"
					copytree(src_doc_dir_path, dest_doc_dir_path)
			elif has_documents and not include_docs:
				print "  Deleting all related documents ('-d' to include documents)"
				rmtree(src_doc_dir_path)
		else:
			lines = re_line_sep.split(data)
			dest_file = open(dest_file_path, "w")

			line_count = 0
			included_count = 0
			for line in lines:
				if len(line) == 0:
					continue
				include_line = True
				line_count += 1
				split_line = re_field_sep.split(line)
				for value in split_line:
					if value == "Homo sapiens":
						include_line=False
					if regexp_accession.match(value):
						if value.startswith("SDY"):
							if value not in included_studies:
								include_line=False
						elif value.startswith("SUB"):
							if value not in included_subjects:
								include_line=False
						elif value.startswith("ARM"):
							if value not in included_arms:
								include_line=False
						elif value.startswith("ES"):
							if value not in included_expsamples:
								include_line=False
						elif value.startswith("BS"):
							if value not in included_biosamples:
								include_line=False
					if not include_line:
						break

				if include_line:
					included_count += 1
					dest_file.write(line + line_sep)
					if has_documents:
						document_accessions.append(split_line[0]) # document accession column is currently always first
			print '  Included ' + str(included_count) + ' of ' + str(line_count) + ' data rows'
			dest_file.close()
		print " ", datetime.now() - start_time
		sys.stdout.flush()


		## COPY documents

		if has_documents:
			doc_count = 0
			doc_suffixes = ['', '_map']
			if in_place:
				temp_src_doc_path = join(source_mysql_dir, 'temp')
				rmtree(temp_src_doc_path)
				move(src_doc_dir_path, temp_src_doc_path)
				src_doc_dir_path = temp_src_doc_path
			mkdir(dest_doc_dir_path)
			for document_accession in document_accessions:
				for doc_suffix in doc_suffixes:
					src_doc_path = join(src_doc_dir_path, document_accession + doc_suffix)
					if exists(src_doc_path):
						doc_count += 1
						if include_docs:
							copy(src_doc_path, dest_doc_dir_path)
			if in_place:
				rmtree(src_doc_dir_path) # delete temp dir
			if include_docs:
				print '  Included ' + str(doc_count) + ' related documents'
			else:
				print "  Skipping " + str(doc_count) + " related documents ('-d' to include documents)"
			sys.stdout.flush()


	for junction_file_name in junction_file_names:
		start_time = datetime.now()
		print junction_file_name
		sys.stdout.flush()
		junction_table = junction_file_name.replace(".txt", "")

		src_file_path = join(source_mysql_dir, junction_file_name)
		dest_file_path = join(dest_mysql_dir, junction_file_name)
		
		if junction_file_name.find("expsample") != -1:
			
			src_file = open(src_file_path, "r")
			junction_data = src_file.read()
			src_file.close()
		
			dest_file = open(dest_file_path, "w")

			junction_data_lines = re_line_sep.split(junction_data)
			for junction_data_line in junction_data_lines:
				split_line = re_field_sep.split(junction_data_line)
				include_line = False
				for value in split_line:
					if value in included_expsamples:
						include_line = True
				if include_line:
					dest_file.write(junction_data_line + line_sep)
					included_count += 1
					
			print '  Included ' + str(included_count) + ' of ' + str(len(junction_data_lines) - 1) + ' junction rows'
			dest_file.close()

		
		else:
			left_table = junction_table.split(junction_file_sep)[0]
			right_table = junction_table.split(junction_file_sep)[1]
			if left_table != "arm":
				left_file_name = left_table + ".txt"
			else:
				left_file_name = "arm_or_cohort.txt"
			if right_table != "arm":
				right_file_name = right_table + ".txt"
			else:
				right_file_name = "arm_or_cohort.txt"

			src_file_path = join(source_mysql_dir, junction_file_name)
			dest_file_path = join(dest_mysql_dir, junction_file_name)
			left_file_path = join(dest_mysql_dir, left_file_name)
			right_file_path = join(dest_mysql_dir, right_file_name)
			
			if True==False:
				print " Copying"
				if not in_place:
					copy(src_file_path, dest_file_path)
				continue
				
			if not isfile(left_file_path):
				print "  No file '" + left_file_name + "' for junction. Including entire junction table."
				if not in_place:
					copy(src_file_path, dest_file_path)
				continue
			if not isfile(right_file_path):
				print "  No file '" + right_file_name + "' for junction. Including entire junction table."
				if not in_place:
					copy(src_file_path, dest_file_path)
				continue

			if left_file_name in skipped_data_file_names and right_file_name in skipped_data_file_names:
				print "  No changes to either side of junction. Including entire junction table."
				if not in_place:
					copy(src_file_path, dest_file_path)
				continue

			src_file = open(src_file_path, "r")
			junction_data = src_file.read()
			src_file.close()

			left_file = open(left_file_path, "r")
			left_data = left_file.read()
			left_file.close()

			right_file = open(right_file_path, "r")
			right_data = right_file.read()
			right_file.close()

			junction_fields = get_table_fields(join(src_archive_dir, "load", junction_file_name.replace(".txt", ".load")))
			left_fields = get_table_fields(join(src_archive_dir, "load", left_file_name.replace(".txt", ".load")))
			right_fields = get_table_fields(join(src_archive_dir, "load", right_file_name.replace(".txt", ".load")))

			left_i_in_junction = get_accession_field_index(left_table, junction_fields)
			right_i_in_junction = get_accession_field_index(right_table, junction_fields)
			left_i = get_accession_field_index(left_table, left_fields)
			right_i = get_accession_field_index(right_table, right_fields)

			# This many splits is slow for large files
	#		left_lines = re_line_sep.split(left_data)
	#		left_accessions = Set([a[left_i] for a in [re_field_sep.split(line) for line in left_lines]])
	#		right_lines = re_line_sep.split(right_data)
	#		right_accessions = Set([a[right_i] for a in [re_field_sep.split(line) for line in right_lines]])

			left_col_count = len(re_field_sep.split(re_line_sep.split(left_data)[0]))
			right_col_count = len(re_field_sep.split(re_line_sep.split(right_data)[0]))

			dest_file = open(dest_file_path, "w")
			included_count = 0
			junction_data_lines = re_line_sep.split(junction_data)
			for junction_data_line in junction_data_lines:
				if len(junction_data_line) == 0:
					continue
				split_line = re_field_sep.split(junction_data_line)

				left_accession_str = split_line[left_i_in_junction]
				if left_i > 0:
					left_accession_str = field_sep + left_accession_str
				if left_i < left_col_count - 1:
					left_accession_str = left_accession_str + field_sep

				right_accession_str = split_line[right_i_in_junction]
				if right_i > 0:
					right_accession_str = field_sep + right_accession_str
				if right_i < right_col_count - 1:
					right_accession_str = right_accession_str + field_sep

	#			if left_accession_str in left_accessions and right_accession_str in right_accessions:
				if left_accession_str in left_data and right_accession_str in right_data:
					dest_file.write(junction_data_line + line_sep)
					included_count += 1
			dest_file.close()
			print '  Included ' + str(included_count) + ' of ' + str(len(junction_data_lines) - 1) + ' junction rows'
			
		print " ", datetime.now() - start_time
		sys.stdout.flush()


def get_table_fields(file_path):
	file = open(file_path)
	data = file.read()
	file.close()
	fieldstr = data[data.index("(")+1:data.index(")")].strip()
	fields = re.compile(",\\s*").split(fieldstr)
	return fields

def get_accession_field_index(table_name, fields):
	index = -1
	if table_name + "_accession" in fields:
		index = fields.index(table_name + "_accession")
	elif table_name + "_id" in fields:
		index = fields.index(table_name + "_id")
	return index

if __name__ == "__main__":
	main(sys.argv[1:])