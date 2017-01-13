DROP TABLE IF EXISTS lk_user_role_type;

CREATE TABLE lk_user_role_type
(
  
  name VARCHAR(2) NOT NULL
    COMMENT "this is the role_type_id field.",
  
  description VARCHAR(1000)
    COMMENT "this is the role_descr field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_user_role_type table.";
