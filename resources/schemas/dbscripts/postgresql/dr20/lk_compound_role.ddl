DROP TABLE IF EXISTS lk_compound_role;

CREATE TABLE lk_compound_role
(
  
  name VARCHAR(40) NOT NULL
    COMMENT "compound role name.",
  
  description VARCHAR(1000)
    COMMENT "long description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the substance_merge compound_role.";
