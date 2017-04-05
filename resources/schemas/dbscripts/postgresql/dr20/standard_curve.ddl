DROP TABLE IF EXISTS standard_curve;

CREATE TABLE standard_curve
(
  
  standard_curve_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  analyte_preferred VARCHAR(100)
    COMMENT "preferred name of the soluble protein being measured.",
  
  analyte_reported VARCHAR(100)
    COMMENT "name of the soluble protein being measured.",
  
  assay_group_id VARCHAR(100)
    COMMENT "associates this result with a set of results that may come from a group of plates or chips.",
  
  assay_id VARCHAR(100)
    COMMENT "associates this result with a set of results that come from the same plate or chip. a plate may have results for experiment sample, control sample, standard curve.",
  
  experiment_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the experiment in the experiment table.",
  
  formula VARCHAR(500)
    COMMENT "formula for defining the standard curve",
  
  lower_limit VARCHAR(100)
    COMMENT "the lower limit of detection",
  
  lower_limit_unit VARCHAR(100)
    COMMENT "the unit (e.g., pg/ml) of the lower limit of detection value. an ontology will be specified for this filed.",
  
  result_schema VARCHAR(50) NOT NULL DEFAULT 'OTHER'
    COMMENT "database table to which this field represents",
  
  upload_result_status VARCHAR(20)
    COMMENT "this is the upld_rslt_status field.",
  
  upper_limit VARCHAR(100)
    COMMENT "the upper limit of detection. captured as text in template and evaluated for conversion to number in database.",
  
  upper_limit_unit VARCHAR(100)
    COMMENT "the unit (e.g., pg/ml) of the upper limit of detection value. an ontology will be specified for this filed.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (standard_curve_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "a standard curve is defined for each analyte in a batch (e.g., on a single plate)";
