CREATE TABLE immport.adverse_event
(
adverse_event_accession VARCHAR(15) NOT NULL,
causality VARCHAR(250),
description VARCHAR(4000),
end_study_day FLOAT,
end_time VARCHAR(40),
location_of_reaction_preferred VARCHAR(126),
location_of_reaction_reported VARCHAR(126),
name_preferred VARCHAR(126),
name_reported VARCHAR(126),
organ_or_body_system_preferred VARCHAR(126),
organ_or_body_system_reported VARCHAR(126),
other_action_taken VARCHAR(250),
outcome_preferred VARCHAR(40),
outcome_reported VARCHAR(40),
relation_to_nonstudy_treatment VARCHAR(250),
relation_to_study_treatment VARCHAR(250),
severity_preferred VARCHAR(60),
severity_reported VARCHAR(60) NOT NULL,
start_study_day FLOAT,
start_time VARCHAR(40),
study_accession VARCHAR(15) NOT NULL,
study_treatment_action_taken VARCHAR(250),
subject_accession VARCHAR(15) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (adverse_event_accession)
);
CREATE INDEX idx_adverse_event_subject ON immport.adverse_event(subject_accession);
CREATE INDEX idx_adverse_event_study ON immport.adverse_event(study_accession);
CREATE INDEX idx_adverse_event_workspace ON immport.adverse_event(workspace_id);
CREATE TABLE immport.arm_2_subject
(
arm_accession VARCHAR(15) NOT NULL,
subject_accession VARCHAR(15) NOT NULL,
age_event VARCHAR(50) NOT NULL DEFAULT 'Not Specified',
age_event_specify VARCHAR(50),
age_unit VARCHAR(50) NOT NULL DEFAULT 'Not Specified',
max_subject_age FLOAT,
min_subject_age FLOAT,
subject_phenotype VARCHAR(200),
PRIMARY KEY (arm_accession, subject_accession)
);
CREATE INDEX idx_arm_2_subject_1 ON immport.arm_2_subject(subject_accession,arm_accession);
CREATE TABLE immport.arm_or_cohort
(
arm_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000),
name VARCHAR(126),
study_accession VARCHAR(15) NOT NULL,
type VARCHAR(20),
workspace_id INT NOT NULL,
PRIMARY KEY (arm_accession)
);
CREATE INDEX idx_arm_or_cohort_study ON immport.arm_or_cohort(study_accession,arm_accession);
CREATE INDEX idx_arm_or_cohort_workspace ON immport.arm_or_cohort(workspace_id);
CREATE TABLE immport.assessment_2_file_info
(
assessment_panel_accession VARCHAR(15) NOT NULL,
file_info_id INT NOT NULL,
data_format VARCHAR(100) NOT NULL,
result_schema VARCHAR(50) NOT NULL,
PRIMARY KEY (assessment_panel_accession, file_info_id)
);
CREATE INDEX idx_assessment_2_file_info ON immport.assessment_2_file_info(file_info_id,assessment_panel_accession);
CREATE TABLE immport.assessment_component
(
assessment_component_accession VARCHAR(15) NOT NULL,
age_at_onset_preferred FLOAT,
age_at_onset_reported VARCHAR(100),
age_at_onset_unit_preferred VARCHAR(40),
age_at_onset_unit_reported VARCHAR(25),
assessment_panel_accession VARCHAR(15) NOT NULL,
is_clinically_significant VARCHAR(1) DEFAULT 'U',
location_of_finding_preferred VARCHAR(256),
location_of_finding_reported VARCHAR(256),
name_preferred VARCHAR(150),
name_reported VARCHAR(150) NOT NULL,
organ_or_body_system_preferred VARCHAR(100),
organ_or_body_system_reported VARCHAR(100),
planned_visit_accession VARCHAR(15),
reference_range_accession VARCHAR(15),
result_unit_preferred VARCHAR(40),
result_unit_reported VARCHAR(40),
result_value_category VARCHAR(40),
result_value_preferred FLOAT,
result_value_reported VARCHAR(250),
study_day FLOAT,
subject_accession VARCHAR(15) NOT NULL,
subject_position_preferred VARCHAR(40),
subject_position_reported VARCHAR(40),
time_of_day VARCHAR(40),
verbatim_question VARCHAR(250),
who_is_assessed VARCHAR(40),
workspace_id INT NOT NULL,
PRIMARY KEY (assessment_component_accession)
);
CREATE INDEX idx_assessment_component_assessment_panel ON immport.assessment_component(assessment_panel_accession);
CREATE INDEX idx_assessment_component_subject ON immport.assessment_component(subject_accession);
CREATE INDEX idx_assessment_component_planned_visit ON immport.assessment_component(planned_visit_accession);
CREATE INDEX idx_assessment_workspace ON immport.assessment_component(workspace_id);
CREATE TABLE immport.assessment_panel
(
assessment_panel_accession VARCHAR(15) NOT NULL,
assessment_type VARCHAR(125),
name_preferred VARCHAR(40),
name_reported VARCHAR(125),
status VARCHAR(40),
study_accession VARCHAR(15) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (assessment_panel_accession)
);
CREATE INDEX idx_assessment_panel_study ON immport.assessment_panel(study_accession);
CREATE INDEX idx_assessment_panel_workspace ON immport.assessment_panel(workspace_id);
CREATE TABLE immport.biosample
(
biosample_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000),
name VARCHAR(200),
planned_visit_accession VARCHAR(15),
study_accession VARCHAR(15),
study_time_collected FLOAT,
study_time_collected_unit VARCHAR(25) NOT NULL DEFAULT 'Not Specified',
study_time_t0_event VARCHAR(50) NOT NULL DEFAULT 'Not Specified',
study_time_t0_event_specify VARCHAR(50),
subject_accession VARCHAR(15) NOT NULL,
subtype VARCHAR(50),
type VARCHAR(50) NOT NULL DEFAULT 'Not Specified',
workspace_id INT NOT NULL,
PRIMARY KEY (biosample_accession)
);
CREATE INDEX idx_biosample_subject ON immport.biosample(subject_accession);
CREATE INDEX idx_biosample_study ON immport.biosample(study_accession);
CREATE INDEX idx_biosample_planned_visit ON immport.biosample(planned_visit_accession);
CREATE INDEX idx_biosample_workspace ON immport.biosample(workspace_id);
CREATE TABLE immport.biosample_2_treatment
(
biosample_accession VARCHAR(15) NOT NULL,
treatment_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (biosample_accession, treatment_accession)
);
CREATE INDEX idx_biosample_2_treatment ON immport.biosample_2_treatment(treatment_accession,biosample_accession);
CREATE TABLE immport.contract_grant
(
contract_grant_id INT NOT NULL,
category VARCHAR(50) NOT NULL,
description VARCHAR(4000),
end_date DATE,
external_id VARCHAR(200) NOT NULL,
link VARCHAR(2000),
name VARCHAR(1000),
program_id INT NOT NULL,
start_date DATE,
PRIMARY KEY (contract_grant_id)
);
CREATE INDEX idx_contract_program ON immport.contract_grant(program_id);
CREATE TABLE immport.contract_grant_2_personnel
(
contract_grant_id INT NOT NULL,
personnel_id INT NOT NULL,
role_type VARCHAR(12),
PRIMARY KEY (contract_grant_id, personnel_id)
);
CREATE TABLE immport.contract_grant_2_study
(
contract_grant_id INT NOT NULL,
study_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (contract_grant_id, study_accession)
);
CREATE INDEX idx_contract_grant_2_study_study ON immport.contract_grant_2_study(study_accession,contract_grant_id);
CREATE TABLE immport.control_sample
(
control_sample_accession VARCHAR(15) NOT NULL,
assay_group_id VARCHAR(100),
assay_id VARCHAR(100),
catalog_id VARCHAR(100),
dilution_factor VARCHAR(100),
experiment_accession VARCHAR(15) NOT NULL,
lot_number VARCHAR(100),
result_schema VARCHAR(50) NOT NULL DEFAULT 'OTHER',
source VARCHAR(100),
upload_result_status VARCHAR(20),
workspace_id INT NOT NULL,
PRIMARY KEY (control_sample_accession)
);
CREATE INDEX idx_control_sample_workspace ON immport.control_sample(workspace_id);
CREATE TABLE immport.control_sample_2_file_info
(
control_sample_accession VARCHAR(15) NOT NULL,
file_info_id INT NOT NULL,
data_format VARCHAR(100) NOT NULL,
result_schema VARCHAR(50) NOT NULL,
PRIMARY KEY (control_sample_accession, file_info_id)
);
CREATE INDEX idx_control_sample_2_file_info ON immport.control_sample_2_file_info(file_info_id,control_sample_accession);
CREATE TABLE immport.elisa_result
(
result_id INT NOT NULL,
analyte_preferred VARCHAR(100),
analyte_reported VARCHAR(100) NOT NULL,
arm_accession VARCHAR(15),
biosample_accession VARCHAR(15),
comments VARCHAR(500),
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
study_accession VARCHAR(15),
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession VARCHAR(15),
unit_preferred VARCHAR(50),
unit_reported VARCHAR(200),
value_preferred FLOAT,
value_reported VARCHAR(50),
workspace_id INT,
PRIMARY KEY (result_id)
);
CREATE INDEX idx_elisa_study_accession ON immport.elisa_result(study_accession);
CREATE INDEX idx_elisa_arm_accession ON immport.elisa_result(arm_accession);
CREATE INDEX idx_elisa_biosample_accession ON immport.elisa_result(biosample_accession);
CREATE INDEX idx_elisa_experiment_accession ON immport.elisa_result(experiment_accession);
CREATE INDEX idx_elisa_expsample_accession ON immport.elisa_result(expsample_accession);
CREATE INDEX idx_elisa_subject_accession ON immport.elisa_result(subject_accession);
CREATE INDEX idx_elisa_workspace ON immport.elisa_result(workspace_id);
CREATE TABLE immport.elispot_result
(
result_id INT NOT NULL,
analyte_preferred VARCHAR(100),
analyte_reported VARCHAR(100) NOT NULL,
arm_accession VARCHAR(15),
biosample_accession VARCHAR(15),
cell_number_preferred FLOAT,
cell_number_reported VARCHAR(50),
comments VARCHAR(500),
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
spot_number_preferred FLOAT,
spot_number_reported VARCHAR(50),
study_accession VARCHAR(15),
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession VARCHAR(15),
workspace_id INT,
PRIMARY KEY (result_id)
);
CREATE INDEX idx_elispot_study_accession ON immport.elispot_result(study_accession);
CREATE INDEX idx_elispot_arm_accession ON immport.elispot_result(arm_accession);
CREATE INDEX idx_elispot_biosample_accession ON immport.elispot_result(biosample_accession);
CREATE INDEX idx_elispot_experiment_accession ON immport.elispot_result(experiment_accession);
CREATE INDEX idx_elispot_expsample_accession ON immport.elispot_result(expsample_accession);
CREATE INDEX idx_elispot_subject_accession ON immport.elispot_result(subject_accession);
CREATE INDEX idx_elispot_workspace ON immport.elispot_result(workspace_id);
CREATE TABLE immport.experiment
(
experiment_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000),
measurement_technique VARCHAR(50) NOT NULL,
name VARCHAR(500),
purpose VARCHAR(50),
study_accession VARCHAR(15),
workspace_id INT NOT NULL,
PRIMARY KEY (experiment_accession)
);
CREATE INDEX idx_experiment_study ON immport.experiment(study_accession);
CREATE INDEX idx_experiment_workspace ON immport.experiment(workspace_id);
CREATE TABLE immport.experiment_2_protocol
(
experiment_accession VARCHAR(15) NOT NULL,
protocol_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (experiment_accession, protocol_accession)
);
CREATE INDEX idx_experiment_2_protocol ON immport.experiment_2_protocol(protocol_accession,experiment_accession);
CREATE TABLE immport.expsample
(
expsample_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000),
experiment_accession VARCHAR(15) NOT NULL,
name VARCHAR(200),
result_schema VARCHAR(50) NOT NULL DEFAULT 'OTHER',
upload_result_status VARCHAR(20),
workspace_id INT NOT NULL,
PRIMARY KEY (expsample_accession)
);
CREATE INDEX idx_expsample_experiment ON immport.expsample(experiment_accession);
CREATE INDEX idx_expsample_workspace ON immport.expsample(workspace_id);
CREATE TABLE immport.expsample_2_biosample
(
expsample_accession VARCHAR(15) NOT NULL,
biosample_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (expsample_accession, biosample_accession)
);
CREATE INDEX idx_expsample_2_biosample ON immport.expsample_2_biosample(biosample_accession,expsample_accession);
CREATE TABLE immport.expsample_2_file_info
(
expsample_accession VARCHAR(15) NOT NULL,
file_info_id INT NOT NULL,
data_format VARCHAR(100) NOT NULL,
result_schema VARCHAR(50) NOT NULL,
PRIMARY KEY (expsample_accession, file_info_id)
);
CREATE INDEX idx_expsample_2_file_info ON immport.expsample_2_file_info(file_info_id,expsample_accession);
CREATE TABLE immport.expsample_2_reagent
(
expsample_accession VARCHAR(15) NOT NULL,
reagent_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (expsample_accession, reagent_accession)
);
CREATE INDEX idx_expsample_2_reagent ON immport.expsample_2_reagent(reagent_accession,expsample_accession);
CREATE TABLE immport.expsample_2_treatment
(
expsample_accession VARCHAR(15) NOT NULL,
treatment_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (expsample_accession, treatment_accession)
);
CREATE INDEX idx_expsample_2_treatment ON immport.expsample_2_treatment(treatment_accession,expsample_accession);
CREATE TABLE immport.expsample_mbaa_detail
(
expsample_accession VARCHAR(15) NOT NULL,
assay_group_id VARCHAR(100),
assay_id VARCHAR(100),
dilution_factor VARCHAR(100),
plate_type VARCHAR(100),
PRIMARY KEY (expsample_accession)
);
CREATE TABLE immport.expsample_public_repository
(
expsample_accession VARCHAR(15) NOT NULL,
repository_accession VARCHAR(20) NOT NULL,
repository_name VARCHAR(50) NOT NULL,
PRIMARY KEY (expsample_accession, repository_accession)
);
CREATE TABLE immport.fcs_analyzed_result
(
result_id INT NOT NULL,
arm_accession VARCHAR(15),
biosample_accession VARCHAR(15),
comments VARCHAR(500),
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
parent_population_preferred VARCHAR(150),
parent_population_reported VARCHAR(150),
population_defnition_preferred VARCHAR(150),
population_defnition_reported VARCHAR(150),
population_name_preferred VARCHAR(150),
population_name_reported VARCHAR(150),
population_stat_unit_preferred VARCHAR(50),
population_stat_unit_reported VARCHAR(50),
population_statistic_preferred FLOAT,
population_statistic_reported VARCHAR(50),
study_accession VARCHAR(15),
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession VARCHAR(15),
workspace_file_info_id INT,
workspace_id INT,
PRIMARY KEY (result_id)
);
CREATE INDEX idx_fcs_analyzed_study_accession ON immport.fcs_analyzed_result(study_accession);
CREATE INDEX idx_fcs_analyzed_arm_accession ON immport.fcs_analyzed_result(arm_accession);
CREATE INDEX idx_fcs_analyzed_biosample_accession ON immport.fcs_analyzed_result(biosample_accession);
CREATE INDEX idx_fcs_analyzed_experiment_accession ON immport.fcs_analyzed_result(experiment_accession);
CREATE INDEX idx_fcs_analyzed_expsample_accession ON immport.fcs_analyzed_result(expsample_accession);
CREATE INDEX idx_fcs_analyzed_subject_accession ON immport.fcs_analyzed_result(subject_accession);
CREATE INDEX idx_fcs_analyzed_workspace ON immport.fcs_analyzed_result(workspace_id);
CREATE TABLE immport.fcs_analyzed_result_marker
(
fcs_analyzed_result_marker_id INT NOT NULL,
population_marker_preferred VARCHAR(500),
population_marker_reported VARCHAR(500),
result_id INT NOT NULL,
PRIMARY KEY (fcs_analyzed_result_marker_id)
);
CREATE TABLE immport.fcs_header
(
fcs_header_id INT NOT NULL,
compensation_flag VARCHAR(1),
expsample_accession VARCHAR(15) NOT NULL,
fcs_file_name VARCHAR(250),
fcs_header_text TEXT,
fcs_version FLOAT,
file_info_id INT NOT NULL,
maximum_intensity FLOAT,
minimum_intensity FLOAT,
number_of_events INT,
number_of_markers INT,
panel_preferred VARCHAR(2000),
panel_reported VARCHAR(2000),
PRIMARY KEY (fcs_header_id)
);
CREATE INDEX idx_fcs_header_expsample_accession ON immport.fcs_header(expsample_accession);
CREATE INDEX idx_fcs_header_file_info_id ON immport.fcs_header(file_info_id);
CREATE TABLE immport.fcs_header_marker
(
fcs_header_id INT NOT NULL,
parameter_number INT NOT NULL,
pnn_preferred VARCHAR(50),
pnn_reported VARCHAR(50),
pns_preferred VARCHAR(50),
pns_reported VARCHAR(50),
PRIMARY KEY (fcs_header_id, parameter_number)
);
CREATE TABLE immport.fcs_header_marker_2_reagent
(
fcs_header_id INT NOT NULL,
parameter_number INT NOT NULL,
reagent_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (fcs_header_id, parameter_number, reagent_accession)
);
CREATE INDEX idx_fcs_header_marker_2_reagent ON immport.fcs_header_marker_2_reagent(reagent_accession,fcs_header_id);
CREATE TABLE immport.file_info
(
file_info_id INT NOT NULL,
detail VARCHAR(100) NOT NULL,
filesize_bytes INT8 NOT NULL,                                     -- CHANGED INT -> INT8
name VARCHAR(250) NOT NULL,
original_file_name VARCHAR(250) NOT NULL,
purpose VARCHAR(100) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (file_info_id)
);
CREATE INDEX idx_file_info_workspace ON immport.file_info(workspace_id);
CREATE TABLE immport.hai_result
(
result_id INT NOT NULL,
arm_accession                        VARCHAR(15) NOT NULL,
biosample_accession                  VARCHAR(15) NOT NULL,
comments VARCHAR(500),
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
study_accession                      VARCHAR(15),
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession                    VARCHAR(15) NOT NULL,
unit_preferred VARCHAR(50),
unit_reported VARCHAR(200),
value_preferred FLOAT,
value_reported VARCHAR(50),
virus_strain_preferred VARCHAR(200),
virus_strain_reported VARCHAR(200),
workspace_id                         INT NOT NULL,
PRIMARY KEY (result_id)
);
CREATE INDEX idx_hai_arm_accession ON immport.hai_result(arm_accession);
CREATE INDEX idx_hai_biosample_accession ON immport.hai_result(biosample_accession);
CREATE INDEX idx_hai_experiment_accession ON immport.hai_result(experiment_accession);
CREATE INDEX idx_hai_expsample_accession ON immport.hai_result(expsample_accession);
CREATE INDEX idx_hai_study_accession ON immport.hai_result(study_accession);
CREATE INDEX idx_hai_subject_accession ON immport.hai_result(subject_accession);
CREATE INDEX idx_hai_workspace ON immport.hai_result(workspace_id);
CREATE TABLE immport.hla_typing_result
(
result_id INT NOT NULL,
allele_1 VARCHAR(250),
allele_2 VARCHAR(250),
ancestral_population VARCHAR(250),
arm_accession                        VARCHAR(15) NOT NULL,
biosample_accession                  VARCHAR(15) NOT NULL,
comments VARCHAR(500),
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
locus_name VARCHAR(25),
result_set_id INT NOT NULL,
study_accession                      VARCHAR(15) NOT NULL,
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession                    VARCHAR(15) NOT NULL,
workspace_id                         INT,
PRIMARY KEY (result_id)
);
CREATE TABLE immport.inclusion_exclusion
(
criterion_accession VARCHAR(15) NOT NULL,
criterion VARCHAR(750),
criterion_category VARCHAR(40),
study_accession VARCHAR(15) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (criterion_accession)
);
CREATE TABLE immport.intervention
(
intervention_accession VARCHAR(15) NOT NULL,
compound_name_reported VARCHAR(250),
compound_role VARCHAR(40) NOT NULL,
dose FLOAT,
dose_freq_per_interval VARCHAR(40),
dose_reported VARCHAR(150),
dose_units VARCHAR(40),
duration FLOAT,
duration_unit VARCHAR(10),
end_day FLOAT,
end_time VARCHAR(40),
formulation VARCHAR(125),
is_ongoing VARCHAR(40),
name_preferred VARCHAR(40),
name_reported VARCHAR(125) NOT NULL,
reported_indication VARCHAR(255),
route_of_admin_preferred VARCHAR(40),
route_of_admin_reported VARCHAR(40),
start_day FLOAT,
start_time VARCHAR(40),
status VARCHAR(40),
study_accession VARCHAR(15) NOT NULL,
subject_accession VARCHAR(15) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (intervention_accession)
);
CREATE INDEX idx_intervention_subject ON immport.intervention(subject_accession);
CREATE INDEX idx_intervention_study ON immport.intervention(study_accession);
CREATE INDEX idx_intervention_workspace ON immport.intervention(workspace_id);
CREATE TABLE immport.kir_typing_result
(
result_id INT NOT NULL,
allele VARCHAR(500),
ancestral_population VARCHAR(250) NOT NULL,
arm_accession                        VARCHAR(15) NOT NULL,
biosample_accession                  VARCHAR(15) NOT NULL,
comments VARCHAR(500),
copy_number INT,
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
gene_name VARCHAR(25) NOT NULL,
present_absent VARCHAR(10),
result_set_id INT NOT NULL,
study_accession                      VARCHAR(15) NOT NULL,
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession                    VARCHAR(15) NOT NULL,
workspace_id                         INT,
PRIMARY KEY (result_id)
);
CREATE INDEX idx_kir_arm_accession ON immport.kir_typing_result(arm_accession);
CREATE INDEX idx_kir_biosample_accession ON immport.kir_typing_result(biosample_accession);
CREATE INDEX idx_kir_experiment_accession ON immport.kir_typing_result(experiment_accession);
CREATE INDEX idx_kir_expsample_accession ON immport.kir_typing_result(expsample_accession);
CREATE INDEX idx_kir_subject_accession ON immport.kir_typing_result(subject_accession);
CREATE INDEX idx_kir_study_accession ON immport.kir_typing_result(study_accession);
CREATE INDEX idx_kir_workspace ON immport.kir_typing_result(workspace_id);
CREATE TABLE immport.lab_test
(
lab_test_accession VARCHAR(15) NOT NULL,
biosample_accession VARCHAR(15),
lab_test_panel_accession VARCHAR(15) NOT NULL,
name_preferred VARCHAR(40),
name_reported VARCHAR(125),
reference_range_accession VARCHAR(15),
result_unit_preferred VARCHAR(40),
result_unit_reported VARCHAR(40),
result_value_preferred FLOAT,
result_value_reported VARCHAR(250),
workspace_id INT NOT NULL,
PRIMARY KEY (lab_test_accession)
);
CREATE INDEX idx_lab_test_biosample ON immport.lab_test(biosample_accession);
CREATE INDEX idx_lab_test_workspace ON immport.lab_test(workspace_id);
CREATE TABLE immport.lab_test_panel
(
lab_test_panel_accession VARCHAR(15) NOT NULL,
name_preferred VARCHAR(125),
name_reported VARCHAR(125),
study_accession VARCHAR(15),
workspace_id INT NOT NULL,
PRIMARY KEY (lab_test_panel_accession)
);
CREATE INDEX idx_lab_test_panel_study ON immport.lab_test_panel(study_accession);
CREATE TABLE immport.lab_test_panel_2_protocol
(
lab_test_panel_accession VARCHAR(15) NOT NULL,
protocol_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (lab_test_panel_accession, protocol_accession)
);
CREATE INDEX idx_lab_test_2_protocol ON immport.lab_test_panel_2_protocol(protocol_accession,lab_test_panel_accession);
CREATE TABLE immport.lk_adverse_event_severity
(
name VARCHAR(60) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_age_event
(
name VARCHAR(40) NOT NULL,
description VARCHAR(1000) NOT NULL,
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_analyte
(
analyte_accession VARCHAR(15) NOT NULL,
analyte_preferred VARCHAR(100),
cluster_subunit_gene_ids VARCHAR(1000),
cluster_subunit_gene_symbols VARCHAR(1000),
cluster_subunit_uniprot_ids VARCHAR(1000),
cluster_subunit_uniprot_names TEXT,
gene_additional_names TEXT,
gene_aliases TEXT,
gene_id VARCHAR(10),
genetic_nomenclature_id VARCHAR(15),
immunology_gene_symbol VARCHAR(100),
ix_synonyms TEXT,
link VARCHAR(2000),
mesh_id VARCHAR(10),
mesh_name VARCHAR(255),
official_gene_name VARCHAR(255),
omim_id VARCHAR(50),
ortholog_ids VARCHAR(100),
protein_ontology_id VARCHAR(15),
protein_ontology_name VARCHAR(100),
protein_ontology_synonyms TEXT,
protein_ontology_url VARCHAR(500),
shen_orr_id VARCHAR(10),
taxonomy_id VARCHAR(10),
typographical_variations VARCHAR(1000),
uniprot_alt_prot_names TEXT,
uniprot_id VARCHAR(20),
uniprot_protein_name VARCHAR(255),
unique_id VARCHAR(10),
PRIMARY KEY (analyte_accession)
);
CREATE TABLE immport.lk_ancestral_population
(
name VARCHAR(30) NOT NULL,
abbreviation VARCHAR(3),
description VARCHAR(4000) NOT NULL,
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_cell_population
(
name VARCHAR(150) NOT NULL,
comments VARCHAR(500),
definition VARCHAR(150),
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_compound_role
(
name VARCHAR(40) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_criterion_category
(
name VARCHAR(40) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_data_completeness
(
id INT NOT NULL,
description VARCHAR(1000),
PRIMARY KEY (id)
);
CREATE TABLE immport.lk_data_format
(
name VARCHAR(100) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_ethnicity
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_exp_measurement_tech
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_experiment_purpose
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_expsample_result_schema
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
table_name VARCHAR(30) NOT NULL DEFAULT 'NONE',
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_file_detail
(
name VARCHAR(100) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_file_purpose
(
name VARCHAR(100) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_gender
(
name VARCHAR(20) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_kir_gene
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_kir_locus
(
name VARCHAR(50) NOT NULL,
description VARCHAR(250),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_kir_present_absent
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_lab_test_name
(
name VARCHAR(50) NOT NULL,
cdisc_lab_test_code VARCHAR(50),
description VARCHAR(1000),
lab_test_panel_name VARCHAR(50),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_lab_test_panel_name
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_locus_name
(
name VARCHAR(100) NOT NULL,
description VARCHAR(250),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_organization
(
name VARCHAR(125) NOT NULL,
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_personnel_role
(
name VARCHAR(40) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_plate_type
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_protocol_type
(
name VARCHAR(100) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_public_repository
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),                           -- CHANGED FROM VARCHAR(100) in original DDL
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_race
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_reagent_type
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_research_focus
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_sample_type
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_source_type
(
name VARCHAR(30) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_species
(
name VARCHAR(30) NOT NULL,
common_name VARCHAR(100),
link VARCHAR(2000),
taxonomy_id VARCHAR(10) NOT NULL,
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_study_file_type
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_study_panel
(
name VARCHAR(100) NOT NULL,
collapsible VARCHAR(1),
description VARCHAR(1000),
display_name VARCHAR(100),
sort_order INT,
visible VARCHAR(1),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_study_type
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_t0_event
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000) NOT NULL,
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_time_unit
(
name VARCHAR(25) NOT NULL,
description VARCHAR(1000) NOT NULL,
link VARCHAR(2000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_unit_of_measure
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
link VARCHAR(2000),
type VARCHAR(50) NOT NULL,
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_user_role_type
(
name VARCHAR(2) NOT NULL,
description VARCHAR(1000),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_virus_strain
(
name VARCHAR(200) NOT NULL,
center_id_name_season_list VARCHAR(500),
description VARCHAR(1000),
link VARCHAR(2000),
season_list VARCHAR(100),
taxonomy_id INT,
virus_name VARCHAR(10),
PRIMARY KEY (name)
);
CREATE TABLE immport.lk_visibility_category
(
name VARCHAR(50) NOT NULL,
description VARCHAR(1000),
PRIMARY KEY (name)
);
CREATE TABLE immport.mbaa_result
(
result_id INT NOT NULL,
analyte_preferred VARCHAR(100),
analyte_reported VARCHAR(100),
arm_accession                        VARCHAR(15),
assay_group_id VARCHAR(100),
assay_id VARCHAR(100),
biosample_accession                  VARCHAR(15),
comments VARCHAR(500),
concentration_unit VARCHAR(100),
concentration_value VARCHAR(100),
experiment_accession                 VARCHAR(15) NOT NULL,
mfi VARCHAR(100),
mfi_coordinate VARCHAR(100),
source_accession VARCHAR(15) NOT NULL,
source_type VARCHAR(30) NOT NULL,
study_accession                      VARCHAR(15),
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession                    VARCHAR(15),
workspace_id                         INT NOT NULL,
PRIMARY KEY (result_id)
);
CREATE INDEX idx_mbaa_arm_accession ON immport.mbaa_result(arm_accession);
CREATE INDEX idx_mbaa_biosample_accession ON immport.mbaa_result(biosample_accession);
CREATE INDEX idx_mbaa_experiment_accession ON immport.mbaa_result(experiment_accession);
CREATE INDEX idx_mbaa_source_accession ON immport.mbaa_result(source_accession);
CREATE INDEX idx_mbaa_study_accession ON immport.mbaa_result(study_accession);
CREATE INDEX idx_mbaa_subject_accession ON immport.mbaa_result(subject_accession);
CREATE INDEX idx_mbaa_workspace ON immport.mbaa_result(workspace_id);
CREATE TABLE immport.neut_ab_titer_result
(
result_id INT NOT NULL,
arm_accession                        VARCHAR(15) NOT NULL,
biosample_accession                  VARCHAR(15) NOT NULL,
comments VARCHAR(500),
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
study_accession                      VARCHAR(15),
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession                    VARCHAR(15) NOT NULL,
unit_preferred VARCHAR(50),
unit_reported VARCHAR(200),
value_preferred FLOAT,
value_reported VARCHAR(50),
virus_strain_preferred VARCHAR(200),
virus_strain_reported VARCHAR(200),
workspace_id                         INT,
PRIMARY KEY (result_id)
);
CREATE INDEX idx_neut_arm_accession ON immport.neut_ab_titer_result(arm_accession);
CREATE INDEX idx_neut_biosample_accession ON immport.neut_ab_titer_result(biosample_accession);
CREATE INDEX idx_neut_experiment_accession ON immport.neut_ab_titer_result(experiment_accession);
CREATE INDEX idx_neut_expsample_accession ON immport.neut_ab_titer_result(expsample_accession);
CREATE INDEX idx_neut_study_accession ON immport.neut_ab_titer_result(study_accession);
CREATE INDEX idx_neut_subject_accession ON immport.neut_ab_titer_result(subject_accession);
CREATE INDEX idx__workspace ON immport.neut_ab_titer_result(workspace_id);
CREATE TABLE immport.pcr_result
(
result_id INT NOT NULL,
arm_accession                        VARCHAR(15) NOT NULL,
biosample_accession                  VARCHAR(15) NOT NULL,
comments VARCHAR(500),
experiment_accession VARCHAR(15) NOT NULL,
expsample_accession VARCHAR(15) NOT NULL,
gene_id VARCHAR(10),
gene_name VARCHAR(4000),
gene_symbol VARCHAR(100),
other_gene_accession VARCHAR(250),
study_accession                      VARCHAR(15) NOT NULL,
study_time_collected                 FLOAT,
study_time_collected_unit            VARCHAR(25),
subject_accession                    VARCHAR(15) NOT NULL,
unit_preferred VARCHAR(200),
unit_reported VARCHAR(200),
value_preferred FLOAT,
value_reported VARCHAR(50),
workspace_id                         INT NOT NULL,
PRIMARY KEY (result_id)
);
CREATE TABLE immport.performance_metrics
(
performance_metrics_id INT NOT NULL,
class_name VARCHAR(250),
duration FLOAT,
end_time DATE,
ip_address VARCHAR(500),
method_name VARCHAR(250),
parameter_values VARCHAR(4000),
parameters VARCHAR(4000),
session_id VARCHAR(250),
start_time DATE,
username VARCHAR(12) NOT NULL,
PRIMARY KEY (performance_metrics_id)
);
CREATE TABLE immport.period
(
period_accession VARCHAR(15) NOT NULL,
name VARCHAR(250),
order_number INT,
study_accession VARCHAR(15),
workspace_id INT NOT NULL,
PRIMARY KEY (period_accession)
);
CREATE INDEX idx_period_study ON immport.period(study_accession);
CREATE INDEX idx_period_workspace ON immport.period(workspace_id);
CREATE TABLE immport.personnel
(
personnel_id INT NOT NULL,
email VARCHAR(100),
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
organization VARCHAR(125) NOT NULL,
PRIMARY KEY (personnel_id)
);
CREATE TABLE immport.planned_visit
(
planned_visit_accession VARCHAR(15) NOT NULL,
end_rule VARCHAR(256),
max_start_day FLOAT,
min_start_day FLOAT,
name VARCHAR(125),
order_number INT NOT NULL,
period_accession VARCHAR(15),
start_rule VARCHAR(256),
study_accession VARCHAR(15),
workspace_id INT NOT NULL,
PRIMARY KEY (planned_visit_accession)
);
CREATE INDEX idx_planned_visit_workspace ON immport.planned_visit(workspace_id);
CREATE INDEX idx_planned_visit_period ON immport.planned_visit(period_accession);
CREATE TABLE immport.planned_visit_2_arm
(
planned_visit_accession VARCHAR(15) NOT NULL,
arm_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (planned_visit_accession, arm_accession)
);
CREATE TABLE immport.program
(
program_id INT NOT NULL,
category VARCHAR(50) NOT NULL,
description VARCHAR(4000),
end_date DATE,
link VARCHAR(2000),
name VARCHAR(200) NOT NULL,
start_date DATE,
PRIMARY KEY (program_id)
);
CREATE TABLE immport.program_2_personnel
(
program_id INT NOT NULL,
personnel_id INT NOT NULL,
role_type VARCHAR(12),
PRIMARY KEY (program_id,personnel_id)
);
CREATE INDEX idx_program_2_personnel ON immport.program_2_personnel(personnel_id,program_id);
CREATE TABLE immport.protocol
(
protocol_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000),
file_name VARCHAR(250) NOT NULL,
name VARCHAR(250) NOT NULL,
original_file_name VARCHAR(250) NOT NULL,
type VARCHAR(100) NOT NULL DEFAULT 'Not Specified',
workspace_id INT NOT NULL,
PRIMARY KEY (protocol_accession)
);
CREATE TABLE immport.protocol_deviation
(
protocol_deviation_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000) NOT NULL,
is_adverse_event_related VARCHAR(1),
reason_for_deviation VARCHAR(250),
resolution_of_deviation VARCHAR(500),
study_accession VARCHAR(15),
study_end_day INT,
study_start_day INT NOT NULL,
subject_accession VARCHAR(15),
subject_continued_study VARCHAR(1),
workspace_id INT NOT NULL,
PRIMARY KEY (protocol_deviation_accession)
);
CREATE INDEX idx_procotol_deviation_study ON immport.protocol_deviation(study_accession);
CREATE INDEX idx_procotol_deviation_subject ON immport.protocol_deviation(subject_accession);
CREATE INDEX idx_procotol_deviation_workspace ON immport.protocol_deviation(workspace_id);
CREATE TABLE immport.reagent
(
reagent_accession VARCHAR(15) NOT NULL,
analyte_preferred VARCHAR(200),
analyte_reported VARCHAR(200),
antibody_registry_id VARCHAR(250),
catalog_number VARCHAR(250),
clone_name VARCHAR(200),
contact VARCHAR(1000),
description VARCHAR(4000),
is_set VARCHAR(1) DEFAULT 'N',
lot_number VARCHAR(250),
manufacturer VARCHAR(100),
name VARCHAR(200),
reporter_name VARCHAR(200),
type VARCHAR(50),
weblink VARCHAR(250),
workspace_id INT NOT NULL,
PRIMARY KEY (reagent_accession)
);
CREATE INDEX idx_reagent_workspace ON immport.reagent(workspace_id);
CREATE TABLE immport.reagent_set_2_reagent
(
reagent_set_accession VARCHAR(15) NOT NULL,
reagent_accession VARCHAR(15) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (reagent_set_accession, reagent_accession)
);
CREATE INDEX idx_reagent_set_reagent ON immport.reagent_set_2_reagent(reagent_accession,reagent_set_accession);
CREATE INDEX idx_reagent_set_workspace ON immport.reagent_set_2_reagent(workspace_id);
CREATE TABLE immport.reference_range
(
reference_range_accession VARCHAR(15) NOT NULL,
age_range VARCHAR(40),
category VARCHAR(40),
gender VARCHAR(40),
lab_or_study_source VARCHAR(256),
lower_limit VARCHAR(40) NOT NULL,
study_accession VARCHAR(15),
subject_condition VARCHAR(40),
test_or_assessment_name VARCHAR(125),
unit_of_measure VARCHAR(40) NOT NULL,
upper_limit VARCHAR(40) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (reference_range_accession)
);
CREATE INDEX idx_reference_range_study ON immport.reference_range(study_accession);
CREATE INDEX idx_reference_range_workspace ON immport.reference_range(workspace_id);
CREATE TABLE immport.reported_early_termination
(
early_termination_accession VARCHAR(15) NOT NULL,
is_adverse_event_related VARCHAR(1),
is_subject_requested VARCHAR(1),
reason_preferred VARCHAR(40),
reason_reported VARCHAR(250),
study_accession VARCHAR(15),
study_day_reported INT,
subject_accession VARCHAR(15),
workspace_id INT NOT NULL,
PRIMARY KEY (early_termination_accession)
);
CREATE INDEX idx_early_termination_study ON immport.reported_early_termination(study_accession);
CREATE INDEX idx_early_termination_subject ON immport.reported_early_termination(subject_accession);
CREATE INDEX idx_early_termination_workspace ON immport.reported_early_termination(workspace_id);
CREATE TABLE immport.standard_curve
(
standard_curve_accession VARCHAR(15) NOT NULL,
analyte_preferred VARCHAR(100),
analyte_reported VARCHAR(100),
assay_group_id VARCHAR(100),
assay_id VARCHAR(100),
experiment_accession VARCHAR(15) NOT NULL,
formula VARCHAR(500),
lower_limit VARCHAR(100),
lower_limit_unit VARCHAR(100),
result_schema VARCHAR(50) NOT NULL DEFAULT 'OTHER',
upload_result_status VARCHAR(20),
upper_limit VARCHAR(100),
upper_limit_unit VARCHAR(100),
workspace_id INT NOT NULL,
PRIMARY KEY (standard_curve_accession)
);
CREATE TABLE immport.standard_curve_2_file_info
(
standard_curve_accession VARCHAR(15) NOT NULL,
file_info_id INT NOT NULL,
data_format VARCHAR(100) NOT NULL,
result_schema VARCHAR(50) NOT NULL,
PRIMARY KEY (standard_curve_accession, file_info_id)
);
CREATE TABLE immport.study
(
study_accession VARCHAR(15) NOT NULL,
actual_completion_date DATE,
actual_enrollment INT,
actual_start_date DATE,
age_unit VARCHAR(40),
brief_description VARCHAR(4000),
brief_title VARCHAR(250),
clinical_trial VARCHAR(1) NOT NULL DEFAULT 'N',
condition_studied VARCHAR(1000),
dcl_id INT NOT NULL DEFAULT 0,
delete_study VARCHAR(1) DEFAULT 'N',
description TEXT,
doi VARCHAR(250),
download_page_available VARCHAR(1) DEFAULT 'N',
endpoints TEXT,
final_public_release_date DATE,
gender_included VARCHAR(50),
hypothesis VARCHAR(4000),
initial_data_release_date DATE,
initial_data_release_version VARCHAR(10),
intervention_agent VARCHAR(1000),
latest_data_release_date DATE,
latest_data_release_version VARCHAR(10),
maximum_age VARCHAR(40),
minimum_age VARCHAR(40),
objectives TEXT,
official_title VARCHAR(500),
planned_public_release_date DATE,
shared_study VARCHAR(1) NOT NULL DEFAULT 'N',
sponsoring_organization VARCHAR(250),
target_enrollment INT,
type VARCHAR(50) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (study_accession)
);
CREATE INDEX idx_study_type ON immport.study(type);
CREATE INDEX idx_study_workspace ON immport.study(workspace_id);
CREATE TABLE immport.study_2_panel
(
study_accession VARCHAR(15) NOT NULL,
panel_name VARCHAR(100) NOT NULL,
PRIMARY KEY (study_accession, panel_name)
);
CREATE TABLE immport.study_2_protocol
(
study_accession VARCHAR(15) NOT NULL,
protocol_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (study_accession, protocol_accession)
);
CREATE TABLE immport.study_categorization
(
study_categorization_id INT NOT NULL,
research_focus VARCHAR(50) NOT NULL,
study_accession VARCHAR(15) NOT NULL,
PRIMARY KEY (study_categorization_id)
);
CREATE TABLE immport.study_file
(
study_file_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000) NOT NULL,
file_name VARCHAR(250) NOT NULL,
study_accession VARCHAR(15) NOT NULL,
study_file_type VARCHAR(50) NOT NULL DEFAULT 'Study Summary Description',
workspace_id INT NOT NULL,
PRIMARY KEY (study_file_accession)
);
CREATE INDEX idx_study_file_study ON immport.study_file(study_accession);
CREATE INDEX idx_study_file_type ON immport.study_file(study_file_type);
CREATE INDEX idx_study_file_workspace ON immport.study_file(workspace_id);
CREATE TABLE immport.study_glossary
(
study_accession VARCHAR(15) NOT NULL,
definition VARCHAR(500) NOT NULL,
term VARCHAR(125) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (study_accession, term)
);
CREATE INDEX idx_study_glossaryworkspace ON immport.study_glossary(workspace_id);
CREATE TABLE immport.study_image
(
schematic_accession VARCHAR(15) NOT NULL,
description VARCHAR(4000),
image_filename VARCHAR(250),
image_map_filename VARCHAR(250),
image_type VARCHAR(40),
name VARCHAR(40),
study_accession VARCHAR(15) NOT NULL,
workspace_id INT NOT NULL,
PRIMARY KEY (schematic_accession)
);
CREATE INDEX idx_study_image_study ON immport.study_image(study_accession);
CREATE INDEX idx_study_image_workspace ON immport.study_image(workspace_id);
CREATE TABLE immport.study_link
(
study_link_id INT NOT NULL,
name VARCHAR(500),
study_accession VARCHAR(15) NOT NULL,
type VARCHAR(50),
value VARCHAR(2000),
workspace_id INT NOT NULL,
PRIMARY KEY (study_link_id)
);
CREATE TABLE immport.study_personnel
(
person_accession VARCHAR(15) NOT NULL,
site_name VARCHAR(100) NULL,                -- CHANGED FROM "NOT NULL" to "NULL"
email VARCHAR(40),
first_name VARCHAR(40),
honorific VARCHAR(20),
last_name VARCHAR(40),
organization VARCHAR(125),
role_in_study VARCHAR(40),
study_accession VARCHAR(15) NOT NULL,
suffixes VARCHAR(40),
title_in_study VARCHAR(100),
workspace_id INT NOT NULL,
PRIMARY KEY (person_accession)
);
CREATE TABLE immport.study_pubmed
(
study_accession VARCHAR(15) NOT NULL,
pubmed_id VARCHAR(16) NOT NULL,
authors VARCHAR(4000),
doi VARCHAR(100),
issue VARCHAR(20),
journal VARCHAR(250),
month VARCHAR(12),
pages VARCHAR(20),
title VARCHAR(4000),
workspace_id INT NOT NULL,
year VARCHAR(4),
PRIMARY KEY (study_accession, pubmed_id)
);
CREATE TABLE immport.subject
(
subject_accession VARCHAR(15) NOT NULL,
ancestral_population VARCHAR(100),
description VARCHAR(4000),
ethnicity VARCHAR(50) DEFAULT 'Not Specified',
gender VARCHAR(20) NOT NULL DEFAULT 'Not Specified',
race VARCHAR(50) DEFAULT 'Not Specified',
race_specify VARCHAR(1000),
species VARCHAR(50) NOT NULL,
strain VARCHAR(50),
strain_characteristics VARCHAR(500),
workspace_id INT NOT NULL,
PRIMARY KEY (subject_accession)
);
CREATE INDEX idx_subject_gender ON immport.subject(gender);
CREATE INDEX idx_subject_race ON immport.subject(race);
CREATE INDEX idx_subject_species ON immport.subject(species);
CREATE INDEX idx_subject_workspace ON immport.subject(workspace_id);
CREATE TABLE immport.subject_measure_definition
(
subject_measure_accession VARCHAR(15) NOT NULL,
algorithm VARCHAR(1024),
description VARCHAR(4000),
measureofcentraltendency VARCHAR(40),
measureofdispersion VARCHAR(40),
measuretype VARCHAR(40),
name VARCHAR(125),
outcometype VARCHAR(70),
study_accession VARCHAR(15),
timeframe VARCHAR(256),
unitofmeasure VARCHAR(40),
workspace_id INT NOT NULL,
PRIMARY KEY (subject_measure_accession)
);
CREATE INDEX idx_subject_measure_study ON immport.subject_measure_definition(study_accession);
CREATE INDEX idx_subject_measure_workspace ON immport.subject_measure_definition(workspace_id);
CREATE TABLE immport.subject_measure_result
(
subject_measure_res_accession VARCHAR(15) NOT NULL,
centraltendencymeasurevalue VARCHAR(40),
datavalue VARCHAR(40),
dispersionmeasurevalue VARCHAR(40),
study_accession VARCHAR(15),
study_day FLOAT,
subject_accession VARCHAR(15) NOT NULL,
subject_measure_accession VARCHAR(15) NOT NULL,
time_of_day VARCHAR(40),
workspace_id INT NOT NULL,
year_of_measure DATE,
PRIMARY KEY (subject_measure_res_accession)
);
CREATE INDEX idx_subject_measure_result_study ON immport.subject_measure_result(study_accession);
CREATE INDEX idx_subject_measure_result_subject ON immport.subject_measure_result(subject_accession);
CREATE INDEX idx_subject_measure_result_workspace ON immport.subject_measure_result(workspace_id);
CREATE TABLE immport.treatment
(
treatment_accession VARCHAR(15) NOT NULL,
amount_unit VARCHAR(50) DEFAULT 'Not Specified',
amount_value VARCHAR(50) DEFAULT 'Not Specified',
comments VARCHAR(500),
duration_unit VARCHAR(50) DEFAULT 'Not Specified',
duration_value VARCHAR(200) DEFAULT 'Not Specified',
name VARCHAR(100),
temperature_unit VARCHAR(50) DEFAULT 'Not Specified',
temperature_value VARCHAR(50) DEFAULT 'Not Specified',
workspace_id INT NOT NULL,
PRIMARY KEY (treatment_accession)
);
CREATE INDEX idx_treatment_workspace ON immport.treatment(workspace_id);
CREATE TABLE immport.workspace
(
workspace_id INT NOT NULL,
category VARCHAR(50) NOT NULL,
name VARCHAR(125) NOT NULL,
type VARCHAR(20) NOT NULL,
PRIMARY KEY (workspace_id)
);
