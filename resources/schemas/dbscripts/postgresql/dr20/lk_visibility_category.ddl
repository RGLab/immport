DROP TABLE IF EXISTS lk_visibility_category;

CREATE TABLE lk_visibility_category
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for contract grant visibility.";
