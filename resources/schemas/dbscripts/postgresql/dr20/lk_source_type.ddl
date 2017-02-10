DROP TABLE IF EXISTS lk_source_type;

CREATE TABLE lk_source_type
(
  
  name VARCHAR(30) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "either experimant sample, control sample or standard curve; used for mbaa results";
