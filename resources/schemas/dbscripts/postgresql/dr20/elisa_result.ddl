DROP TABLE IF EXISTS elisa_result;

CREATE TABLE elisa_result
(
  
  result_id INT NOT NULL
    COMMENT "Primary key.",
  
  analyte_preferred VARCHAR(100)
    COMMENT "The preferred name for the soluble chemokine or antibody assayed.",
  
  analyte_reported VARCHAR(100) NOT NULL
    COMMENT "The soluble chemokine or antibody assayed.",
  
  arm_accession VARCHAR(15)
    COMMENT "Reference to the arm in the arm_or_cohort table.",

  biosample_accession VARCHAR(15)
    COMMENT "Reference to the biological sample in the BIOSAMPLE table.",

  comments VARCHAR(500)
    COMMENT "Free text to capture details not present in standard columns.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment in the experiment table.",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the expsample table.",
  
  study_accession VARCHAR(15)
    COMMENT "Reference to the study in the STUDY table.",

  study_time_collected                 FLOAT
    COMMENT 'Based on the time collected unit, the time when the sample was collected.',

  study_time_collected_unit            VARCHAR(25)
    COMMENT 'Reference to the name in the LK_TIME_UNIT table.',
  
  subject_accession VARCHAR(15)
    COMMENT "Reference to the subject in the SUBJECT table.",
  
  unit_preferred VARCHAR(50)
    COMMENT "Standardized name for the unit associated with this assay method.",
  
  unit_reported VARCHAR(200)
    COMMENT "Reported unit for the assay type measured.",
  
  value_preferred FLOAT
    COMMENT "Standardized numeric value computed from the reported value to deal with scenarios where extra characters such as < or > or H or L are embedded in the reported value.",
  
  value_reported VARCHAR(50)
    COMMENT "Value reported for the assay.",

  workspace_id INT
    COMMENT "Reference to the Workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Captures results of enzyme-linked immunosorbent assay (ELISA) tests or  that uses antibodies and color change to identify a substance onto a flat plate surface or multiplex bead array assays (MBAA) assays that captures ligands onto spherical beads using fluorescence detection.";

CREATE INDEX idx_elisa_study_accession on elisa_result(study_accession);
CREATE INDEX idx_elisa_arm_accession on elisa_result(arm_accession);
CREATE INDEX idx_elisa_biosample_accession on elisa_result(biosample_accession);
CREATE INDEX idx_elisa_experiment_accession on elisa_result(experiment_accession);
CREATE INDEX idx_elisa_expsample_accession on elisa_result(expsample_accession);
CREATE INDEX idx_elisa_subject_accession on elisa_result(subject_accession);
CREATE INDEX idx_elisa_workspace on elisa_result(workspace_id);
