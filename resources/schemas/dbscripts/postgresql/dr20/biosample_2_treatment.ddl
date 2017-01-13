DROP TABLE IF EXISTS biosample_2_treatment;

CREATE TABLE biosample_2_treatment
(
  
  biosample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the biosample in the biosample table.",
  
  treatment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the treatment in the treatment table.",
  
  PRIMARY KEY (biosample_accession, treatment_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates biosample with treatment table records.";

CREATE INDEX idx_biosample_2_treatment on biosample_2_treatment(treatment_accession,biosample_accession);
