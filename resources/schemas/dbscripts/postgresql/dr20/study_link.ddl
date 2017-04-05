DROP TABLE IF EXISTS study_link;

CREATE TABLE study_link
(
  
  study_link_id INT NOT NULL
    COMMENT "primary key.",
  
  name VARCHAR(500)
    COMMENT "the value displayed on the web page with the url attached.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  type VARCHAR(50)
    COMMENT "describes whether this is a link to a website or another type of link.",
  
  value VARCHAR(2000)
    COMMENT "the value of the url.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (study_link_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "associates studies with outside url links that reference the study, such as clinicaltrials.gov.";
