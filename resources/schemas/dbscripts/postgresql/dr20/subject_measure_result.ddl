DROP TABLE IF EXISTS subject_measure_result;

CREATE TABLE subject_measure_result
(
  
  subject_measure_res_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  centraltendencymeasurevalue VARCHAR(40)
    COMMENT "value of the central tendency measure defined in the subject_measure_definition record.",
  
  datavalue VARCHAR(40)
    COMMENT "value calculated or recorded for this measure.",
  
  dispersionmeasurevalue VARCHAR(40)
    COMMENT "value of the dispersion measure defined in the subject_measure_definition record.",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study defined in the study table.",
  
  study_day FLOAT
    COMMENT "study day when the measure was taken or recorded.",
  
  subject_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the subject in the subject table.",
  
  subject_measure_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the definition of this measure and defined in the subject_measure_definition table.",
  
  time_of_day VARCHAR(40)
    COMMENT "iso format for time during the day when measurement was taken.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  year_of_measure DATE
    COMMENT "year that the measure was taken or recorded.",
  
  PRIMARY KEY (subject_measure_res_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "for the measures defined in the subject_measure_definition table, this table provides the results.";

CREATE INDEX idx_subject_measure_result_study on subject_measure_result(study_accession);
CREATE INDEX idx_subject_measure_result_subject on subject_measure_result(subject_accession);
CREATE INDEX idx_subject_measure_result_workspace on subject_measure_result(workspace_id);

