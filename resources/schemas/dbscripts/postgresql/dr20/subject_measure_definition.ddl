DROP TABLE IF EXISTS subject_measure_definition;

CREATE TABLE subject_measure_definition
(
  
  subject_measure_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  algorithm VARCHAR(1024)
    COMMENT "formula for calculating secondary measures.",
  
  description VARCHAR(4000)
    COMMENT "long text description.",
  
  measureofcentraltendency VARCHAR(40)
    COMMENT "whether mean, median or mode was utilized when there is a central tendency calculation performed.",
  
  measureofdispersion VARCHAR(40)
    COMMENT "variability or spread in a variable or probability calculation, such as variance, standard deviation, or interquartile range.",
  
  measuretype VARCHAR(40)
    COMMENT "description of the nature of the measure, be it categorical, numeric, continuous, etc.",
  
  name VARCHAR(125)
    COMMENT "the name of the measure.",
  
  outcometype VARCHAR(70)
    COMMENT "a characterization of the type of measurement being described, such as primary, secondary and other.",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study defined in the study table.",
  
  timeframe VARCHAR(256)
    COMMENT "a textual description of the timeframe involved in this measure (e.g. all days of the year).",
  
  unitofmeasure VARCHAR(40)
    COMMENT "unit utilized for this measure.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (subject_measure_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "defines computed measures on subject ;for example, a daily average allergy score may be computed from a set of specific allergy scores.";

CREATE INDEX idx_subject_measure_study on subject_measure_definition(study_accession);
CREATE INDEX idx_subject_measure_workspace on subject_measure_definition(workspace_id);
