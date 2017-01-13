DROP TABLE IF EXISTS lk_lab_test_panel_name;

CREATE TABLE lk_lab_test_panel_name
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or idenifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for lab test panel names.";
