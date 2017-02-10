DROP TABLE IF EXISTS lk_data_format;

CREATE TABLE lk_data_format
(
  
  name VARCHAR(100) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary of experimental result data formats.";
