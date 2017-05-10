

-- deprecated, "data_format" can be deleted when DR20 is not longer supporteds
ALTER TABLE immport.assessment_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);
ALTER TABLE immport.control_sample_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);
ALTER TABLE immport.expsample_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);
ALTER TABLE immport.standard_curve_2_file_info ALTER COLUMN data_format TYPE VARCHAR(100);

-- deprecated, "purpose" can be deleted when DR20 is not longer supporteds
ALTER TABLE immport.experiment ALTER COLUMN purpose TYPE VARCHAR(100);

-- other columnss to deprecate
-- study.download_page_available
-- study.final_public_release_date
-- planned_public_release_date

-- new columns
ALTER TABLE immport.STUDY ADD COLUMN latest_data_release_date DATE NULL;
ALTER TABLE immport.STUDY ADD COLUMN latest_data_release_version VARCHAR(10) NULL;
