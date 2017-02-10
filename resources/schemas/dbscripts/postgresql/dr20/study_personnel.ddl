DROP TABLE IF EXISTS study_personnel;

CREATE TABLE study_personnel
(
  
  person_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  site_name VARCHAR(100) NOT NULL
    COMMENT "name of the site where the individual works within an institution (where appropriate).",
  
  email VARCHAR(40)
    COMMENT "email address for the individual in this data record.",
  
  first_name VARCHAR(40)
    COMMENT "first name for the individual in this data record.",
  
  honorific VARCHAR(20)
    COMMENT "honorific title for the individual in this data record.",
  
  last_name VARCHAR(40)
    COMMENT "last name for the individual in this data record.",
  
  organization VARCHAR(125)
    COMMENT "organization or institution for the individual in this data record.",
  
  role_in_study VARCHAR(40)
    COMMENT "role within the given study for the individual in this data record.",
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  suffixes VARCHAR(40)
    COMMENT "phd., ld, etc. a person may have multiple suffixes",
  
  title_in_study VARCHAR(100)
    COMMENT "title within the given study for the individual in this data record.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (person_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Contact information table for persons who are involved in conducting studies; titles and roles of a person involved in conducting the study are stored since these attributes are properties of the person's association with the study and not of ther person.  Also, the person's organizational affiliation during the study is also recorded  since a person's current organizational affiliation may not be the same as their affiliation during the study.";
