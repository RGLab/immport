DROP TABLE IF EXISTS reagent;

CREATE TABLE reagent
(
  
  reagent_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  analyte_preferred VARCHAR(200)
    COMMENT "curated analyte name",
  
  analyte_reported VARCHAR(200)
    COMMENT "reported analyte name",
  
  antibody_registry_id VARCHAR(250)
    COMMENT "reference to antibodyregistry.org to describe antibody based reagents",
  
  catalog_number VARCHAR(250)
    COMMENT "identifier for the reagent in the vendor catalog.",
  
  clone_name VARCHAR(200)
    COMMENT "if this is not a reagent set, indicates the detector (e.g. anti-cd3, goat anti-mouse igm + igg, cfse, propidium iodide). (n.b. cfse and propidium iodide are examples of  reagents that acts as both a detector and a reporter).",
  
  contact VARCHAR(1000)
    COMMENT "this is the exp_sam_rea_contact field.",
  
  description VARCHAR(4000)
    COMMENT "long text description.",
  
  is_set VARCHAR(1) DEFAULT 'N'
    COMMENT "(y/n) indicating whether or not the reagent is a member of a set or collection.",
  
  lot_number VARCHAR(250)
    COMMENT "lot number from the reagent manufacturer.",
  
  manufacturer VARCHAR(100)
    COMMENT "name of the reagent manufacturer.",
  
  name VARCHAR(200)
    COMMENT "short name or identifier.",
  
  reporter_name VARCHAR(200)
    COMMENT "if this is not a reagent set, indicates the reporter (e.g. fitc, percp, qdot605 cfse, propidium iodide).  (n.b. cfse and propidium iodide are examples of  reagents that acts as both a detector and a reporter).",
  
  type VARCHAR(50)
    COMMENT "reference to the reagent type in the lk_reagent_type table.",
  
  weblink VARCHAR(250)
    COMMENT "url link to information about the reagent.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (reagent_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "material used to measure an analyte(s); in the case of a microarray, this would be the chip type and name. in many cases, this may include information about probes: name, type, description, manufacturer, software used to select probe, etc.";

CREATE INDEX idx_reagent_workspace on reagent(workspace_id);
