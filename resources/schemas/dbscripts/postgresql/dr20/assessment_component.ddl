DROP TABLE IF EXISTS assessment_component;

CREATE TABLE assessment_component
(
  
  assessment_component_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  age_at_onset_preferred FLOAT
    COMMENT "Standardized age value for the preferred age unit.",
  
  age_at_onset_reported VARCHAR(100)
    COMMENT "Numeric value for the age when the particular condition began, typically used for medical history assessments.",
  
  age_at_onset_unit_preferred VARCHAR(40)
    COMMENT "Reference to the unit in the lk_time_unit table.",
  
  age_at_onset_unit_reported VARCHAR(25)
    COMMENT "Unit for the age value when the particular condition began, typically used for medical history assessments.",
  
  assessment_panel_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the assessment panel to which this assessment component belongs.",
  
  is_clinically_significant VARCHAR(1) DEFAULT 'U'
    COMMENT "Y or N value to specify whether the practitioner viewed this measure as clinically relevant to the patient.",
  
  location_of_finding_preferred VARCHAR(256)
    COMMENT "Standardized name or code for the location of finding.",
  
  location_of_finding_reported VARCHAR(256)
    COMMENT "Localization of a finding when organ_or_body_system is insufficiently precise. for example, eczema affect the organ skin, but skin covers a lot of territory, so the finding will be localized with something like face.",
  
  name_preferred VARCHAR(150)
    COMMENT "This is the assessment_component name_preferred field.",
  
  name_reported VARCHAR(150) NOT NULL
    COMMENT "This is the assessment_component_name field.",
  
  organ_or_body_system_preferred VARCHAR(100)
    COMMENT "Standardized name or code for the body system in the organism most affected by the adverse event occurred. (would use SNOMED or other appropriate vocabulary, TBD).",
  
  organ_or_body_system_reported VARCHAR(100)
    COMMENT "Body system in the organism where the assessment was taken.",
  
  planned_visit_accession VARCHAR(15)
    COMMENT "Reference to the planned visit in the planned_visit table",
  
  reference_range_accession VARCHAR(15)
    COMMENT "Reference to the reference range defined in the reference_range table.",
  
  result_unit_preferred VARCHAR(40)
    COMMENT "The specific result unit separated from the unit in the reported result.",
  
  result_unit_reported VARCHAR(40)
    COMMENT "The specific result unit separated from the unit in the reported result.",
  
  result_value_category VARCHAR(40)
    COMMENT "This is the result_value_category field.",
  
  result_value_preferred FLOAT
    COMMENT "Standardized value  for the component result based on the preferred unit  (cv is still TBD).",
  
  result_value_reported VARCHAR(250)
    COMMENT "Specific result value (generally numeric) separated from the unit in the reported result.",
  
  study_day FLOAT
    COMMENT "She study day for the assessment panel.",
  
  subject_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the subject in the subject table.",
  
  subject_position_preferred VARCHAR(40)
    COMMENT "Standardized value for the subject position (CV is still TDB).",
  
  subject_position_reported VARCHAR(40)
    COMMENT "Physical placement of subject when assessment is made (e.g., standing, sitting, supline).",
  
  time_of_day VARCHAR(40)
    COMMENT "ISO format for time during the day when measurement was taken.",
  
  verbatim_question VARCHAR(250)
    COMMENT "Exact question posed for assessment panels whose type is questionnaire.",
  
  who_is_assessed VARCHAR(40)
    COMMENT "For assessment panels whose type is family history; values are self, Mother, Father, etc. Self is included because some family history CRFs include the subject in the family history.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (assessment_component_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "An assessment may be either a study specific component or a standard component (such as a standard blood test or an erythema component of a EASI assessment); in the shared database, the panel and component tables and concepts have been merged, while they are currently distinct tables in the load database";

CREATE INDEX idx_assessment_component_assessment_panel on assessment_component(assessment_panel_accession);
CREATE INDEX idx_assessment_component_subject on assessment_component(subject_accession);
CREATE INDEX idx_assessment_component_planned_visit on assessment_component(planned_visit_accession);
CREATE INDEX idx_assessment_workspace on assessment_component(workspace_id);
