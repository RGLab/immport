DROP TABLE IF EXISTS experiment;

CREATE TABLE experiment
(
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  description VARCHAR(4000)
    COMMENT "Long text description.",
  
  measurement_technique VARCHAR(50) NOT NULL
    COMMENT "Reference to the measurement technique in the LK_EXP_MEASUREMENT_TECH table.",
  
  name VARCHAR(500)
    COMMENT "Name of the experiment.",
  
  purpose VARCHAR(50)
    COMMENT "Reference to the purpose in the LK_EXP_PURPOSE table.",
  
  study_accession VARCHAR(15)
    COMMENT "Reference to the study defined in the STUDY table.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (experiment_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Describes the type of experiment, measurement technique and links to protocols used in the experiment.";

CREATE INDEX idx_experiment_study on experiment(study_accession);
CREATE INDEX idx_experiment_workspace on experiment(workspace_id);
