DROP TABLE IF EXISTS lk_ancestral_population;

CREATE TABLE lk_ancestral_population
(
  
  name VARCHAR(30) NOT NULL
    COMMENT "this is the pop_area_name field.",
  
  abbreviation VARCHAR(3)
    COMMENT "this is the pop_area_abbrv field.",
  
  description VARCHAR(4000) NOT NULL
    COMMENT "this is the pop_area_descr field.",
  
  link VARCHAR(2000)
    COMMENT "this is the link field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_pop_area_type table.";
