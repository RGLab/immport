DROP TABLE IF EXISTS expsample;

CREATE TABLE expsample
(
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  description VARCHAR(4000)
    COMMENT "Long text description.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment in the EXPERIMENT table.",
  
  name VARCHAR(200)
    COMMENT "Short name or identifier.",
  
  result_schema VARCHAR(50) NOT NULL DEFAULT 'OTHER'
    COMMENT "Based on the experiment sample template used, a reference to the database table that would contain the parsed results.",
  
  upload_result_status VARCHAR(20)
    COMMENT "This is the upld_rslt_status field.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the WORKSPACE to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (expsample_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Links the biosample analyzed in an experiment to the assay reagent, protocol and results via the experiment sample record.";

CREATE INDEX idx_expsample_experiment on expsample(experiment_accession);
CREATE INDEX idx_expsample_workspace on expsample(workspace_id);
