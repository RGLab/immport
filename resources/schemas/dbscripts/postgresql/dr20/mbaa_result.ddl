DROP TABLE IF EXISTS mbaa_result;

CREATE TABLE mbaa_result
(
  
  result_id INT NOT NULL
    COMMENT "primary key.",
  
  analyte_preferred VARCHAR(100)
    COMMENT "this is the analyte_preferred field.",
  
  analyte_reported VARCHAR(100)
    COMMENT "name of the soluble protein being measured. we are defining an ontology to specify this allowed values for this field.",

  arm_accession                        VARCHAR(15)
    COMMENT 'Reference to the arm in the ARM_OR_COHORT table.',

  assay_group_id VARCHAR(100)
    COMMENT "associates this result with a set of results that may come from a group of plates or chips.",
  
  assay_id VARCHAR(100)
    COMMENT "associates this result with a set of results that come from the same plate or chip. a plate may have results for experiment sample, control sample, standard curve.",

  biosample_accession                  VARCHAR(15)
    COMMENT 'Reference to the biological sample in the BIOSAMPLE table.',

  comments VARCHAR(500)
    COMMENT "long text description",
  
  concentration_unit VARCHAR(100)
    COMMENT "the unit (e.g., pg/ml) of the concentration value. an ontology will be specified for this filed.",
  
  concentration_value VARCHAR(100)
    COMMENT "the value of concentration. if the result is linked to a standard curve, then the concentration is the actual concentration of the analyte. if this result is linked to an experiment sample or a control sample, then this refers to the concentration calculated from the mfi using the standard curve . if the value is calculated for an experiment sample or control sample and the value exceeds the detection limits of the standard curve, a user defined value shall be entered to indicate out of range (e.g. -999 or 999)",

  experiment_accession                 VARCHAR(15) NOT NULL
    COMMENT 'Reference to the experiment in the EXPERIMENT table.',
  
  mfi VARCHAR(100)
    COMMENT "median fluorescence intensity of the measurement.  captured as text in template and evaluated for conversion to number in database.",
  
  mfi_coordinate VARCHAR(100)
    COMMENT "records the position of the measurement on the plate or array.",
  
  source_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the experimental sample, control sample or standard curve in the appropriate table.",
  
  source_type VARCHAR(30) NOT NULL
    COMMENT "indicates the udi type (experiment sample, control sample, standard curve ) to be matched with the source id value.",

  study_accession                      VARCHAR(15)
    COMMENT 'Reference to the study in the STUDY table.',

  study_time_collected                 FLOAT
    COMMENT 'Based on the time collected unit, the time when the sample was collected.',

  study_time_collected_unit            VARCHAR(25)
    COMMENT 'Reference to the unit in the LK_TIME_UNIT table.',

  subject_accession                    VARCHAR(15)
    COMMENT 'Reference to the subject in the SUBJECT table.',

  workspace_id                         INT NOT NULL
    COMMENT 'Reference to the Workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.',

  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "captures results of enzyme-linked immunosorbent assay (elisa) tests or  that uses antibodies and color change to identify a substance onto a flat plate surface or multiplex bead array assays (mbaa) assays that captures ligands onto spherical beads using fluorescence detection.";

CREATE INDEX idx_mbaa_arm_accession on mbaa_result(arm_accession);
CREATE INDEX idx_mbaa_biosample_accession on mbaa_result(biosample_accession);
CREATE INDEX idx_mbaa_experiment_accession on mbaa_result(experiment_accession);
CREATE INDEX idx_mbaa_source_accession on mbaa_result(source_accession);
CREATE INDEX idx_mbaa_study_accession on mbaa_result(study_accession);
CREATE INDEX idx_mbaa_subject_accession on mbaa_result(subject_accession);
CREATE INDEX idx_mbaa_workspace on mbaa_result(workspace_id);

