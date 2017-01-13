DROP TABLE IF EXISTS lk_file_purpose;

CREATE TABLE lk_file_purpose
(
  
  name VARCHAR(100) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the purpose or motivation for the file being submitted, such as the category of assay, whether the file is an immport template, or whether the file was submitted to be archived.";
