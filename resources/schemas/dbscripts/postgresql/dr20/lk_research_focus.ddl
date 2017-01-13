DROP TABLE IF EXISTS lk_research_focus;

CREATE TABLE lk_research_focus
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "focus of the research. autoimmune, transplantation, etc.",
  
  description VARCHAR(1000)
    COMMENT "long description of the focus of the research.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the study categories.";
