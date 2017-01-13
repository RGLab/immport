DROP TABLE IF EXISTS adverse_event;

CREATE TABLE adverse_event
(
  
  adverse_event_accession VARCHAR(15) NOT NULL
    COMMENT "Primary Key.",
  
  causality VARCHAR(250)
    COMMENT "CDISC term for relation of Adverse Event to study (NOT RELATED, UNLIKELY RELATED, POSSIBLY RELATED, PROBABLY RELATED, DEFINITELY RELATED).",
  
  description VARCHAR(4000)
    COMMENT "This is the event_description field.",
  
  end_study_day FLOAT
    COMMENT "Day in the study timeline where the adverse event ended.",
  
  end_time VARCHAR(40)
    COMMENT "Time during the start study day when the adverse event ended.",
  
  location_of_reaction_preferred VARCHAR(126)
    COMMENT "Standardized name or code for the location where reaction to adverse event occurred (would use SNOMED or other appropriate vocabulary, TDB).",
  
  location_of_reaction_reported VARCHAR(126)
    COMMENT "Location where reaction to adverse event occurred.",
  
  name_preferred VARCHAR(126)
    COMMENT "Standardized name for the adverse event.",
  
  name_reported VARCHAR(126)
    COMMENT "Short name for the adverse reaction e.g., Wheezing.",
  
  organ_or_body_system_preferred VARCHAR(126)
    COMMENT "Standardized name or code for the body system in the organism most affected by the adverse event occurred. (would use SNOMED or other appropriate vocabulary, TBD).",
  
  organ_or_body_system_reported VARCHAR(126)
    COMMENT "Body system in the organism most affected by the adverse event occurred.",
  
  other_action_taken VARCHAR(250)
    COMMENT "Treatment or action applied other than planned for the adverse event.",
  
  outcome_preferred VARCHAR(40)
    COMMENT "Standarized code for the outcome of the adverse event (could use rho standard or other vocabularly, TDB).",
  
  outcome_reported VARCHAR(40)
    COMMENT "Description of the outcome of the reported adverse event as provided: for Rho inc, this consists of resolved without sequelae, Resolved with sequelae,  Ongoing,  Present at death - not contributing to death,  Death due to AE.",
  
  relation_to_nonstudy_treatment VARCHAR(250)
    COMMENT "Determination of whether the adverse event was related to a non-planned treatment; would have values such as unrelated, definite, probably related, etc.",
  
  relation_to_study_treatment VARCHAR(250)
    COMMENT "Determination of whether the adverse event was related to the study treatment; would have values such as unrelated, definite, probably related, etc.",
  
  severity_preferred VARCHAR(60)
    COMMENT "Standardized code for the severity of the reported adverse event (could use rho standard or other vocabulary, TBD).",
  
  severity_reported VARCHAR(60) NOT NULL
    COMMENT "Description for the severity of the reported adverse event as provided; for rho inc, the consists of mild, moderate, severe, life threatening, death.",
  
  start_study_day FLOAT
    COMMENT "Day in the study timeline where the adverse event began.",
  
  start_time VARCHAR(40)
    COMMENT "Time during the start study day when the adverse event began.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the study defined in the study table.",
  
  study_treatment_action_taken VARCHAR(250)
    COMMENT "Planned treatment applied as a response to the given adverse event.",
  
  subject_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the subject in the subject table.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (adverse_event_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Records all information typically collected for adverse events. If the adverse event is detected as part of a planned subject assessment, then the assessment_accession foreign key will be non-null. If that key is null then the adverse event is detected through unplanned means such as subject self-reporting or clinician observation.";

CREATE INDEX idx_adverse_event_subject on adverse_event(subject_accession);
CREATE INDEX idx_adverse_event_study on adverse_event(study_accession);
CREATE INDEX idx_adverse_event_workspace on adverse_event(workspace_id);
