DROP TABLE IF EXISTS expsample_2_file_info;

CREATE TABLE expsample_2_file_info
(
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the EXPSAMPLE table.",
  
  file_info_id INT NOT NULL
    COMMENT "Reference to the file_info_id in the FILE_INFO table.",
  
  data_format VARCHAR(100) NOT NULL
    COMMENT "Reference to the data format in the LK_DATA_FORMAT table.",
  
  result_schema VARCHAR(50) NOT NULL
    COMMENT "Based on the experiment sample template used, a reference to the database table that would contain the parsed results.",
  
  PRIMARY KEY (expsample_accession, file_info_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates EXPSAMPLE with FILE_INFO table records.";

CREATE INDEX idx_expsample_2_file_info on expsample_2_file_info(file_info_id,expsample_accession);
