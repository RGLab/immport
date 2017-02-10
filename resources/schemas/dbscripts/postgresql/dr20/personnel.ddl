DROP TABLE IF EXISTS personnel;

CREATE TABLE personnel
(
  
  personnel_id INT NOT NULL
    COMMENT "this is the personnel_id field.",
  
  email VARCHAR(100)
    COMMENT "this is the email field.",
  
  first_name VARCHAR(50) NOT NULL
    COMMENT "this is the first_name field.",
  
  last_name VARCHAR(50) NOT NULL
    COMMENT "this is the last_name field.",
  
  organization VARCHAR(125) NOT NULL
    COMMENT "this is the organization field.",
  
  PRIMARY KEY (personnel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the personnel table.";
