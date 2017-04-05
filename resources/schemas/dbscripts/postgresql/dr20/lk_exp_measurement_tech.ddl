DROP TABLE IF EXISTS lk_exp_measurement_tech;

CREATE TABLE lk_exp_measurement_tech
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the techniques used for performing experimental assays.";
