DROP TABLE IF EXISTS control_sample;

CREATE TABLE control_sample
(
  
  control_sample_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  assay_group_id VARCHAR(100)
    COMMENT "Optional element that links results from several plates or chips  together so they can be associated with a common set of standard curve measurements and control sample.",
  
  assay_id VARCHAR(100)
    COMMENT "Required element that binds results from the same plate or chip together so they can be associated with a common set of standard curve measurements and control sample measurements. what constitutes an assay depends on the experimental protocol. in this case, an assay indicates a set of samples, standard curves and control samples measured on a single plate. this information is often used for normalization purposes.",
  
  catalog_id VARCHAR(100)
    COMMENT "An identifier provided by the source to denote a particular control sample.",
  
  dilution_factor VARCHAR(100)
    COMMENT "An indication of the amount of control sample used in the assay based on the initial amount or concentration from the source.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "Reference to the experiment in the experiment table.",
  
  lot_number VARCHAR(100)
    COMMENT "Identifies a specific version of a control sample.",
  
  result_schema VARCHAR(50) NOT NULL DEFAULT 'OTHER'
    COMMENT "Based on the experiment sample template used, a reference to the database table that would contain the parsed results.",
  
  source VARCHAR(100)
    COMMENT "The name of the lab/company/supplier providing the control sample.",
  
  upload_result_status VARCHAR(20)
    COMMENT "This is the upld_rslt_status field.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (control_sample_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Used for quality control and to allow comparison between assay runs or across labs. these control samples are distinct from biosamples since they are often purchased in bulk, and are not linked to particular study subjects.";

CREATE INDEX idx_control_sample_workspace on control_sample(workspace_id);
