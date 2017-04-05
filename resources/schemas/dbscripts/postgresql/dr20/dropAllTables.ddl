
system echo 'Dropping Table: adverse_event'
DROP TABLE IF EXISTS adverse_event;

system echo 'Dropping Table: arm_2_subject'
DROP TABLE IF EXISTS arm_2_subject;

system echo 'Dropping Table: arm_or_cohort'
DROP TABLE IF EXISTS arm_or_cohort;

system echo 'Dropping Table: assessment_2_file_info'
DROP TABLE IF EXISTS assessment_2_file_info;

system echo 'Dropping Table: assessment_component'
DROP TABLE IF EXISTS assessment_component;

system echo 'Dropping Table: assessment_panel'
DROP TABLE IF EXISTS assessment_panel;

system echo 'Dropping Table: biosample'
DROP TABLE IF EXISTS biosample;

system echo 'Dropping Table: biosample_2_treatment'
DROP TABLE IF EXISTS biosample_2_treatment;

system echo 'Dropping Table: contract_grant'
DROP TABLE IF EXISTS contract_grant;

system echo 'Dropping Table: contract_grant_2_study'
DROP TABLE IF EXISTS contract_grant_2_study;

system echo 'Dropping Table: control_sample'
DROP TABLE IF EXISTS control_sample;

system echo 'Dropping Table: control_sample_2_file_info'
DROP TABLE IF EXISTS control_sample_2_file_info;

system echo 'Dropping Table: elisa_result'
DROP TABLE IF EXISTS elisa_result;

system echo 'Dropping Table: elispot_result'
DROP TABLE IF EXISTS elispot_result;

system echo 'Dropping Table: experiment'
DROP TABLE IF EXISTS experiment;

system echo 'Dropping Table: experiment_2_protocol'
DROP TABLE IF EXISTS experiment_2_protocol;

system echo 'Dropping Table: expsample'
DROP TABLE IF EXISTS expsample;

system echo 'Dropping Table: expsample_2_biosample'
DROP TABLE IF EXISTS expsample_2_biosample;

system echo 'Dropping Table: expsample_2_file_info'
DROP TABLE IF EXISTS expsample_2_file_info;

system echo 'Dropping Table: expsample_2_reagent'
DROP TABLE IF EXISTS expsample_2_reagent;

system echo 'Dropping Table: expsample_2_treatment'
DROP TABLE IF EXISTS expsample_2_treatment;

system echo 'Dropping Table: expsample_mbaa_detail'
DROP TABLE IF EXISTS expsample_mbaa_detail;

system echo 'Dropping Table: expsample_public_repository'
DROP TABLE IF EXISTS expsample_public_repository;

system echo 'Dropping Table: fcs_analyzed_result'
DROP TABLE IF EXISTS fcs_analyzed_result;

system echo 'Dropping Table: fcs_analyzed_result_marker'
DROP TABLE IF EXISTS fcs_analyzed_result_marker;

system echo 'Dropping Table: fcs_header'
DROP TABLE IF EXISTS fcs_header;

system echo 'Dropping Table: fcs_header_marker'
DROP TABLE IF EXISTS fcs_header_marker;

system echo 'Dropping Table: file_info'
DROP TABLE IF EXISTS file_info;

system echo 'Dropping Table: hai_result'
DROP TABLE IF EXISTS hai_result;

system echo 'Dropping Table: hla_typing_result'
DROP TABLE IF EXISTS hla_typing_result;

system echo 'Dropping Table: inclusion_exclusion'
DROP TABLE IF EXISTS inclusion_exclusion;

system echo 'Dropping Table: intervention'
DROP TABLE IF EXISTS intervention;

system echo 'Dropping Table: kir_typing_result'
DROP TABLE IF EXISTS kir_typing_result;

system echo 'Dropping Table: lab_test'
DROP TABLE IF EXISTS lab_test;

system echo 'Dropping Table: lab_test_panel'
DROP TABLE IF EXISTS lab_test_panel;

system echo 'Dropping Table: lab_test_panel_2_protocol'
DROP TABLE IF EXISTS lab_test_panel_2_protocol;

system echo 'Dropping Table: lk_adverse_event_severity'
DROP TABLE IF EXISTS lk_adverse_event_severity;

system echo 'Dropping Table: lk_age_event'
DROP TABLE IF EXISTS lk_age_event;

system echo 'Dropping Table: lk_analyte'
DROP TABLE IF EXISTS lk_analyte;

system echo 'Dropping Table: lk_ancestral_population'
DROP TABLE IF EXISTS lk_ancestral_population;

system echo 'Dropping Table: lk_cell_population'
DROP TABLE IF EXISTS lk_cell_population;

system echo 'Dropping Table: lk_compound_role'
DROP TABLE IF EXISTS lk_compound_role;

system echo 'Dropping Table: lk_criterion_category'
DROP TABLE IF EXISTS lk_criterion_category;

system echo 'Dropping Table: lk_data_completeness'
DROP TABLE IF EXISTS lk_data_completeness;

system echo 'Dropping Table: lk_data_format'
DROP TABLE IF EXISTS lk_data_format;

system echo 'Dropping Table: lk_ethnicity'
DROP TABLE IF EXISTS lk_ethnicity;

system echo 'Dropping Table: lk_exp_measurement_tech'
DROP TABLE IF EXISTS lk_exp_measurement_tech;

system echo 'Dropping Table: lk_experiment_purpose'
DROP TABLE IF EXISTS lk_experiment_purpose;

system echo 'Dropping Table: lk_expsample_result_schema'
DROP TABLE IF EXISTS lk_expsample_result_schema;

system echo 'Dropping Table: lk_file_detail'
DROP TABLE IF EXISTS lk_file_detail;

system echo 'Dropping Table: lk_file_purpose'
DROP TABLE IF EXISTS lk_file_purpose;

system echo 'Dropping Table: lk_gender'
DROP TABLE IF EXISTS lk_gender;

system echo 'Dropping Table: lk_kir_gene'
DROP TABLE IF EXISTS lk_kir_gene;

system echo 'Dropping Table: lk_kir_locus'
DROP TABLE IF EXISTS lk_kir_locus;

system echo 'Dropping Table: lk_kir_present_absent'
DROP TABLE IF EXISTS lk_kir_present_absent;

system echo 'Dropping Table: lk_lab_test_name'
DROP TABLE IF EXISTS lk_lab_test_name;

system echo 'Dropping Table: lk_lab_test_panel_name'
DROP TABLE IF EXISTS lk_lab_test_panel_name;

system echo 'Dropping Table: lk_locus_name'
DROP TABLE IF EXISTS lk_locus_name;

system echo 'Dropping Table: lk_organization'
DROP TABLE IF EXISTS lk_organization;

system echo 'Dropping Table: lk_personnel_role'
DROP TABLE IF EXISTS lk_personnel_role;

system echo 'Dropping Table: lk_plate_type'
DROP TABLE IF EXISTS lk_plate_type;

system echo 'Dropping Table: lk_protocol_type'
DROP TABLE IF EXISTS lk_protocol_type;

system echo 'Dropping Table: lk_public_repository'
DROP TABLE IF EXISTS lk_public_repository;

system echo 'Dropping Table: lk_race'
DROP TABLE IF EXISTS lk_race;

system echo 'Dropping Table: lk_reagent_type'
DROP TABLE IF EXISTS lk_reagent_type;

system echo 'Dropping Table: lk_research_focus'
DROP TABLE IF EXISTS lk_research_focus;

system echo 'Dropping Table: lk_sample_type'
DROP TABLE IF EXISTS lk_sample_type;

system echo 'Dropping Table: lk_source_type'
DROP TABLE IF EXISTS lk_source_type;

system echo 'Dropping Table: lk_species'
DROP TABLE IF EXISTS lk_species;

system echo 'Dropping Table: lk_study_file_type'
DROP TABLE IF EXISTS lk_study_file_type;

system echo 'Dropping Table: lk_study_panel'
DROP TABLE IF EXISTS lk_study_panel;

system echo 'Dropping Table: lk_study_type'
DROP TABLE IF EXISTS lk_study_type;

system echo 'Dropping Table: lk_t0_event'
DROP TABLE IF EXISTS lk_t0_event;

system echo 'Dropping Table: lk_template_mapping'
DROP TABLE IF EXISTS lk_template_mapping;

system echo 'Dropping Table: lk_time_unit'
DROP TABLE IF EXISTS lk_time_unit;

system echo 'Dropping Table: lk_unit_of_measure'
DROP TABLE IF EXISTS lk_unit_of_measure;

system echo 'Dropping Table: lk_upload_method'
DROP TABLE IF EXISTS lk_upload_method;

system echo 'Dropping Table: lk_upload_status'
DROP TABLE IF EXISTS lk_upload_status;

system echo 'Dropping Table: lk_user_role_type'
DROP TABLE IF EXISTS lk_user_role_type;

system echo 'Dropping Table: lk_virus_strain'
DROP TABLE IF EXISTS lk_virus_strain;

system echo 'Dropping Table: lk_visibility_category'
DROP TABLE IF EXISTS lk_visibility_category;

system echo 'Dropping Table: lk_workspace_type'
DROP TABLE IF EXISTS lk_workspace_type;

system echo 'Dropping Table: mbaa_result'
DROP TABLE IF EXISTS mbaa_result;

system echo 'Dropping Table: neut_ab_titer_result'
DROP TABLE IF EXISTS neut_ab_titer_result;

system echo 'Dropping Table: pcr_result'
DROP TABLE IF EXISTS pcr_result;

system echo 'Dropping Table: performance_metrics'
DROP TABLE IF EXISTS performance_metrics;

system echo 'Dropping Table: period'
DROP TABLE IF EXISTS period;

system echo 'Dropping Table: personnel'
DROP TABLE IF EXISTS personnel;

system echo 'Dropping Table: planned_visit'
DROP TABLE IF EXISTS planned_visit;

system echo 'Dropping Table: planned_visit_2_arm'
DROP TABLE IF EXISTS planned_visit_2_arm;

system echo 'Dropping Table: program'
DROP TABLE IF EXISTS program;

system echo 'Dropping Table: protocol'
DROP TABLE IF EXISTS protocol;

system echo 'Dropping Table: protocol_deviation'
DROP TABLE IF EXISTS protocol_deviation;

system echo 'Dropping Table: reagent'
DROP TABLE IF EXISTS reagent;

system echo 'Dropping Table: reagent_2_fcs_marker'
DROP TABLE IF EXISTS reagent_2_fcs_marker;

system echo 'Dropping Table: reagent_set_2_reagent'
DROP TABLE IF EXISTS reagent_set_2_reagent;

system echo 'Dropping Table: reference_range'
DROP TABLE IF EXISTS reference_range;

system echo 'Dropping Table: reported_early_termination'
DROP TABLE IF EXISTS reported_early_termination;

system echo 'Dropping Table: standard_curve'
DROP TABLE IF EXISTS standard_curve;

system echo 'Dropping Table: standard_curve_2_file_info'
DROP TABLE IF EXISTS standard_curve_2_file_info;

system echo 'Dropping Table: study'
DROP TABLE IF EXISTS study;

system echo 'Dropping Table: study_2_panel'
DROP TABLE IF EXISTS study_2_panel;

system echo 'Dropping Table: study_2_protocol'
DROP TABLE IF EXISTS study_2_protocol;

system echo 'Dropping Table: study_categorization'
DROP TABLE IF EXISTS study_categorization;

system echo 'Dropping Table: study_file'
DROP TABLE IF EXISTS study_file;

system echo 'Dropping Table: study_glossary'
DROP TABLE IF EXISTS study_glossary;

system echo 'Dropping Table: study_image'
DROP TABLE IF EXISTS study_image;

system echo 'Dropping Table: study_link'
DROP TABLE IF EXISTS study_link;

system echo 'Dropping Table: study_personnel'
DROP TABLE IF EXISTS study_personnel;

system echo 'Dropping Table: study_pubmed'
DROP TABLE IF EXISTS study_pubmed;

system echo 'Dropping Table: subject'
DROP TABLE IF EXISTS subject;

system echo 'Dropping Table: subject_measure_definition'
DROP TABLE IF EXISTS subject_measure_definition;

system echo 'Dropping Table: subject_measure_result'
DROP TABLE IF EXISTS subject_measure_result;

system echo 'Dropping Table: treatment'
DROP TABLE IF EXISTS treatment;

system echo 'Dropping Table: workspace'
DROP TABLE IF EXISTS workspace;

