DROP TABLE IF EXISTS protocol;

CREATE TABLE protocol
(
  
  protocol_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  description VARCHAR(4000)
    COMMENT "summary text about the protocol.",
  
  file_name VARCHAR(250) NOT NULL
    COMMENT "name of the protocol file.",
  
  name VARCHAR(250) NOT NULL
    COMMENT "short name or identifier.",
  
  original_file_name VARCHAR(250) NOT NULL
    COMMENT "this is the prot_original_file_name field.",
  
  type VARCHAR(100) NOT NULL DEFAULT 'Not Specified'
    COMMENT "reference to the protocol types in the lk_protocol_type table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (protocol_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the protocol table.";
