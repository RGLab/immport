

/* DR25

Tables in Old Schema Only
================================================================

Tables in New Schema Only
================================================================
immune_exposure
lk_disease
lk_disease_stage
lk_exposure_material
lk_exposure_process
lk_subject_location
lk_transcript_type
rna_seq_result


====================================================================
Table:  assessment_panel
====================================================================

  Columns in Old Schema Only
  ====================================================================

  Columns in New Schema Only
  ====================================================================
   result_schema


====================================================================
Table:  pcr_result
====================================================================

  Columns in Old Schema Only
  ====================================================================
   gene_symbol

  Columns in New Schema Only
  ====================================================================
   gene_symbol_preferred
   gene_symbol_reported
*/


DROP TABLE IF EXISTS immport.immune_exposure;

CREATE TABLE immport.immune_exposure
(
  exposure_accession VARCHAR(15) NOT NULL,
  arm_accession VARCHAR(15) NOT NULL,
  disease_ontology_id VARCHAR(100),
  disease_preferred VARCHAR(50) NOT NULL,
  disease_reported VARCHAR(100) NOT NULL,
  disease_stage_preferred VARCHAR(50),
  disease_stage_reported VARCHAR(100),
  exposure_material_id VARCHAR(100),
  exposure_material_preferred VARCHAR(50) NOT NULL,
  exposure_material_reported VARCHAR(100) NOT NULL,
  exposure_process_preferred VARCHAR(50) NOT NULL,
  exposure_process_reported VARCHAR(100) NOT NULL,
  subject_accession VARCHAR(15),

  PRIMARY KEY (exposure_accession)
);

CREATE INDEX idx_immune_arm_accession on immport.immune_exposure(arm_accession);
CREATE INDEX idx_immune_subject_accession on immport.immune_exposure(subject_accession);


DROP TABLE IF EXISTS immport.lk_disease;

CREATE TABLE immport.lk_disease
(
  name VARCHAR(50) NOT NULL,
  disease_ontology_id VARCHAR(50) NOT NULL,
  description VARCHAR(1000) NOT NULL,
  link VARCHAR(2000),

  PRIMARY KEY (name)
);


DROP TABLE IF EXISTS immport.lk_disease_stage;

CREATE TABLE immport.lk_disease_stage
(
  name VARCHAR(50) NOT NULL,
  description VARCHAR(1000) NOT NULL,
  link VARCHAR(2000),

  PRIMARY KEY (name)
);

DROP TABLE IF EXISTS immport.lk_exposure_material;

CREATE TABLE immport.lk_exposure_material
(
  name VARCHAR(50) NOT NULL,
  exposure_material_id VARCHAR(50) NOT NULL,
  description VARCHAR(1000) NOT NULL,
  link VARCHAR(2000),

  PRIMARY KEY (name)
);


DROP TABLE IF EXISTS immport.lk_exposure_process;

CREATE TABLE immport.lk_exposure_process
(
  name VARCHAR(50) NOT NULL,
  description VARCHAR(1000) NOT NULL,
  link VARCHAR(2000),

  PRIMARY KEY (name)
);


DROP TABLE IF EXISTS immport.lk_subject_location;

CREATE TABLE immport.lk_subject_location
(
  name VARCHAR(50) NOT NULL,
  description VARCHAR(2500) NOT NULL,
  link VARCHAR(2000),

  PRIMARY KEY (name)
);


DROP TABLE IF EXISTS immport.lk_transcript_type;

CREATE TABLE immport.lk_transcript_type
(
  name VARCHAR(50) NOT NULL,
  description VARCHAR(1000) NOT NULL,
  link VARCHAR(2000),

  PRIMARY KEY (name)
);


DROP TABLE IF EXISTS immport.rna_seq_result;

CREATE TABLE immport.rna_seq_result
(
  result_id INT NOT NULL,
  arm_accession VARCHAR(15),
  biosample_accession VARCHAR(15),
  comments VARCHAR(500),
  experiment_accession VARCHAR(15) NOT NULL,
  expsample_accession VARCHAR(15) NOT NULL,
  reference_repository_name VARCHAR(50),
  reference_transcript_id VARCHAR(100),
  repository_accession VARCHAR(20),
  repository_name VARCHAR(50),
  result_unit_preferred VARCHAR(50),
  result_unit_reported VARCHAR(100),
  study_accession VARCHAR(15),
  study_time_collected FLOAT,
  study_time_collected_unit VARCHAR(25),
  subject_accession VARCHAR(15),
  transcript_type_preferred VARCHAR(50),
  transcript_type_reported VARCHAR(100),
  value_preferred FLOAT,
  value_reported FLOAT NOT NULL,
  workspace_id INT,

  PRIMARY KEY (result_id)
);

CREATE INDEX idx_rna_seq_study_accession on immport.rna_seq_result(study_accession);
CREATE INDEX idx_rna_seq_arm_accession on immport.rna_seq_result(arm_accession);
CREATE INDEX idx_rna_seq_biosample_accession on immport.rna_seq_result(biosample_accession);
CREATE INDEX idx_rna_seq_experiment_accession on immport.rna_seq_result(experiment_accession);
CREATE INDEX idx_rna_seq_expsample_accession on immport.rna_seq_result(expsample_accession);
CREATE INDEX idx_rna_seq_subject_accession on immport.rna_seq_result(subject_accession);
CREATE INDEX idx_rna_seq_workspace on immport.rna_seq_result(workspace_id);


ALTER TABLE immport.assessment_panel DROP COLUMN IF EXISTS result_schema;
ALTER TABLE immport.assessment_panel ADD COLUMN result_schema VARCHAR(50);


-- TODO drop pcr_result.gene_symbol
ALTER TABLE immport.pcr_result DROP COLUMN IF EXISTS gene_symbol_preferred;
ALTER TABLE immport.pcr_result DROP COLUMN IF EXISTS gene_symbol_reported;
ALTER TABLE immport.pcr_result ADD COLUMN gene_symbol_preferred VARCHAR(15);
ALTER TABLE immport.pcr_result ADD COLUMN gene_symbol_reported VARCHAR(15);

