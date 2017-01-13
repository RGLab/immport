DROP TABLE IF EXISTS planned_visit;

CREATE TABLE planned_visit
(
  
  planned_visit_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  end_rule VARCHAR(256)
    COMMENT "description of the conditions that define the end of a planned visit.",
  
  max_start_day FLOAT
    COMMENT "final day in the study timeline where the planned visit may occur.",
  
  min_start_day FLOAT
    COMMENT "initial day in the study timeline where the planned visit may occur.",
  
  name VARCHAR(125)
    COMMENT "short descriptive name to identify the planned visit, may be defined in the study protocol for clinical studies.",
  
  order_number INT NOT NULL
    COMMENT "sequence of planned event sets (aka 'visits') for an arm. note that in the cdisc model planned visits are arm specific whereas elements can be used by more than one arm.",
  
  period_accession VARCHAR(15)
    COMMENT "reference to the perion in the period table.",
  
  start_rule VARCHAR(256)
    COMMENT "description of the conditions that define the beginning of a planned visit.",
  
  study_accession VARCHAR(15)
    COMMENT "reference to the study in the study table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions",
  
  PRIMARY KEY (planned_visit_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "the table represents both the classical cdisc visit which is a clinical encounter with a patient, and a set of planned activities that may occur between clinical encounters with a subject. an example of a planned activities that are not associated with a visit is the planned data analysis activities that occur in the advn klh study. the beginning of the planned event set is defined in terms of a range (min_start_day and max_start_day) within which the event can occur.";

CREATE INDEX idx_planned_visit_workspace on planned_visit(workspace_id);
CREATE INDEX idx_planned_visit_period on planned_visit(period_accession);

