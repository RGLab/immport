DROP TABLE IF EXISTS expsample_public_repository;

CREATE TABLE expsample_public_repository
(
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Primary Key.",
  
  repository_accession VARCHAR(20) NOT NULL
    COMMENT "Short name or identifier.",
  
  repository_name VARCHAR(50) NOT NULL
    COMMENT "Short name or identifier.",
  
  PRIMARY KEY (expsample_accession, repository_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "This is the expsample_public_repository table.";
