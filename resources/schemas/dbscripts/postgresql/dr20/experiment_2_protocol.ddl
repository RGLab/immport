DROP TABLE IF EXISTS experiment_2_protocol;

CREATE TABLE experiment_2_protocol
(
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to experiment in the EXPERIMENT table.",
  
  protocol_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to protocol in the PROTOCOL table.",
  
  PRIMARY KEY (experiment_accession, protocol_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates EXPERIMENT with PROTOCOL table records.";

CREATE INDEX idx_experiment_2_protocol on experiment_2_protocol(protocol_accession,experiment_accession);
