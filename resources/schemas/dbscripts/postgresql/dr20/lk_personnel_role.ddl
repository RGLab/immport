DROP TABLE IF EXISTS lk_personnel_role;

CREATE TABLE lk_personnel_role
(
  
  name VARCHAR(40) NOT NULL
    COMMENT "short name or identifier",
  
  description VARCHAR(1000)
    COMMENT "this is the role_description field.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the categories of roles for personnel on a given study, such as principal investigator (pi), co-pi, etc that are defined in the study protocol.";
