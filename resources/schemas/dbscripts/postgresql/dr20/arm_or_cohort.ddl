DROP TABLE IF EXISTS arm_or_cohort;

CREATE TABLE arm_or_cohort
(
  
  arm_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  description VARCHAR(4000)
    COMMENT "States the purpose of the ARM and elaborates the method for separating subjects.",
  
  name VARCHAR(126)
    COMMENT "Equivlant to the label in Clinical Trials.gov term representing the name of the ARM.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the study defined in the study table.",
  
  type VARCHAR(20)
    COMMENT "CV from source CT.gov: Experimental Active Comparator Placebo Comparator Sham Comparator No Intervention Other.  The type 'Other' should be used for one-armed observational studies.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (arm_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "A specialized population selection rule for the study.";

CREATE INDEX idx_arm_or_cohort_study on arm_or_cohort(study_accession,arm_accession);
CREATE INDEX idx_arm_or_cohort_workspace on arm_or_cohort(workspace_id);
