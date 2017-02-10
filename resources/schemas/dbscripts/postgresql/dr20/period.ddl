DROP TABLE IF EXISTS period;

CREATE TABLE period
(
  
  period_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  name VARCHAR(250)
    COMMENT "official title for the study period as defined in the study protocol for clinical studies.",
  
  order_number INT
    COMMENT "sequencing of the periods.",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study defined in the study table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions",
  
  PRIMARY KEY (period_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "ClinicalTrials.gov definition of study stages used for reporting participant flow through a study. Period is defined in the Basic Results Data Element Definitions.Period at ClinicalTrials.gov is equivalent to sed for a CDISC Epoch. If there is only one period in a study it's value should be 'Overall Period'.";

CREATE INDEX idx_period_study on period(study_accession);
CREATE INDEX idx_period_workspace on period(workspace_id);
