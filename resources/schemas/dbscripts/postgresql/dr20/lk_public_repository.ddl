DROP TABLE IF EXISTS lk_public_repository;

CREATE TABLE lk_public_repository
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "this is the description field.",
  
  link VARCHAR(100)
    COMMENT "this is the repository_link field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for public repository.";
