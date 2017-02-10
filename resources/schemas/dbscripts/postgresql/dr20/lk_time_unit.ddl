DROP TABLE IF EXISTS lk_time_unit;

CREATE TABLE lk_time_unit
(
  
  name VARCHAR(25) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000) NOT NULL
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for time units.";
