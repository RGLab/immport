DROP TABLE IF EXISTS contract_grant_2_study;

CREATE TABLE contract_grant_2_study
(
  
  contract_grant_id INT NOT NULL
    COMMENT "Reference to the contract_grant table.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the study table.",
  
  PRIMARY KEY (contract_grant_id, study_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Joins thecontract_grant to the study table.";

CREATE INDEX idx_contract_grant_2_study_study on contract_grant_2_study(study_accession,contract_grant_id);
