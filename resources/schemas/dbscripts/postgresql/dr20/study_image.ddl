DROP TABLE IF EXISTS study_image;

CREATE TABLE study_image
(
  
  schematic_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  description VARCHAR(4000)
    COMMENT "long text description.",
  
  image_filename VARCHAR(250)
    COMMENT "filename of the image.",
  
  image_map_filename VARCHAR(250)
    COMMENT "filename of the image map.",
  
  image_type VARCHAR(40)
    COMMENT "classifier for the type of study image.",
  
  name VARCHAR(40)
    COMMENT "short title for the study image.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (schematic_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "associates studies with their respective study images, such as study schematics used in the study detail page.";

CREATE INDEX idx_study_image_study on study_image(study_accession);
CREATE INDEX idx_study_image_workspace on study_image(workspace_id);
