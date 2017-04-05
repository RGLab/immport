DROP TABLE IF EXISTS lk_unit_of_measure;

CREATE TABLE lk_unit_of_measure
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",
  
  type VARCHAR(50) NOT NULL
    COMMENT "this is the type field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_unit_of_measure table.";
