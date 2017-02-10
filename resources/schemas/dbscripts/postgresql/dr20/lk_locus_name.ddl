DROP TABLE IF EXISTS lk_locus_name;

CREATE TABLE lk_locus_name
(
  
  name VARCHAR(100) NOT NULL
    COMMENT "this is the name field.",
  
  description VARCHAR(250)
    COMMENT "this is the description field.",
  
  link VARCHAR(2000)
    COMMENT "this is the link field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_locus_name table.";
