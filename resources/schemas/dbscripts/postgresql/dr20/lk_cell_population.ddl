DROP TABLE IF EXISTS lk_cell_population;

CREATE TABLE lk_cell_population
(
  
  name VARCHAR(150) NOT NULL
    COMMENT "name or identifier.",
  
  comments VARCHAR(500)
    COMMENT "comments",
  
  definition VARCHAR(150)
    COMMENT "definition.",
  
  description VARCHAR(1000)
    COMMENT "description or identifier.",
  
  link VARCHAR(2000)
    COMMENT "url to cv term definition",

  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the cell populations.";
