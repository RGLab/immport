DROP TABLE IF EXISTS lk_species;

CREATE TABLE lk_species
(
  
  name VARCHAR(30) NOT NULL
    COMMENT "short name or identifier.",
  
  common_name VARCHAR(100)
    COMMENT "common name for the species.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  taxonomy_id VARCHAR(10) NOT NULL
    COMMENT "this is the taxonomy_id field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary of common species names along with the ncbi taxonomy id.";
