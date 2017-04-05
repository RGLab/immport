DROP TABLE IF EXISTS assessment_2_file_info;

CREATE TABLE assessment_2_file_info
(
  
  assessment_panel_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the assessment panel in the assessment table.",
  
  file_info_id INT NOT NULL
    COMMENT "Reference to the file in the file_info table.",
  
  data_format VARCHAR(100) NOT NULL
    COMMENT "Reference to the data format in the lk_data_format table.",
  
  result_schema VARCHAR(50) NOT NULL
    COMMENT "Based on the experiment sample template used, a reference to the database table that would contain the parsed results.",
  
  PRIMARY KEY (assessment_panel_accession, file_info_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates assesement_panel with file_info table records.";

CREATE INDEX idx_assessment_2_file_info on assessment_2_file_info(file_info_id,assessment_panel_accession);
