DROP TABLE IF EXISTS expsample_2_reagent;

CREATE TABLE expsample_2_reagent
(
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the EXPSAMPLE table.",
  
  reagent_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the reagent in the REAGENT table.",
  
  PRIMARY KEY (expsample_accession, reagent_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates EXPSAMPLE with REAGENT table records.";

CREATE INDEX idx_expsample_2_reagent on expsample_2_reagent(reagent_accession,expsample_accession);
