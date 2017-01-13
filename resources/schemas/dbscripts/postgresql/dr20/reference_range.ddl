DROP TABLE IF EXISTS reference_range;

CREATE TABLE reference_range
(
  
  reference_range_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  age_range VARCHAR(40)
    COMMENT "this is the age_range field.",
  
  category VARCHAR(40)
    COMMENT "any condition of the subject when the sample being subjected to the lab test was taken that would affect the reference range. for example, the fact that a subject was fasting when a blood sample would affect the reference range for blood glucose level. this field is intended only to capture data available in a laboratory reference range.",
  
  gender VARCHAR(40)
    COMMENT "this is the gender field.",
  
  lab_or_study_source VARCHAR(256)
    COMMENT "source of the reference range, such as  the laboratory doing the testing or the study protocol.",
  
  lower_limit VARCHAR(40) NOT NULL
    COMMENT "lower boundary for the reference range value.",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study defined in the study table.",
  
  subject_condition VARCHAR(40)
    COMMENT "any condition of the subject when the sample being subjected to the lab test was taken that would affect the reference range. for example, the fact that a subject was fasting when a blood sample would affect the reference range for blood glucose level. this field is intended only to capture data available in a laboratory reference range.",
  
  test_or_assessment_name VARCHAR(125)
    COMMENT "this is the test_or_assessment_name field.",
  
  unit_of_measure VARCHAR(40) NOT NULL
    COMMENT "unit of measure utilized in the reference range.",
  
  upper_limit VARCHAR(40) NOT NULL
    COMMENT "upper boundary for the  reference range value.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (reference_range_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "defines value ranges for a lab test value that are considered normal. if a single value is considered normal rather than a range then upper and lower limits will be the same. if only an upper or lower bound is defined then the other bound shall be null. if a category is defined for a reference range then all values between lower and upper bound will be represented by the category.";

CREATE INDEX idx_reference_range_study on reference_range(study_accession);
CREATE INDEX idx_reference_range_workspace on reference_range(workspace_id);
