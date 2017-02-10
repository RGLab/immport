DROP TABLE IF EXISTS lab_test_panel_2_protocol;

CREATE TABLE lab_test_panel_2_protocol
(
  
  lab_test_panel_accession VARCHAR(15) NOT NULL
    COMMENT "reference to lab_test_panel_accession in the lab_test_panel table.",
  
  protocol_accession VARCHAR(15) NOT NULL
    COMMENT "reference to protocol in the protocol table.",
  
  PRIMARY KEY (lab_test_panel_accession, protocol_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "join table that associates lab_test_panel with protocol table records.";

CREATE INDEX idx_lab_test_2_protocol on lab_test_panel_2_protocol(protocol_accession,lab_test_panel_accession);

