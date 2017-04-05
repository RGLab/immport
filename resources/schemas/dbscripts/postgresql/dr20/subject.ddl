DROP TABLE IF EXISTS subject;

CREATE TABLE subject
(
  
  subject_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  ancestral_population VARCHAR(100)
    COMMENT "this is the pop_name field.",
  
  description VARCHAR(4000)
    COMMENT "long text description.",
  
  ethnicity VARCHAR(50) DEFAULT 'Not Specified'
    COMMENT "reference to the ethnicity in the lk_ethnicity table.",
  
  gender VARCHAR(20) NOT NULL DEFAULT 'Not Specified'
    COMMENT "reference to the gender in the lk_gender table.",
  
  race VARCHAR(50) DEFAULT 'Not Specified'
    COMMENT "reference to the race in the lk_race table.",
  
  race_specify VARCHAR(1000)
    COMMENT "entered by the data provider when the race is not available in the controlled vocabulary.",
  
  species VARCHAR(50) NOT NULL
    COMMENT "reference to the species in the lk_species table",
  
  strain VARCHAR(50)
    COMMENT "short text name for the strain for the given animal species",
  
  strain_characteristics VARCHAR(500)
    COMMENT "longer text description of the strain characteristics.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (subject_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "patients or animals from which samples are taken for analysis.";

CREATE INDEX idx_subject_gender on subject(gender);
CREATE INDEX idx_subject_race on subject(race);
CREATE INDEX idx_subject_species on subject(species);
CREATE INDEX idx_subject_workspace on subject(workspace_id);
