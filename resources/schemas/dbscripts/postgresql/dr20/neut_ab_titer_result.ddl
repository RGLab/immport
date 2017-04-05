DROP TABLE IF EXISTS neut_ab_titer_result;

CREATE TABLE neut_ab_titer_result
(
  
  result_id INT NOT NULL
    COMMENT "primary key.",

  arm_accession                        VARCHAR(15) NOT NULL
    COMMENT "Reference to the arm in the ARM_OR_COHORT table.",

  biosample_accession                  VARCHAR(15) NOT NULL
    COMMENT "Reference to the biological sample in the BIOSAMPLE table.",

  comments VARCHAR(500)
    COMMENT "this is the comments field.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the experiment in the experiment table.",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the experimental sample in the expsample table.",
  
  study_accession                      VARCHAR(15)
    COMMENT "Reference to the study in the STUDY table.",

  study_time_collected                 FLOAT
    COMMENT "Based on the time collected unit, the time when the sample was collected.",

  study_time_collected_unit            VARCHAR(25)
    COMMENT "Reference to the unit in the LK_TIME_UNIT table.",

  subject_accession                    VARCHAR(15) NOT NULL
    COMMENT "Reference to the subject in the SUBJECT table.",

  unit_preferred VARCHAR(50)
    COMMENT "standardized name for the unit associated with this assay method.",
  
  unit_reported VARCHAR(200)
    COMMENT "reported unit for the assay type measured.",
  
  value_preferred FLOAT
    COMMENT "standardized numeric value computed from the reported value to deal with scenarios where extra characters such as < or > or h or l are embedded in the reported value.",
  
  value_reported VARCHAR(50)
    COMMENT "value reported for the assay for the reported unit; may contain extra characters such as < or > or h or l are embedded in the reported value.",
  
  virus_strain_preferred VARCHAR(200)
    COMMENT "preferred value for the virus strain against which the neutralizing antibody concentraion is measured.",
  
  virus_strain_reported VARCHAR(200)
    COMMENT "virus strain against which the neutralizing antibody concentraion is measured.",

  workspace_id                         INT
    COMMENT "Reference to the Workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",

  
  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "concentration of antibody in a sample that can neutralize a challenge or target; concentration is usually expressed in terms of tier (inverse of a dilution factor).";

CREATE INDEX idx_neut_arm_accession on neut_ab_titer_result(arm_accession);
CREATE INDEX idx_neut_biosample_accession on neut_ab_titer_result(biosample_accession);
CREATE INDEX idx_neut_experiment_accession on neut_ab_titer_result(experiment_accession);
CREATE INDEX idx_neut_expsample_accession on neut_ab_titer_result(expsample_accession);
CREATE INDEX idx_neut_study_accession on neut_ab_titer_result(study_accession);
CREATE INDEX idx_neut_subject_accession on neut_ab_titer_result(subject_accession);
CREATE INDEX idx__workspace on neut_ab_titer_result(workspace_id);
