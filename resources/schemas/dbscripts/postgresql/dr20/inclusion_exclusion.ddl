DROP TABLE IF EXISTS inclusion_exclusion;

CREATE TABLE inclusion_exclusion
(
  
  criterion_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key",
  
  criterion VARCHAR(750)
    COMMENT "May be in the form of a question or a statement, such as: Does subject intend to remain in the ragweed pollen area for the entire ragweed season? if the criteria are in the form of a question then to be included in the study the subject answers for inclusion criteria should be yes and the answers to exclusion criteria should be no.",
  
  criterion_category VARCHAR(40)
    COMMENT "Value of either inclusion or exclusion.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the study defined in the STUDY table.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (criterion_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Defines the criteria by which subjects are excluded from or included in a study.";
