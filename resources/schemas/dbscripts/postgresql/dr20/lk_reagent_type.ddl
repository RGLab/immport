DROP TABLE IF EXISTS lk_reagent_type;

CREATE TABLE lk_reagent_type
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "this is the description field.",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for reagent type.";
