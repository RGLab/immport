DROP TABLE IF EXISTS study_glossary;

CREATE TABLE study_glossary
(
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  definition VARCHAR(500) NOT NULL
    COMMENT "the definition of the defined term.",
  
  term VARCHAR(125) NOT NULL
    COMMENT "term defined in the glossary.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (study_accession, term)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "term definitions provided by a study.";

CREATE INDEX idx_study_glossaryworkspace on study_glossary(workspace_id);
