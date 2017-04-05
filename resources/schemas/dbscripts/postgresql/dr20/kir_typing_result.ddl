DROP TABLE IF EXISTS kir_typing_result;

CREATE TABLE kir_typing_result
(
  
  result_id INT NOT NULL
    COMMENT "primary key.",
  
  allele VARCHAR(500)
    COMMENT "name of the first kir allele assayed in standard kir nomenclature.",
  
  ancestral_population VARCHAR(250) NOT NULL
    COMMENT "this is the pop_area_name field.",

 arm_accession                        VARCHAR(15) NOT NULL
    COMMENT 'Reference to the arm in the ARM_OR_COHORT table.',

  biosample_accession                  VARCHAR(15) NOT NULL
    COMMENT 'Reference to the biological sample in the BIOSAMPLE table.',

  comments VARCHAR(500)
    COMMENT "comments are free text to capture details not present in standard columns.",
  
  copy_number INT
    COMMENT "count of the number of copies of the kir section of dna.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the experiment in the experiment table.",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the experimental sample in the expsample table.",
  
  gene_name VARCHAR(25) NOT NULL
    COMMENT "hugo gene name for the kir locus being assayed,",
  
  present_absent VARCHAR(10)
    COMMENT "an indication of whether an allele was observed.",
  
  result_set_id INT NOT NULL
    COMMENT "the typing template supports multiple loci and alleles per row. system generates a row set id per row.",

  study_accession                      VARCHAR(15) NOT NULL
    COMMENT 'Reference to the study in the STUDY table.',

  study_time_collected                 FLOAT
    COMMENT 'Based on the time collected unit, the time when the sample was collected.',

  study_time_collected_unit            VARCHAR(25)
    COMMENT 'Reference to the unit in the LK_TIME_UNIT table.',

  subject_accession                    VARCHAR(15) NOT NULL
    COMMENT 'Reference to the subject in the SUBJECT table.',

  workspace_id                         INT
    COMMENT 'Reference to the Workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.',

  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "captures the expert determined allele values for the kir genes that were typed.";

CREATE INDEX idx_kir_arm_accession on kir_typing_result(arm_accession);
CREATE INDEX idx_kir_biosample_accession on kir_typing_result(biosample_accession);
CREATE INDEX idx_kir_experiment_accession on kir_typing_result(experiment_accession);
CREATE INDEX idx_kir_expsample_accession on kir_typing_result(expsample_accession);
CREATE INDEX idx_kir_subject_accession on kir_typing_result(subject_accession);
CREATE INDEX idx_kir_study_accession on kir_typing_result(study_accession);
CREATE INDEX idx_kir_workspace on kir_typing_result(workspace_id);

