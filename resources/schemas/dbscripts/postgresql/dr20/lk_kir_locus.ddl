DROP TABLE IF EXISTS lk_kir_locus;

CREATE TABLE lk_kir_locus
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "this is the locus_name field.",
  
  description VARCHAR(250)
    COMMENT "this is the locus_description field.",
  
  link VARCHAR(2000)
    COMMENT "this is the link field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_kir_locus table.";
