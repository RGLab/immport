DROP TABLE IF EXISTS lk_study_panel;

CREATE TABLE lk_study_panel
(
  
  name VARCHAR(100) NOT NULL
    COMMENT "name of the user interface panel (or section) in the study detail page.",
  
  collapsible VARCHAR(1)
    COMMENT "(y/n) value that determines whether the panel is collapsible (i.e. ajax supported) or static.",
  
  description VARCHAR(1000)
    COMMENT "long description of the user interface panel (or section) in the study detail page.",
  
  display_name VARCHAR(100)
    COMMENT "the display name for the for study panel.",
  
  sort_order INT
    COMMENT "the study display panel display sort order.",
  
  visible VARCHAR(1)
    COMMENT "(y/n) value that determines whether the panel expanded by default when the study detail page is initially opened.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary that lists the names of web display panels that may be associated with a given study.";
