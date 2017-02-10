DROP TABLE IF EXISTS expsample_2_treatment;

CREATE TABLE expsample_2_treatment
(
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the EXPSAMPLE table.",
  
  treatment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the treatment in the TREATMENT table.",
  
  PRIMARY KEY (expsample_accession, treatment_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates EXPSAMPLE with TREATMENT table records.";

CREATE INDEX idx_expsample_2_treatment on expsample_2_treatment(treatment_accession,expsample_accession);
