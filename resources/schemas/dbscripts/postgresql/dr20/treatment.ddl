DROP TABLE IF EXISTS treatment;

CREATE TABLE treatment
(
  
  treatment_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  amount_unit VARCHAR(50) DEFAULT 'Not Specified'
    COMMENT "amount unit.",
  
  amount_value VARCHAR(50) DEFAULT 'Not Specified'
    COMMENT "the amount of the treatment agent provided.",
  
  comments VARCHAR(500)
    COMMENT "this is the comments field.",
  
  duration_unit VARCHAR(50) DEFAULT 'Not Specified'
    COMMENT "duration unit.",
  
  duration_value VARCHAR(200) DEFAULT 'Not Specified'
    COMMENT "the duration of the treatment agent provided.",
  
  name VARCHAR(100)
    COMMENT "short name or identifier.",
  
  temperature_unit VARCHAR(50) DEFAULT 'Not Specified'
    COMMENT "temperature unit.",
  
  temperature_value VARCHAR(50) DEFAULT 'Not Specified'
    COMMENT "the temperature for the treatment agent.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (treatment_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "action applied to a sample by an agent (e.g. a compound), a temperature change, and or a duration of some action (e.g. a time course)";

CREATE INDEX idx_treatment_workspace on treatment(workspace_id);
