DROP TABLE IF EXISTS contract_grant_2_personnel;

CREATE TABLE contract_grant_2_personnel
(
  
  contract_grant_id INT NOT NULL
    COMMENT "Primary key.",
  
  personnel_id INT NOT NULL
    COMMENT "Reference to the personnel table",

  role_type VARCHAR(12)
    COMMENT "",
  
  PRIMARY KEY (contract_grant_id, personnel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Joins the contract_grant to the personnel table.";

create INDEX idx_contract_2_personnel on contract_grant_2_personnel(personnel_id,contract_grant_id)
