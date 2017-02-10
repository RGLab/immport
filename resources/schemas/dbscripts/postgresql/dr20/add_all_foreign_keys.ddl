system echo 'Adding Foreign Keys to adverse_event'
ALTER TABLE adverse_event ADD CONSTRAINT fk_adverse_event_1
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);
ALTER TABLE adverse_event ADD CONSTRAINT fk_adverse_event_2
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE adverse_event ADD CONSTRAINT fk_adverse_event_3
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE adverse_event ADD CONSTRAINT fk_adverse_event_4
    FOREIGN KEY (severity_preferred)
    REFERENCES lk_adverse_event_severity(name);

system echo 'Adding Foreign Keys to arm_2_subject'
ALTER TABLE arm_2_subject ADD CONSTRAINT fk_arm_2_subject_1
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort(arm_accession);
ALTER TABLE arm_2_subject ADD CONSTRAINT fk_arm_2_subject_2
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);
ALTER TABLE arm_2_subject ADD CONSTRAINT fk_arm_2_subject_3
    FOREIGN KEY (age_unit)
    REFERENCES lk_time_unit(name);
ALTER TABLE arm_2_subject ADD CONSTRAINT fk_arm_2_subject_4
    FOREIGN KEY (age_event)
    REFERENCES lk_age_event(name);


system echo 'Adding Foreign Keys to arm_or_cohort'
ALTER TABLE arm_or_cohort ADD CONSTRAINT fk_arm_or_cohort_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE arm_or_cohort ADD CONSTRAINT fk_arm_or_cohort_2
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);

system echo 'Adding Foreign Keys to assessment_2_file_info'
ALTER TABLE assessment_2_file_info ADD CONSTRAINT fk_assessment_2_file_info_1
    FOREIGN KEY (file_info_id)
    REFERENCES file_info(file_info_id);
ALTER TABLE assessment_2_file_info ADD CONSTRAINT fk_assessment_2_file_info_2
    FOREIGN KEY (assessment_panel_accession)
    REFERENCES assessment_panel(assessment_panel_accession);
ALTER TABLE assessment_2_file_info ADD CONSTRAINT fk_assessment_2_file_info_3
    FOREIGN KEY (data_format)
    REFERENCES lk_data_format(name);
ALTER TABLE assessment_2_file_info ADD CONSTRAINT fk_assessment_2_file_info_4
    FOREIGN KEY (result_schema)
    REFERENCES lk_expsample_result_schema(name);

system echo 'Adding Foreign Keys to assessment_component'
ALTER TABLE assessment_component ADD CONSTRAINT fk_assessment_component_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE assessment_component ADD CONSTRAINT fk_assessment_component_2
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);

## Waiting for the Data to be back populated
##ALTER TABLE assessment_component ADD CONSTRAINT fk_assessment_component_3
##    FOREIGN KEY (planned_visit_accession)
##    REFERENCES planned_visit(planned_visit_accession);

ALTER TABLE assessment_component ADD CONSTRAINT fk_assessment_component_4
    FOREIGN KEY (assessment_panel_accession)
    REFERENCES assessment_panel(assessment_panel_accession);
ALTER TABLE assessment_component ADD CONSTRAINT fk_assessment_component_5
    FOREIGN KEY (reference_range_accession)
    REFERENCES reference_range(reference_range_accession);
ALTER TABLE assessment_component ADD CONSTRAINT fk_assessment_component_6
    FOREIGN KEY (result_unit_preferred)
    REFERENCES lk_unit_of_measure(name);
ALTER TABLE assessment_component ADD CONSTRAINT fk_assessment_component_7
    FOREIGN KEY (age_at_onset_unit_preferred)
    REFERENCES lk_time_unit(name);

system echo 'Adding Foreign Keys to assessment_panel'
ALTER TABLE assessment_panel ADD CONSTRAINT fk_assessment_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE assessment_panel ADD CONSTRAINT fk_assessment_2
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);

system echo 'Adding Foreign Keys to biosample'
ALTER TABLE biosample ADD CONSTRAINT fk_biosample_1
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);
ALTER TABLE biosample ADD CONSTRAINT fk_biosample_2
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE biosample ADD CONSTRAINT fk_biosample_4
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE biosample ADD CONSTRAINT fk_biosample_5
    FOREIGN KEY (study_time_collected_unit)
    REFERENCES lk_time_unit (name);
ALTER TABLE biosample ADD CONSTRAINT fk_biosample_6
    FOREIGN KEY (study_time_t0_event)
    REFERENCES lk_t0_event (name);
ALTER TABLE biosample ADD CONSTRAINT fk_biosample_7
    FOREIGN KEY (planned_visit_accession)
    REFERENCES planned_visit (planned_visit_accession);
ALTER TABLE biosample ADD CONSTRAINT fk_biosample_8
    FOREIGN KEY (type)
    REFERENCES lk_sample_type (name);

system echo 'Adding Foreign Keys to biosample_2_treatment'
ALTER TABLE biosample_2_treatment ADD CONSTRAINT fk_biosample_2_treatment_1
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample(biosample_accession);
ALTER TABLE biosample_2_treatment ADD CONSTRAINT fk_biosample_2_treatment_2
    FOREIGN KEY (treatment_accession)
    REFERENCES treatment(treatment_accession);

system echo 'Adding Foreign Keys to contract_grant'
ALTER TABLE contract_grant ADD CONSTRAINT fk_contract_1
    FOREIGN KEY (program_id)
    REFERENCES program(program_id);

system echo 'Adding Foreign Keys to contract_grant_2_personnel'
ALTER TABLE contract_grant_2_personnel ADD CONSTRAINT fk_contract_2_personnel_1
    FOREIGN KEY (contract_grant_id)
    REFERENCES contract_grant(contract_grant_id);
ALTER TABLE contract_grant_2_personnel ADD CONSTRAINT fk_contract_2_personnel_2
    FOREIGN KEY (personnel_id)
    REFERENCES personnel(personnel_id);
ALTER TABLE contract_grant_2_personnel ADD CONSTRAINT fk_contract_2_personnel_3
    FOREIGN KEY (role_type)
    REFERENCES lk_user_role_type(name);

system echo 'Adding Foreign Keys to contract_grant_2_study'
ALTER TABLE contract_grant_2_study ADD CONSTRAINT fk_contract_2_study_1
    FOREIGN KEY (contract_grant_id)
    REFERENCES contract_grant(contract_grant_id);
ALTER TABLE contract_grant_2_study ADD CONSTRAINT fk_contract_2_study_3
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);


system echo 'Adding Foreign Keys to control_sample'
ALTER TABLE control_sample ADD CONSTRAINT fk_control_sample_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE control_sample ADD CONSTRAINT fk_control_sample_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment(experiment_accession);
ALTER TABLE control_sample ADD CONSTRAINT fk_control_sample_3
    FOREIGN KEY (result_schema)
    REFERENCES lk_expsample_result_schema (name);

system echo 'Adding Foreign Keys to control_sample_2_file_info'
ALTER TABLE control_sample_2_file_info ADD CONSTRAINT fk_control_sample_2_file_info_1
    FOREIGN KEY (control_sample_accession)
    REFERENCES control_sample(control_sample_accession);
ALTER TABLE control_sample_2_file_info ADD CONSTRAINT fk_control_sample_2_file_info_2
   FOREIGN KEY (file_info_id)
    REFERENCES file_info(file_info_id);
ALTER TABLE control_sample_2_file_info ADD CONSTRAINT fk_control_sample_2_file_info_3
   FOREIGN KEY (data_format)
    REFERENCES lk_data_format(name);
ALTER TABLE control_sample_2_file_info ADD CONSTRAINT fk_control_sample_2_file_info_4
   FOREIGN KEY (result_schema)
    REFERENCES lk_expsample_result_schema(name);

system echo 'Adding Foreign Keys to elisa_result'
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_7
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
#ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_8
#    FOREIGN KEY (analyte_preferred)
#    REFERENCES lk_analyte(analyte_preferred);
ALTER TABLE elisa_result ADD CONSTRAINT fk_elisa_result_9
    FOREIGN KEY (unit_preferred)
    REFERENCES lk_unit_of_measure(name);

system echo 'Adding Foreign Keys to elispot_result'
ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_7
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
#ALTER TABLE elispot_result ADD CONSTRAINT fk_elispot_result_8
#    FOREIGN KEY (analyte_preferred)
#    REFERENCES lk_analyte(analyte_preferrred);

system echo 'Adding Foreign Keys to experiment'
ALTER TABLE experiment ADD CONSTRAINT fk_experiment_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE experiment ADD CONSTRAINT fk_experiment_2
    FOREIGN KEY (purpose)
    REFERENCES lk_experiment_purpose (name);
ALTER TABLE experiment ADD CONSTRAINT fk_experiment_3
    FOREIGN KEY (measurement_technique)
    REFERENCES lk_exp_measurement_tech (name);
ALTER TABLE experiment ADD CONSTRAINT fk_experiment_4
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

system echo 'Adding Foreign Keys to experiment_2_protocol'
ALTER TABLE experiment_2_protocol ADD CONSTRAINT fk_experiment_2_protocol_1
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment(experiment_accession);
ALTER TABLE experiment_2_protocol ADD CONSTRAINT fk_exp_2_protocol_2
    FOREIGN KEY (protocol_accession)
    REFERENCES protocol(protocol_accession);

system echo 'Adding Foreign Keys to expsample'
ALTER TABLE expsample ADD CONSTRAINT fk_expsample_1
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
#ALTER TABLE expsample ADD CONSTRAINT fk_expsample_2
#    FOREIGN KEY (result_schema)
#    REFERENCES lk_expsample_result_schema (name);
ALTER TABLE expsample ADD CONSTRAINT fk_expsample_3
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);

system echo 'Adding Foreign Keys to expsample_2_biosample'
ALTER TABLE expsample_2_biosample ADD CONSTRAINT fk_expsample_2_biosample_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample(expsample_accession);
ALTER TABLE expsample_2_biosample ADD CONSTRAINT fk_expsample_2_biosample_2
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample(biosample_accession);

system echo 'Adding Foreign Keys to expsample_2_file_info'
ALTER TABLE expsample_2_file_info ADD CONSTRAINT fk_expsample_2_file_info_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample(expsample_accession);
ALTER TABLE expsample_2_file_info ADD CONSTRAINT fk_expsample_2_file_info_2
   FOREIGN KEY (file_info_id)
    REFERENCES file_info(file_info_id);
ALTER TABLE expsample_2_file_info ADD CONSTRAINT fk_expsample_2_file_info_3
   FOREIGN KEY (data_format)
    REFERENCES lk_data_format(name);
ALTER TABLE expsample_2_file_info ADD CONSTRAINT fk_expsample_2_file_info_4
   FOREIGN KEY (result_schema)
    REFERENCES lk_expsample_result_schema(name);

system echo 'Adding Foreign Keys to expsample_2_reagent'
ALTER TABLE expsample_2_reagent ADD CONSTRAINT fk_expsample_2_reagent_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample(expsample_accession);
ALTER TABLE expsample_2_reagent ADD CONSTRAINT fk_expsample_2_reagent_2
    FOREIGN KEY (reagent_accession)
    REFERENCES reagent(reagent_accession);

system echo 'Adding Foreign Keys to expsample_2_treatment'
ALTER TABLE expsample_2_treatment ADD CONSTRAINT fk_expsample_2_treatment_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample(expsample_accession);
ALTER TABLE expsample_2_treatment ADD CONSTRAINT fk_expsample_2_treatment_2
    FOREIGN KEY (treatment_accession)
    REFERENCES treatment(treatment_accession);

system echo 'Adding Foreign Keys to expsample_mbaa_detail'
ALTER TABLE expsample_mbaa_detail ADD CONSTRAINT fk_expsample_mbaa_detail_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample(expsample_accession);
ALTER TABLE expsample_mbaa_detail ADD CONSTRAINT fk_expsample_mbaa_detail_2
    FOREIGN KEY (plate_type)
    REFERENCES lk_plate_type (name);

system echo 'Adding Foreign Keys to expsample_public_repository'
ALTER TABLE expsample_public_repository ADD CONSTRAINT fk_expsample_public_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE expsample_public_repository ADD CONSTRAINT fk_expsample_public_2
    FOREIGN KEY (repository_name)
    REFERENCES lk_public_repository (name);


system echo 'Adding Foreign Keys to fcs_analyzed_result'
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_8
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);

##COMMENTED OUT FOR NOW, Name column in lk_cell_population is too long
##ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_9
##    FOREIGN KEY (parent_population_preferred)
##    REFERENCES lk_cell_population (name);
##ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_10
##    FOREIGN KEY (population_name_preferred)
##    REFERENCES lk_cell_population (name);
##ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_11
##    FOREIGN KEY (population_defnition_preferred)
##    REFERENCES lk_cell_population (definition);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_12
    FOREIGN KEY (population_stat_unit_preferred)
    REFERENCES lk_unit_of_measure (name);
ALTER TABLE fcs_analyzed_result ADD CONSTRAINT fk_fcs_analyzed_result_13
    FOREIGN KEY (workspace_file_info_id)
    REFERENCES file_info (file_info_id);

system echo 'Adding Foreign Keys to fcs_analyzed_result_marker'
ALTER TABLE fcs_analyzed_result_marker ADD CONSTRAINT fk_fcs_analyzed_result_marker_1
    FOREIGN KEY (result_id)
    REFERENCES fcs_analyzed_result (result_id);

system echo 'Adding Foreign Keys to fcs_header'
ALTER TABLE fcs_header ADD CONSTRAINT fk_fcs_header_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE fcs_header ADD CONSTRAINT fk_fcs_header_2
    FOREIGN KEY (file_info_id)
    REFERENCES file_info (file_info_id);

system echo 'Adding Foreign Keys to fcs_header_marker'
ALTER TABLE fcs_header_marker ADD CONSTRAINT fk_fcs_header_marker_1
    FOREIGN KEY (fcs_header_id)
    REFERENCES fcs_header (fcs_header_id);

system echo 'Adding Foreign Keys to file_info'
ALTER TABLE file_info ADD CONSTRAINT fk_file_info_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);
ALTER TABLE file_info ADD CONSTRAINT fk_file_info_2
    FOREIGN KEY (detail)
    REFERENCES lk_file_detail (name);
ALTER TABLE file_info ADD CONSTRAINT fk_file_info_3
    FOREIGN KEY (purpose)
    REFERENCES lk_file_purpose (name);

system echo 'Adding Foreign Keys to hai_result'
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_7
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_8
    FOREIGN KEY (virus_strain_preferred)
    REFERENCES lk_virus_strain (name);
ALTER TABLE hai_result ADD CONSTRAINT fk_hai_result_9
    FOREIGN KEY (unit_preferred)
    REFERENCES lk_unit_of_measure (name);

system echo 'Adding Foreign Keys to hla_typing_result'
ALTER TABLE hla_typing_result ADD CONSTRAINT fk_hla_typing_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE hla_typing_result ADD CONSTRAINT fk_hla_typing_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE hla_typing_result ADD CONSTRAINT fk_hla_typing_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE hla_typing_result ADD CONSTRAINT fk_hla_typing_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE hla_typing_result ADD CONSTRAINT fk_hla_typing_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE hla_typing_result ADD CONSTRAINT fk_hla_typing_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE hla_typing_result ADD CONSTRAINT fk_hla_typing_result_7
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);

system echo 'Adding Foreign Keys to inclusion_exclusion'
ALTER TABLE inclusion_exclusion ADD CONSTRAINT fk_inclusion_exclusion_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE inclusion_exclusion ADD CONSTRAINT fk_inclusion_exclusion_2
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE inclusion_exclusion ADD CONSTRAINT fk_inclusion_exclusion_3
    FOREIGN KEY (criterion_category)
    REFERENCES lk_criterion_category(name);

system echo 'Adding Foreign Keys to intervention'
ALTER TABLE intervention ADD CONSTRAINT fk_intervention_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE intervention ADD CONSTRAINT fk_intervention_2
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE intervention ADD CONSTRAINT fk_intervention_3
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);
ALTER TABLE intervention ADD CONSTRAINT fk_intervention_4
    FOREIGN KEY (compound_role)
    REFERENCES lk_compound_role(name);

system echo 'Adding Foreign Keys to kir_typing_result'
ALTER TABLE kir_typing_result ADD CONSTRAINT fk_kir_typing_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE kir_typing_result ADD CONSTRAINT fk_kir_typing_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE kir_typing_result ADD CONSTRAINT fk_kir_typing_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE kir_typing_result ADD CONSTRAINT fk_kir_typing_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE kir_typing_result ADD CONSTRAINT fk_kir_typing_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE kir_typing_result ADD CONSTRAINT fk_kir_typing_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE kir_typing_result ADD CONSTRAINT fk_kir_typing_result_7
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);

system echo 'Adding Foreign Keys to lab_test'
ALTER TABLE lab_test ADD CONSTRAINT fk_lab_test_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE lab_test ADD CONSTRAINT fk_lab_test_2
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample(biosample_accession);
ALTER TABLE lab_test ADD CONSTRAINT fk_lab_test_3
    FOREIGN KEY (lab_test_panel_accession)
    REFERENCES lab_test_panel(lab_test_panel_accession);
ALTER TABLE lab_test ADD CONSTRAINT fk_lab_test_4
    FOREIGN KEY (name_preferred)
    REFERENCES lk_lab_test_name(name);
ALTER TABLE lab_test ADD CONSTRAINT fk_lab_test_5
    FOREIGN KEY (result_unit_preferred)
    REFERENCES lk_unit_of_measure(name);

system echo 'Adding Foreign Keys to lab_test_panel'
ALTER TABLE lab_test_panel ADD CONSTRAINT fk_lab_test_panel_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE lab_test_panel ADD CONSTRAINT fk_lab_test_panel_2
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

system echo 'Adding Foreign Keys to lab_test_panel_2_protocol'
ALTER TABLE lab_test_panel_2_protocol ADD CONSTRAINT fk_lab_test__panel_2_protocol_1
    FOREIGN KEY (lab_test_panel_accession)
    REFERENCES lab_test_panel(lab_test_panel_accession);
ALTER TABLE lab_test_panel_2_protocol ADD CONSTRAINT fk_lab_test_2_protocol_2
    FOREIGN KEY (protocol_accession)
    REFERENCES protocol(protocol_accession);

system echo 'Adding Foreign Keys to mbaa_result'
ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_1
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_2
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_3
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_4
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_5
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_6
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_7
    FOREIGN KEY (source_type)
    REFERENCES lk_source_type(name);
##ALTER TABLE mbaa_result ADD CONSTRAINT fk_mbaa_result_8
##    FOREIGN KEY (analyte_preferred)
##    REFERENCES lk_analyte(analyte_preferred);

system echo 'Adding Foreign Keys to neut_ab_titer_result'
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_7
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_8
    FOREIGN KEY (virus_strain_preferred)
    REFERENCES lk_virus_strain (name);
ALTER TABLE neut_ab_titer_result ADD CONSTRAINT fk_neut_result_9
    FOREIGN KEY (unit_preferred)
    REFERENCES lk_unit_of_measure (name);

system echo 'Adding Foreign Keys to pcr_result'
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_1
    FOREIGN KEY (expsample_accession)
    REFERENCES expsample (expsample_accession);
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment (experiment_accession);
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_4
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort (arm_accession);
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_5
    FOREIGN KEY (biosample_accession)
    REFERENCES biosample (biosample_accession);
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_6
    FOREIGN KEY (subject_accession)
    REFERENCES subject (subject_accession);
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_7
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);
ALTER TABLE pcr_result ADD CONSTRAINT fk_pcr_result_8
    FOREIGN KEY (unit_preferred)
    REFERENCES lk_unit_of_measure (name);

system echo 'Adding Foreign Keys to period'
ALTER TABLE period ADD CONSTRAINT fk_period_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE period ADD CONSTRAINT fk_period_2
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);

system echo 'No Foreign Keys for personnel'

system echo 'Adding Foreign Keys to planned_visit'
ALTER TABLE planned_visit ADD CONSTRAINT fk_planned_visit_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE planned_visit ADD CONSTRAINT fk_planned_visit_2
    FOREIGN KEY (period_accession)
    REFERENCES period(period_accession);
ALTER TABLE planned_visit ADD CONSTRAINT fk_planned_visit_3
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);

system echo 'Adding Foreign Keys to planned_visit_2_arm'
ALTER TABLE planned_visit_2_arm ADD CONSTRAINT fk_planned_visit_2_arm_1
    FOREIGN KEY (planned_visit_accession)
    REFERENCES planned_visit(planned_visit_accession);
ALTER TABLE planned_visit_2_arm ADD CONSTRAINT fk_planned_visit_2_arm_2
    FOREIGN KEY (arm_accession)
    REFERENCES arm_or_cohort(arm_accession);

system echo 'Adding Foreign Keys to program'
ALTER TABLE program ADD CONSTRAINT fk_program_1
    FOREIGN KEY (category)
    REFERENCES lk_visibility_category(name);

system echo 'Adding Foreign Keys to program_2_personnel'
ALTER TABLE program_2_personnel ADD CONSTRAINT fk_program_2_personnel_1
    FOREIGN KEY (program_id)
    REFERENCES program(program_id);
ALTER TABLE program_2_personnel ADD CONSTRAINT fk_program_2_personnel_2
    FOREIGN KEY (personnel_id)
    REFERENCES personnel(personnel_id);
ALTER TABLE program_2_personnel ADD CONSTRAINT fk_program_2_personnel_3
    FOREIGN KEY (role_type)
    REFERENCES lk_user_role_type(name);

system echo 'Adding Foreign Keys to protocol'
ALTER TABLE protocol ADD CONSTRAINT fk_protocol_1
    FOREIGN KEY (type)
    REFERENCES lk_protocol_type(name);
ALTER TABLE protocol ADD CONSTRAINT fk_protocol_2
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);

system echo 'Adding Foreign Keys to protocol_deviation'
ALTER TABLE protocol_deviation ADD CONSTRAINT fk_protocol_deviation_1
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);
ALTER TABLE protocol_deviation ADD CONSTRAINT fk_protocol_deviation_2
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE protocol_deviation ADD CONSTRAINT fk_protocol_deviation_3
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);

system echo 'Adding Foreign Keys to reagent'
ALTER TABLE reagent ADD CONSTRAINT fk_reagent_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE reagent ADD CONSTRAINT fk_reagent_2
    FOREIGN KEY (type)
    REFERENCES lk_reagent_type(name);
##ALTER TABLE reagent ADD CONSTRAINT fk_reagent_3
##    FOREIGN KEY (analyte_preferred)
##    REFERENCES lk_analyte(analyte_preferred);

system echo 'Adding Foreign Keys to reagent_set_2_reagent'
ALTER TABLE reagent_set_2_reagent ADD CONSTRAINT fk_reagent_set_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE reagent_set_2_reagent ADD CONSTRAINT fk_reagent_set_2
    FOREIGN KEY (reagent_accession)
    REFERENCES reagent(reagent_accession);
ALTER TABLE reagent_set_2_reagent ADD CONSTRAINT fk_reagent_set_3
    FOREIGN KEY (reagent_set_accession)
    REFERENCES reagent(reagent_accession);

#system echo 'Adding Foreign Keys to reagent_2_fcs_marker'
##ALTER TABLE reagent_2_fcs_marker ADD CONSTRAINT fk_reagent_2_fcs_marker
##    FOREIGN KEY (reagent_accession)
##    REFERENCES reagent(reagent_accession);

system echo 'Adding Foreign Keys to reference_range'
ALTER TABLE reference_range ADD CONSTRAINT fk_reference_range_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE reference_range ADD CONSTRAINT fk_reference_range_2
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

system echo 'Adding Foreign Keys to reported_early_termination'
ALTER TABLE reported_early_termination ADD CONSTRAINT fk_reported_early_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE reported_early_termination ADD CONSTRAINT fk_reported_early_2
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE reported_early_termination ADD CONSTRAINT fk_reported_early_3
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);

system echo 'Adding Foreign Keys to standard_curve'
ALTER TABLE standard_curve ADD CONSTRAINT fk_standard_curve_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE standard_curve ADD CONSTRAINT fk_standard_curve_2
    FOREIGN KEY (experiment_accession)
    REFERENCES experiment(experiment_accession);
ALTER TABLE standard_curve ADD CONSTRAINT fk_standard_curve_3
    FOREIGN KEY (result_schema)
    REFERENCES lk_expsample_result_schema (name);
##ALTER TABLE standard_curve ADD CONSTRAINT fk_standard_curve_4
##    FOREIGN KEY (analyte_preferred)
##    REFERENCES lk_analyte (analyte_preferred);

system echo 'Adding Foreign Keys to standard_curve_2_file_info'
ALTER TABLE standard_curve_2_file_info ADD CONSTRAINT fk_standard_curve_2_file_info_1
    FOREIGN KEY (standard_curve_accession)
    REFERENCES standard_curve(standard_curve_accession);
ALTER TABLE standard_curve_2_file_info ADD CONSTRAINT fk_standard_curve_2_file_info_2
   FOREIGN KEY (file_info_id)
    REFERENCES file_info(file_info_id);
ALTER TABLE standard_curve_2_file_info ADD CONSTRAINT fk_standard_curve_2_file_info_3
   FOREIGN KEY (data_format)
    REFERENCES lk_data_format(name);
ALTER TABLE standard_curve_2_file_info ADD CONSTRAINT fk_standard_curve_2_file_info_4
   FOREIGN KEY (result_schema)
    REFERENCES lk_expsample_result_schema(name);

system echo 'Adding Foreign Keys to study'
ALTER TABLE study ADD CONSTRAINT fk_study_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace(workspace_id);
ALTER TABLE study ADD CONSTRAINT fk_study_2
    FOREIGN KEY (type)
    REFERENCES lk_study_type(name);
ALTER TABLE study ADD CONSTRAINT fk_study_3
    FOREIGN KEY (dcl_id)
    REFERENCES lk_data_completeness(id);

system echo 'Adding Foreign Keys to study_2_panel'
ALTER TABLE study_2_panel ADD CONSTRAINT fk_study_2_panel_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE study_2_panel ADD CONSTRAINT fk_study_2_panel_2
    FOREIGN KEY (panel_name)
    REFERENCES lk_study_panel(name);

system echo 'Adding Foreign Keys to study_2_protocol'
ALTER TABLE study_2_protocol ADD CONSTRAINT fk_study_2_protocol_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE study_2_protocol ADD CONSTRAINT fk_study_2_protocol_2
    FOREIGN KEY (protocol_accession)
    REFERENCES protocol(protocol_accession);

system echo 'Adding Foreign Keys to study_categorization'
ALTER TABLE study_categorization ADD CONSTRAINT fk_study_categorization_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE study_categorization ADD CONSTRAINT fk_study_categorization_2
    FOREIGN KEY (research_focus)
    REFERENCES lk_research_focus(name);

system echo 'Adding Foreign Keys to study_file'
ALTER TABLE study_file ADD CONSTRAINT fk_study_file_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE study_file ADD CONSTRAINT fk_study_file_2
    FOREIGN KEY (study_file_type)
    REFERENCES lk_study_file_type(name);

system echo 'Adding Foreign Keys to study_glossary'
ALTER TABLE study_glossary ADD CONSTRAINT fk_study_glossary_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);
ALTER TABLE study_glossary ADD CONSTRAINT fk_study_glossary_2
    FOREIGN KEY (study_accession)
    REFERENCES study (study_accession);

system echo 'Adding Foreign Keys to study_image'
ALTER TABLE study_image ADD CONSTRAINT fk_study_image_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

system echo 'Adding Foreign Keys to study_link'
ALTER TABLE study_link ADD CONSTRAINT fk_study_link_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

system echo 'Adding Foreign Keys to study_personnel'
ALTER TABLE study_personnel ADD CONSTRAINT fk_study_personnel_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);
ALTER TABLE study_personnel ADD CONSTRAINT fk_study_personnel_2
    FOREIGN KEY (role_in_study)
    REFERENCES lk_personnel_role(name);

system echo 'Adding Foreign Keys to study_pubmed'
ALTER TABLE study_pubmed ADD CONSTRAINT fk_study_pubmed_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

system echo 'Adding Foreign Keys to subject'
ALTER TABLE subject ADD CONSTRAINT fk_subject_1
    FOREIGN KEY (gender)
    REFERENCES lk_gender (name);
ALTER TABLE subject ADD CONSTRAINT fk_subject_2
    FOREIGN KEY (ethnicity)
    REFERENCES lk_ethnicity (name);
ALTER TABLE subject ADD CONSTRAINT fk_subject_3
    FOREIGN KEY (race)
    REFERENCES lk_race (name);
ALTER TABLE subject ADD CONSTRAINT fk_subject_4
    FOREIGN KEY (species)
    REFERENCES lk_species (name);
ALTER TABLE subject ADD CONSTRAINT fk_subject_5
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);

system echo 'Adding Foreign Keys to subject_measure_definition'
ALTER TABLE subject_measure_definition ADD CONSTRAINT fk_subject_measure_def_1
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

ALTER TABLE subject_measure_result ADD CONSTRAINT fk_subject_measure_result_1
    FOREIGN KEY (subject_accession)
    REFERENCES subject(subject_accession);
ALTER TABLE subject_measure_result ADD CONSTRAINT fk_subject_measure_result_2
    FOREIGN KEY (subject_measure_accession)
    REFERENCES subject_measure_definition(subject_measure_accession);
ALTER TABLE subject_measure_result ADD CONSTRAINT fk_subject_measure_result_3
    FOREIGN KEY (study_accession)
    REFERENCES study(study_accession);

system echo 'Adding Foreign Keys to treatment'
ALTER TABLE treatment ADD CONSTRAINT fk_treatment_1
    FOREIGN KEY (workspace_id)
    REFERENCES workspace (workspace_id);
ALTER TABLE treatment ADD CONSTRAINT fk_treatment_2
    FOREIGN KEY (amount_unit)
    REFERENCES lk_unit_of_measure (name);
ALTER TABLE treatment ADD CONSTRAINT fk_treatment_3
    FOREIGN KEY (duration_unit)
    REFERENCES lk_time_unit (name);
ALTER TABLE treatment ADD CONSTRAINT fk_treatment_4
    FOREIGN KEY (temperature_unit)
    REFERENCES lk_unit_of_measure (name);
