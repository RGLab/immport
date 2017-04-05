DROP TABLE IF EXISTS lk_ethnicity;

CREATE TABLE lk_ethnicity
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "this is the description field.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for ethnicity that follows the census designation and omb directive 15.";
