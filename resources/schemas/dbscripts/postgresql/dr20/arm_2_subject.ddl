DROP TABLE IF EXISTS arm_2_subject;

CREATE TABLE arm_2_subject
(
  
  arm_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the Arm in the arm_or_cohort table.",
  
  subject_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the subject in the subject table.",
  
  age_event VARCHAR(50) NOT NULL DEFAULT 'Not Specified'
    COMMENT "This is the age_event field.",
  
  age_event_specify VARCHAR(50)
    COMMENT "This is the age_event_specify field.",
  
  age_unit VARCHAR(50) NOT NULL DEFAULT 'Not Specified'
    COMMENT "This is the age_unit field.",
  
  max_subject_age FLOAT
    COMMENT "Maximum numeric age of the subject.",
  
  min_subject_age FLOAT
    COMMENT "Minumum numeric age of the subject.",
  
  subject_phenotype VARCHAR(200)
    COMMENT "Short description of the subject phenotype.",
  
  PRIMARY KEY (arm_accession, subject_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Join table that associates Subject with ARM_OR_COHORT table records.";

CREATE INDEX idx_arm_2_subject_1 on arm_2_subject(subject_accession,arm_accession);

