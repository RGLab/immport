DROP TABLE IF EXISTS hla_typing_result;

CREATE TABLE hla_typing_result
(
  
  result_id INT NOT NULL
    COMMENT "Primary key.",
  
  allele_1 VARCHAR(250)
    COMMENT "Name of the first HLA allele assayed in standard hla nomenclature.",
  
  allele_2 VARCHAR(250)
    COMMENT "Name of the second HLA allele assayed in standard hla nomenclature.",
  
  ancestral_population VARCHAR(250)
    COMMENT "This is the ancestral_population field.",

  arm_accession                        VARCHAR(15) NOT NULL
    COMMENT 'Reference to the arm in the ARM_OR_COHORT table.',

  biosample_accession                  VARCHAR(15) NOT NULL
    COMMENT 'Reference to the biosample in the BIOSAMPLE table.', 

  comments VARCHAR(500)
    COMMENT "This is the comments field.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment in the EXPERIMENT table.",
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the expsample in the EXPSAMPLE table.",
  
  locus_name VARCHAR(25)
    COMMENT "This is the locus_name field.",
  
  result_set_id INT NOT NULL
    COMMENT "The typing template supports multiple loci and alleles per row. system generates a row set id per row.",

  study_accession                      VARCHAR(15) NOT NULL
    COMMENT 'Reference to the study in the STUDY table.',

  study_time_collected                 FLOAT
    COMMENT 'Based on the time collected unit, the time when the sample was collected.',

  study_time_collected_unit            VARCHAR(25)
    COMMENT 'Reference to the unit in the LK_TIME_UNIT table.',

  subject_accession                    VARCHAR(15) NOT NULL
    COMMENT 'Reference to the subject in the SUBJECT table.',

  workspace_id                         INT
    COMMENT 'Reference to the WORKSPACE to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.',

  
  PRIMARY KEY (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Captures the expert determined pair of allele values for the hla genes that were typed.";
