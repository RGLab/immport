DROP TABLE IF EXISTS biosample;

CREATE TABLE biosample
(
  
  biosample_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  description VARCHAR(4000)
    COMMENT "Long text description.",
  
  name VARCHAR(200)
    COMMENT "Short name or identifier.",
  
  planned_visit_accession VARCHAR(15)
    COMMENT "Reference to the planned visit in the planned_visit table.",
  
  study_accession VARCHAR(15)
    COMMENT "Reference to the study defined in the study table.",
  
  study_time_collected FLOAT
    COMMENT "Based on the time collected unit, the time when the sample was collected.",
  
  study_time_collected_unit VARCHAR(25) NOT NULL DEFAULT 'Not Specified'
    COMMENT "Reference to the unit in the lk_time_unit table.",
  
  study_time_t0_event VARCHAR(50) NOT NULL DEFAULT 'Not Specified'
    COMMENT "Reference to the event type in the lk_t0_event table.",
  
  study_time_t0_event_specify VARCHAR(50)
    COMMENT "If 'study time t0 event' = Other, this field specifies the study time t0 event.",
  
  subject_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the subject in the subject table.",
  
  subtype VARCHAR(50)
    COMMENT "Subcategory of sample type.",
  
  type VARCHAR(50) NOT NULL DEFAULT 'Not Specified'
    COMMENT "Reference to the sample types in the  lk_sample_type table.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (biosample_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Biological material that has undergone isolation, processing and/or reatment prior to use in an experiment;  attributes include all treatments and reagents used for sample processing and EXCLUDE reagents used to measure analytes.";

CREATE INDEX idx_biosample_subject on biosample(subject_accession);
CREATE INDEX idx_biosample_study on biosample(study_accession);
CREATE INDEX idx_biosample_planned_visit on biosample(planned_visit_accession);
CREATE INDEX idx_biosample_workspace on biosample(workspace_id);
