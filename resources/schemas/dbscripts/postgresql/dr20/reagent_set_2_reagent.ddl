DROP TABLE IF EXISTS reagent_set_2_reagent;

CREATE TABLE reagent_set_2_reagent
(
  
  reagent_set_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the reagent which is the reagent set in the reagent table",
  
  reagent_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the reagent in the reagent table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (reagent_set_accession, reagent_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "join table that associates reagent set members with reagent table records.";

CREATE INDEX idx_reagent_set_reagent on reagent_set_2_reagent(reagent_accession,reagent_set_accession);   
CREATE INDEX idx_reagent_set_workspace on reagent_set_2_reagent(workspace_id);

