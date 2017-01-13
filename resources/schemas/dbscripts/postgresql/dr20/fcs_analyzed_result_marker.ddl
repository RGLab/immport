DROP TABLE IF EXISTS fcs_analyzed_result_marker;

CREATE TABLE fcs_analyzed_result_marker
(
  fcs_analyzed_result_marker_id INT NOT NULL
    COMMENT "Primary key.",
  
  population_marker_preferred VARCHAR(500)
    COMMENT "This is the population_marker_preferred field.",
  
  population_marker_reported VARCHAR(500)
    COMMENT "This is the population_marker_reported field.",
  
  result_id INT NOT NULL
    COMMENT "This is the result_id field.",
  
  PRIMARY KEY (fcs_analyzed_result_marker_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "This is the facs_analyzed_result_marker table.";
