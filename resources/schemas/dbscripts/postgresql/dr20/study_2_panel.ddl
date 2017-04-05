DROP TABLE IF EXISTS study_2_panel;

CREATE TABLE study_2_panel
(
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  panel_name VARCHAR(100) NOT NULL
    COMMENT "name of the display panel in the immport user interface.",
  
  PRIMARY KEY (study_accession, panel_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "join table between the study and lk_study_panel table.";
