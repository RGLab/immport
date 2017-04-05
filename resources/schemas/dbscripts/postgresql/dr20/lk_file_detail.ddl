DROP TABLE IF EXISTS lk_file_detail;

CREATE TABLE lk_file_detail
(
  
  name VARCHAR(100) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the next level of detail below the file purpose, such as the specific file type for a given assay platform, such as fcs binary file, compensation file or txt file for flow cytometry.";
