DROP TABLE IF EXISTS fcs_analyzed_result;

CREATE TABLE fcs_analyzed_result
(
  
  result_id INT NOT NULL
    COMMENT "Primary key.",

  arm_accession VARCHAR(15)
    COMMENT "Reference to the arm in the ARM_OR_COHORT table.",

  biosample_accession VARCHAR(15)
    COMMENT "Reference to the biosample in the BIOSAMPLE table",

  comments VARCHAR(500)
    COMMENT "Long description of the derived flow cytometry result.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment in the EXPERIMENT table.",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the EXPSAMPLE table.",
  
  parent_population_preferred VARCHAR(150)
    COMMENT "Base or parent population preferred term for population percentage calculation",
  
  parent_population_reported VARCHAR(150)
    COMMENT "Base or parent population for population percentage calculation",
  
  population_defnition_preferred VARCHAR(150)
    COMMENT "A description of the cell population.",
  
  population_defnition_reported VARCHAR(150)
    COMMENT "A description of the cell population.",
  
  population_name_preferred VARCHAR(150)
    COMMENT "A description of the cell population.",
  
  population_name_reported VARCHAR(150)
    COMMENT "A description of the cell population.",
  
  population_stat_unit_preferred VARCHAR(50)
    COMMENT "This is the pop_stat_unit_preferred field.",
  
  population_stat_unit_reported VARCHAR(50)
    COMMENT "This is the population_stat_unit_reported field.",
  
  population_statistic_preferred FLOAT
    COMMENT "The preferred population statistic numeric value.",
  
  population_statistic_reported VARCHAR(50)
    COMMENT "The reported population statistic numeric value.",

  study_accession VARCHAR(15)
    COMMENT "Reference to the study in the STUDY table",

  study_time_collected                 FLOAT
    COMMENT 'Based on the time collected unit, the time when the sample was collected.',

  study_time_collected_unit            VARCHAR(25)
    COMMENT 'Reference to the unit in the LK_TIME_UNIT table.',

  subject_accession VARCHAR(15)
    COMMENT "Reference to the subject in the SUBJECT table.",

  workspace_file_info_id INT
    COMMENT "this is the workspace_file_info_id field.",

  workspace_id INT
    COMMENT "Reference to the Workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Refers to the analysis results of .fcs file contents and includes measures of population cell number, gating definitions and other statistics.";

CREATE INDEX idx_fcs_analyzed_study_accession on fcs_analyzed_result(study_accession);
CREATE INDEX idx_fcs_analyzed_arm_accession on fcs_analyzed_result(arm_accession);
CREATE INDEX idx_fcs_analyzed_biosample_accession on fcs_analyzed_result(biosample_accession);
CREATE INDEX idx_fcs_analyzed_experiment_accession on fcs_analyzed_result(experiment_accession);
CREATE INDEX idx_fcs_analyzed_expsample_accession on fcs_analyzed_result(expsample_accession);
CREATE INDEX idx_fcs_analyzed_subject_accession on fcs_analyzed_result(subject_accession);
CREATE INDEX idx_fcs_analyzed_workspace on fcs_analyzed_result(workspace_id);
