DROP TABLE IF EXISTS reported_early_termination;

CREATE TABLE reported_early_termination
(
  
  early_termination_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  is_adverse_event_related VARCHAR(1)
    COMMENT "(y/n) field to indicate whether an adverse event suffered by the subject contributed to the removal from the study prematurely.",
  
  is_subject_requested VARCHAR(1)
    COMMENT "(y/n) flag as to whether or not the subject requested to be removed from the study.",
  
  reason_preferred VARCHAR(40)
    COMMENT "standardized code for the reason for study subject termination  (cv is still tbd).",
  
  reason_reported VARCHAR(250)
    COMMENT "reason noted by the data provider for why the subject terminated participation in the study.",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study defined in the study table.",
  
  study_day_reported INT
    COMMENT "day in the study timeline when the early termination was noted.",
  
  subject_accession VARCHAR(15)
    COMMENT "reference to the subject in the subject table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions",
  
  PRIMARY KEY (early_termination_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "records information about why a particular subject did not complete participation in the study, including whether or not the termination was adverse event related.";

CREATE INDEX idx_early_termination_study on reported_early_termination(study_accession);
CREATE INDEX idx_early_termination_subject on reported_early_termination(subject_accession);
CREATE INDEX idx_early_termination_workspace on reported_early_termination(workspace_id);

