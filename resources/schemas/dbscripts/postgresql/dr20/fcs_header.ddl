DROP TABLE IF EXISTS fcs_header;

CREATE TABLE fcs_header
(
  fcs_header_id INT NOT NULL
    COMMENT "Primary key.",
  
  compensation_flag VARCHAR(1)
    COMMENT "(Y/N) flag regarding whether or not the source fcs file was compensated",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the EXPSAMPLE table",
  
  fcs_file_name VARCHAR(250)
    COMMENT "Name of the submitted file.",
  
  fcs_header_text LONGTEXT
    COMMENT "The text header portion of the fcs file.",
  
  fcs_version FLOAT
    COMMENT "Version of the fcs standard for this fcs file.",
  
  file_info_id INT NOT NULL
    COMMENT "Reference to the file in the file_info table.",
  
  maximum_intensity FLOAT
    COMMENT "Maximum intensity value found in the fcs file.",
  
  minimum_intensity FLOAT
    COMMENT "Minimum intensity value found in the fcs file.",
  
  number_of_events INT
    COMMENT "The total number of cells assayed in the fcs file.",
  
  number_of_markers INT
    COMMENT "Total number of markers assayed in the fcs file.",
  
  panel_preferred VARCHAR(2000)
    COMMENT "The curated set of marker names.",
  
  panel_reported VARCHAR(2000)
    COMMENT "The set of marker names reported in the fcs header",
  
  PRIMARY KEY (fcs_header_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "This is the fcs_header table.";

CREATE INDEX idx_fcs_header_expsample_accession on fcs_header(expsample_accession);
CREATE INDEX idx_fcs_header_file_info_id on fcs_header(file_info_id);
