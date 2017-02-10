DROP TABLE IF EXISTS fcs_header_marker;

CREATE TABLE fcs_header_marker
(
  
  fcs_header_id INT NOT NULL
    COMMENT "Primary key.",
  
  parameter_number INT NOT NULL
    COMMENT "The sequence number of parameter in fcs file (The 'N' in $PnN)",
  
  pnn_preferred VARCHAR(50)
    COMMENT "$PnN value curated with regard to reference sources",
  
  pnn_reported VARCHAR(50)
    COMMENT "$PnN value reported in fcs header",
  
  pns_preferred VARCHAR(50)
    COMMENT "$PnS value curated with regard to reference sources",
  
  pns_reported VARCHAR(50)
    COMMENT "$PnS value reported in fcs header",
  
  PRIMARY KEY (fcs_header_id, parameter_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "This is the fcs_header_marker table.";
