DROP TABLE IF EXISTS lk_organization;

CREATE TABLE lk_organization
(
  
  name VARCHAR(125) NOT NULL
    COMMENT "this is the name field.",
  
  link VARCHAR(2000)
    COMMENT "this is the link field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_organization table.";
