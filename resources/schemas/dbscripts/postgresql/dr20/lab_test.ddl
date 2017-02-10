DROP TABLE IF EXISTS lab_test;

CREATE TABLE lab_test
(
  
  lab_test_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  biosample_accession VARCHAR(15)
    COMMENT "reference to the biological sample in the biosample table.",
  
  lab_test_panel_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the panel defined in the lab_test_panel table.",
  
  name_preferred VARCHAR(40)
    COMMENT "standardized name or code for the lab test (cv, tbd).",
  
  name_reported VARCHAR(125)
    COMMENT "a specific identifier for a test (e.g., wbc for white blood count).",
  
  reference_range_accession VARCHAR(15)
    COMMENT "",

  result_unit_preferred VARCHAR(40)
    COMMENT "this is the result_unit_preferred field.",
  
  result_unit_reported VARCHAR(40)
    COMMENT "for the given result value, the unit (if appropriate).",
  
  result_value_preferred FLOAT
    COMMENT "this is the result_value field.",
  
  result_value_reported VARCHAR(250)
    COMMENT "this column contains either: 1. the numeric part of a result that is a numeric measure of a quantity such as temperature or weight.  2. for an encoded value this column contains the code and the result_value_reported contains the decoding of the code 3. for a result that is text, (e.g. a qualitative assessment, a postive/negative result, or an indication that a condition occurred or did not occur) the textual result appears in both the result_value and result_value_reported",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions",
  
  PRIMARY KEY (lab_test_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "laboratory process operating on a biological sample that produces a single value; reference ranges specify the bounds of the determined value that are considered normal; in the shared database, the panel and test tables and concepts have been merged, while they are currently distinct tables in the load database.";

CREATE INDEX idx_lab_test_biosample on lab_test(biosample_accession);
CREATE INDEX idx_lab_test_workspace on lab_test(workspace_id);

