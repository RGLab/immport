DROP TABLE IF EXISTS expsample_2_biosample;

CREATE TABLE expsample_2_biosample
(
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment sample in the EXPSAPLE table.",
  
  biosample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the biological sample in the BIOSAMPLE table.",
  
  PRIMARY KEY (expsample_accession, biosample_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates BIOSAMPLE with EXPSAMPLE table records.";

CREATE INDEX idx_expsample_2_biosample on expsample_2_biosample(biosample_accession,expsample_accession)
