DROP TABLE IF EXISTS lk_expsample_result_schema;

CREATE TABLE lk_expsample_result_schema
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  table_name VARCHAR(30) NOT NULL DEFAULT 'NONE'
    COMMENT "table into which parsed results are loaded.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary that links the  experiment sample template used to the database table that the results would be parsed into";
