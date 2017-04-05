DROP TABLE IF EXISTS lk_virus_strain;

CREATE TABLE lk_virus_strain
(
  
  name VARCHAR(200) NOT NULL
    COMMENT "short name or idenifier.",
  
  center_id_name_season_list VARCHAR(500)
    COMMENT "group studing virus, plus the season",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",
  
  season_list VARCHAR(100)
    COMMENT "list of seasons for the virus",
  
  taxonomy_id INT
    COMMENT "",

  virus_name VARCHAR(10)
    COMMENT "short name for virus. ex. h1n1, h3n2",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for virus strains.";
