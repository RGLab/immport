DROP TABLE IF EXISTS elispot_result;

CREATE TABLE elispot_result
(
  
  result_id INT NOT NULL
    COMMENT "Primary key.",
  
  analyte_preferred VARCHAR(100)
    COMMENT "The preferred name for the molecule being assayed.",
  
  analyte_reported VARCHAR(100) NOT NULL
    COMMENT "The molecule being assayed.",

  arm_accession VARCHAR(15)
    COMMENT "Reference to the arm in the ARM_OR_COHORT table.",
  
  biosample_accession VARCHAR(15)
    COMMENT "Reference to the biological sample in the BIOSAMPLE table.",
  
  cell_number_preferred FLOAT
    COMMENT "The preferred cell number numeric value.",
  
  cell_number_reported VARCHAR(50)
    COMMENT "Cell number per well",
  
  comments VARCHAR(500)
    COMMENT "Comment field that defaults to the concatenation of the analyte, value and unit.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment in the EXPERIMENT table.",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the EXPSAMPLE table.",
  
  spot_number_preferred FLOAT
    COMMENT "Standardized numeric value computed from the reported value to deal with scenarios where extra characters such as < or > or H or L are embedded in the reported value.",
  
  spot_number_reported VARCHAR(50)
    COMMENT "Number of spots recorded in a well.",

  study_accession VARCHAR(15)
    COMMENT "Reference to the study in the STUDY table.",

  study_time_collected                 FLOAT
    COMMENT 'Based on the time collected unit, the time when the sample was collected.',

  study_time_collected_unit            VARCHAR(25)
    COMMENT 'Reference to the name in the LK_TIME_UNIT table.',

  subject_accession VARCHAR(15)
    COMMENT "Reference to the subject in the SUBJECT table.",

  workspace_id INT
    COMMENT "Reference to the Workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",

  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Captures results from enzyme-linked immunosorbent spot (ELISPOT) assay for monitoring immune responses in humans and animals.";

CREATE INDEX idx_elispot_study_accession on elispot_result(study_accession);
CREATE INDEX idx_elispot_arm_accession on elispot_result(arm_accession);
CREATE INDEX idx_elispot_biosample_accession on elispot_result(biosample_accession);
CREATE INDEX idx_elispot_experiment_accession on elispot_result(experiment_accession);
CREATE INDEX idx_elispot_expsample_accession on elispot_result(expsample_accession);
CREATE INDEX idx_elispot_subject_accession on elispot_result(subject_accession);
CREATE INDEX idx_elispot_workspace on elispot_result(workspace_id);
