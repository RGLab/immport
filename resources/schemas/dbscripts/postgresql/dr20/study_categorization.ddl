DROP TABLE IF EXISTS study_categorization;

CREATE TABLE study_categorization
(
  
  study_categorization_id INT NOT NULL
    COMMENT "primary key.",
  
  research_focus VARCHAR(50) NOT NULL
    COMMENT "reference to the research focus defined in the lk_research_focus table.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  PRIMARY KEY (study_categorization_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Describes a study's focus, purpose or category.";
