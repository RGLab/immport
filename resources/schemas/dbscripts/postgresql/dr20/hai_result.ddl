DROP TABLE IF EXISTS hai_result;

CREATE TABLE hai_result
(
  
  result_id INT NOT NULL
    COMMENT "Primary key.",

  arm_accession                        VARCHAR(15) NOT NULL
    COMMENT 'Reference to the arm in the ARM_OR_COHORT table.',

  biosample_accession                  VARCHAR(15) NOT NULL
    COMMENT 'Reference to the biological sample in the BIOSAMPLE table.',
  
  comments VARCHAR(500)
    COMMENT "This is the comments field.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment in the EXPERIMENT table.",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the expsample in the EXPSAMPLE table.",
  
  study_accession                      VARCHAR(15)
    COMMENT 'Reference to the study in the STUDY table.',
  
  study_time_collected                 FLOAT
    COMMENT 'Based on the time collected unit, the time when the sample was collected.',
  
  study_time_collected_unit            VARCHAR(25)
    COMMENT 'Reference to the unit in the LK_TIME_UNIT table.',
  
  subject_accession                    VARCHAR(15) NOT NULL
    COMMENT 'Reference to the subject in the SUBJECT table.',
  
  unit_preferred VARCHAR(50)
    COMMENT "Standardized name for the unit associated with this assay method.",
  
  unit_reported VARCHAR(200)
    COMMENT "Reported unit for the assay type measured.",
  
  value_preferred FLOAT
    COMMENT "Standardized numeric value computed from the reported value to deal with scenarios where extra characters such as < or > or H or L are embedded in the reported value.",
  
  value_reported VARCHAR(50)
    COMMENT "Value reported for the assay for the reported unit.",
  
  virus_strain_preferred VARCHAR(200)
    COMMENT "Preferred name for the virus strain against which the neutralizing antibody concentration is measured.",
  
  virus_strain_reported VARCHAR(200)
    COMMENT "Virus strain against which the neutralizing antibody concentration is measured.",

  workspace_id                         INT NOT NULL
    COMMENT 'Reference to the WORKSPACE to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.',

  
  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Result from a hemagglutination assay (or haemagglutination assay; ha) to quantify  virus or bacteria presence.";

CREATE INDEX idx_hai_arm_accession on hai_result(arm_accession);
CREATE INDEX idx_hai_biosample_accession on hai_result(biosample_accession);
CREATE INDEX idx_hai_experiment_accession on hai_result(experiment_accession);
CREATE INDEX idx_hai_expsample_accession on hai_result(expsample_accession);
CREATE INDEX idx_hai_study_accession on hai_result(study_accession);
CREATE INDEX idx_hai_subject_accession on hai_result(subject_accession);
CREATE INDEX idx_hai_workspace on hai_result(workspace_id);
