

-- deprecated, "data_format" can be deleted when DR20 is not longer supporteds
ALTER TABLE immport.assessment_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);
ALTER TABLE immport.control_sample_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);
ALTER TABLE immport.expsample_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);
ALTER TABLE immport.standard_curve_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);

-- deprecated, "purpose" can be deleted when DR20 is not longer supporteds
ALTER TABLE immport.experiment ALTER COLUMN purpose TYPE VARCHAR(100);
