DROP TABLE IF EXISTS contract_grant;

CREATE TABLE contract_grant
(
  
  contract_grant_id INT NOT NULL
    COMMENT "Primary key.",
  
  category VARCHAR(50) NOT NULL
    COMMENT "This is the cg_category field.",
  
  description VARCHAR(4000)
    COMMENT "Summary of the details regarding the contract or grant.",
  
  end_date DATE
    COMMENT "Official end date of the contract or grant.",
  
  external_id VARCHAR(200) NOT NULL
    COMMENT "Official contract or grant identifier from nih or other funding agency  if available.",
  
  link VARCHAR(2000)
    COMMENT "This is the link field.",
  
  name VARCHAR(1000)
    COMMENT "Official title for the contract.",
  
  program_id INT NOT NULL
    COMMENT "Reference to the program in the program table.",
  
  start_date DATE
    COMMENT "Official start date of the contract or grant.",
  
  PRIMARY KEY (contract_grant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Contract or grant that funded the research.";

CREATE INDEX idx_contract_program on contract_grant(program_id);
