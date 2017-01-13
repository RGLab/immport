DROP TABLE IF EXISTS lk_lab_test_name;

CREATE TABLE lk_lab_test_name
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or idenifier.",
  
  cdisc_lab_test_code VARCHAR(50)
    COMMENT "cdisc code for this lab test",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  lab_test_panel_name VARCHAR(50)
    COMMENT "lab test panel name containing this test",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for lab test panel names.";
