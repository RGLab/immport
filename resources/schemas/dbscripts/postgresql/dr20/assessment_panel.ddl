DROP TABLE IF EXISTS assessment_panel;

CREATE TABLE assessment_panel
(
  
  assessment_panel_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  assessment_type VARCHAR(125)
    COMMENT "Category of assessment performed, such as medical history; family history; questionnaire; other or more specific study specific assessment.",
  
  name_preferred VARCHAR(40)
    COMMENT "This is the preferred_name field.",
  
  name_reported VARCHAR(125)
    COMMENT "This is the assessment_name_reported field.",
  
  status VARCHAR(40)
    COMMENT "This is the status field.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the study defined in the study table.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (assessment_panel_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "This is the assessment_panel table.";

CREATE INDEX idx_assessment_panel_study on assessment_panel(study_accession);
CREATE INDEX idx_assessment_workspace on assessment_panel(workspace_id);
