DROP TABLE IF EXISTS control_sample_2_file_info;

CREATE TABLE control_sample_2_file_info
(
  
  control_sample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the control sample in the control_sample table.",
  
  file_info_id INT NOT NULL
    COMMENT "Reference to the file in the file_info table.",
  
  data_format VARCHAR(100) NOT NULL
    COMMENT "Reference to the data format in the lk_data_format table.",
  
  result_schema VARCHAR(50) NOT NULL
    COMMENT "Based on the experiment sample template used, a reference to the database table that would contain the parsed results.",
  
  PRIMARY KEY (control_sample_accession, file_info_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates control_sample with file_info table records.";

CREATE INDEX idx_control_sample_2_file_info on control_sample_2_file_info(file_info_id,control_sample_accession);
