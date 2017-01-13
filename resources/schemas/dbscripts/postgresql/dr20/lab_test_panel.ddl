DROP TABLE IF EXISTS lab_test_panel;

CREATE TABLE lab_test_panel
(
  
  lab_test_panel_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the panel defined in the lab_test_panel table.",
  
  name_preferred VARCHAR(125)
    COMMENT "standardized name or code for the lab test (cv, tbd).",
  
  name_reported VARCHAR(125)
    COMMENT "a specific identifier for a test (e.g., wbc for white blood count).",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study defined in the study table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions",
  
  PRIMARY KEY (lab_test_panel_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lab_test_panel table.";

CREATE INDEX idx_lab_test_panel_study on lab_test_panel(study_accession);

