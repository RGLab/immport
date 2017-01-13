DROP TABLE IF EXISTS lk_data_completeness;

CREATE TABLE lk_data_completeness
(
  
  id INT NOT NULL
    COMMENT "scale of 0-2 for the level of completeness of the data submitted to immport.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary describing the type of plates.";
