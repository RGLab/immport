DROP TABLE IF EXISTS lk_study_file_type;

CREATE TABLE lk_study_file_type
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "a controlled vocabulary for supplemental files associated with the study, such as the bisc created study summary document";
