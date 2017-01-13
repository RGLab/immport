DROP TABLE IF EXISTS protocol_deviation;

CREATE TABLE protocol_deviation
(
  
  protocol_deviation_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  description VARCHAR(4000) NOT NULL
    COMMENT "long text description of the deviation from the study protocol, most applicable for clinical studies.",
  
  is_adverse_event_related VARCHAR(1)
    COMMENT "(y/n) field to indicate whether an adverse event suffered by the subject contributed to the protocol deviation.",
  
  reason_for_deviation VARCHAR(250)
    COMMENT "long description for the reason for deviating from the study protocol.",
  
  resolution_of_deviation VARCHAR(500)
    COMMENT "long description of the action taken to prevent deviation from re-occuring.",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study in the study table.",
  
  study_end_day INT
    COMMENT "day in the study timeline where the deviation ended.",
  
  study_start_day INT NOT NULL
    COMMENT "day in the study timeline where the deviation began.",
  
  subject_accession VARCHAR(15)
    COMMENT "reference to the subject in the subject table.",
  
  subject_continued_study VARCHAR(1)
    COMMENT "an indicator (y/n) as to whether the subject continued to participate in the study.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions",
  
  PRIMARY KEY (protocol_deviation_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "records the documented deviations from the defined study protocol.";

CREATE INDEX idx_procotol_deviation_study on protocol_deviation(study_accession);
CREATE INDEX idx_procotol_deviation_subject on protocol_deviation(subject_accession);
CREATE INDEX idx_procotol_deviation_workspace on protocol_deviation(workspace_id);

