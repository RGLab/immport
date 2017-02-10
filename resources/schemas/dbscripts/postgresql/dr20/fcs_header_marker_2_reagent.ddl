DROP TABLE IF EXISTS fcs_header_marker_2_reagent;

CREATE TABLE fcs_header_marker_2_reagent
(
  
  fcs_header_id INT NOT NULL
    COMMENT "this is the fcs_header_id field.",
  
  parameter_number INT NOT NULL
    COMMENT "this is the parameter_number field.",
  
  reagent_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the reagent in the reagent table.",
  
  PRIMARY KEY (fcs_header_id, parameter_number, reagent_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the fcs_marker table.";

CREATE INDEX idx_fcs_header_marker_2_reagent on fcs_header_marker_2_reagent(reagent_accession,fcs_header_id);

