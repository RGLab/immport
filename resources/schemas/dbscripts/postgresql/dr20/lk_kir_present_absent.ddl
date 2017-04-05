DROP TABLE IF EXISTS lk_kir_present_absent;

CREATE TABLE lk_kir_present_absent
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "this is the present_absent_name field.",
  
  description VARCHAR(1000)
    COMMENT "this is the present_absent_description field.",
  
  link VARCHAR(2000)
    COMMENT "this is the link field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_kir_present_absent table.";
