DROP TABLE IF EXISTS intervention;

CREATE TABLE intervention
(
  
  intervention_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  compound_name_reported VARCHAR(250)
    COMMENT "Study specific name for the chemical or substance specified in this record",
  
  compound_role VARCHAR(40) NOT NULL
    COMMENT "Roles are: concommitant medication, substance use, and intervention",
  
  dose FLOAT
    COMMENT "A standardized numeric representation of the dose reported",
  
  dose_freq_per_interval VARCHAR(40)
    COMMENT "Number of repeated administations per time interval, e.g., twice daily. This is intended primarily for use with concomittant medications which don't have enough associated information for definition of a drug regimen (often they are ongoing), but which do have a dosage frequency.",
  
  dose_reported VARCHAR(150)
    COMMENT "The dose as exactly presented in the study results provided; is a text field to allow for unknown and other non-numeric values",
  
  dose_units VARCHAR(40)
    COMMENT "The units that the dose reported was presented in.",
  
  duration FLOAT
    COMMENT "Length of time that the subject was exposed to the substance.",
  
  duration_unit VARCHAR(10)
    COMMENT "Unit for the duration of time tha the subject was exposed to the substance.",
  
  end_day FLOAT
    COMMENT "Study end day will equal study start day unless a person is being given a drug with some sort of slow drug infusion technology.that extends over a long time period.",
  
  end_time VARCHAR(40)
    COMMENT "Time during the end study day when use of the substance ended.",
  
  formulation VARCHAR(125)
    COMMENT "Form of compund - for example, gel capsule. controlled vocabulary shall be cdisc codelist c66726 pharmaceutical dosage form",
  
  is_ongoing VARCHAR(40)
    COMMENT "This boolean is primarily for concommitant medications and indicates that the drug is taken at some regular interval witlhout a specified termination of dosing.",
  
  name_preferred VARCHAR(40)
    COMMENT "This is the merge_name_preferred field.",
  
  name_reported VARCHAR(125) NOT NULL
    COMMENT "This is the merge_name_reported field.",
  
  reported_indication VARCHAR(255)
    COMMENT "The reason a compound is administered (e.g., indication for tylenol might be headache).",
  
  route_of_admin_preferred VARCHAR(40)
    COMMENT "This column shall use the cdisc codelist c66729 for route of administration.",
  
  route_of_admin_reported VARCHAR(40)
    COMMENT "Route of administration reported on crf.",
  
  start_day FLOAT
    COMMENT "The study start day where the substance was first taken.",
  
  start_time VARCHAR(40)
    COMMENT "Time during the startstudy day when use of the substance started.",
  
  status VARCHAR(40)
    COMMENT "Values of: completed, not completed.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the study defined in the study table.",
  
  subject_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the subject in the subject table.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (intervention_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "A compound is merged with a subject via some route of administration. the compound can be either for test purposes (e.g., an allergen for an allergy test) or for intervention (a drug treating a condition).";

CREATE INDEX idx_intervention_subject on intervention(subject_accession);
CREATE INDEX idx_intervention_study on intervention(study_accession);
CREATE INDEX idx_intervention_workspace on intervention(workspace_id);

