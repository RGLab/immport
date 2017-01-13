DROP TABLE IF EXISTS standard_curve_2_file_info;

CREATE TABLE standard_curve_2_file_info
(
  
  standard_curve_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the standard curve in the standard_curve table.",
  
  file_info_id INT NOT NULL
    COMMENT "reference to the file in the file_info table.",
  
  data_format VARCHAR(100) NOT NULL
    COMMENT "reference to the data format in the lk_data_format table.",
  
  result_schema VARCHAR(50) NOT NULL
    COMMENT "based on the experiment sample template used, a reference to the database table that would contain the parsed results.",
  
  PRIMARY KEY (standard_curve_accession, file_info_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "join table that associates standard_curve with file_info table records.";
