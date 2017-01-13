DROP TABLE IF EXISTS study_file;

CREATE TABLE study_file
(
  
  study_file_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  description VARCHAR(4000) NOT NULL
    COMMENT "long text description.",
  
  file_name VARCHAR(250) NOT NULL
    COMMENT "the literal filename in the system.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  study_file_type VARCHAR(50) NOT NULL DEFAULT 'Study Summary Description'
    COMMENT "reference to the file type in the lk_study_file_type table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (study_file_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "contains study data or result files for a given study.";

CREATE INDEX idx_study_file_study on study_file(study_accession);
CREATE INDEX idx_study_file_type on study_file(study_file_type);
CREATE INDEX idx_study_file_workspace on study_file(workspace_id);

