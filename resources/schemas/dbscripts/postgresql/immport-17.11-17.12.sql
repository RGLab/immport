
-- deprecated, "data_format" can be deleted when DR20 is not longer supporteds
ALTER TABLE immport.assessment_2_file_info ALTER COLUMN data_format DROP NOT NULL;
ALTER TABLE immport.control_sample_2_file_info ALTER COLUMN data_format DROP NOT NULL;
ALTER TABLE immport.expsample_2_file_info ALTER COLUMN data_format DROP NOT NULL;
ALTER TABLE immport.standard_curve_2_file_info ALTER COLUMN data_format DROP NOT NULL;

-- deprecated, "purpose" can be deleted when DR20 is not longer supporteds
ALTER TABLE immport.experiment ALTER COLUMN purpose DROP NOT NULL;;
