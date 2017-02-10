DROP TABLE IF EXISTS study_pubmed;

CREATE TABLE study_pubmed
(
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  pubmed_id VARCHAR(16) NOT NULL
    COMMENT "unique pubmed identifier for the article.",
  
  authors VARCHAR(4000)
    COMMENT "list of authors of the article.",
  
  doi VARCHAR(100)
    COMMENT "this the doi field.",
  
  issue VARCHAR(20)
    COMMENT "issue in which the article was published.",
  
  journal VARCHAR(250)
    COMMENT "publication in which the article appears in.",
  
  month VARCHAR(12)
    COMMENT "month that the article was published.",
  
  pages VARCHAR(20)
    COMMENT "number of pages in the article.",
  
  title VARCHAR(4000)
    COMMENT "title of the article as it appears in pubmed.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  year VARCHAR(4)
    COMMENT "year that the article was published.",
  
  PRIMARY KEY (study_accession, pubmed_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "provides references to pubmed records associated with the results of the given study";
