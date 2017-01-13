DROP TABLE IF EXISTS study;

CREATE TABLE study
(
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "primary key.",
  
  actual_completion_date DATE
    COMMENT "final date on which data is collected.",
  
  actual_enrollment INT
    COMMENT "count of the number of subjects enrolled in the study.",
  
  actual_start_date DATE
    COMMENT "date the enrollment of subjects in the protocol begins.",
  
  age_unit VARCHAR(40)
    COMMENT "unit utilized for the study ages.",
  
  brief_description VARCHAR(4000)
    COMMENT "description of the study that is short enough to display on a website.",
  
  brief_title VARCHAR(250)
    COMMENT "a short title for the study or trial, utilized in displays with limited real estate.",
  
  clinical_trial VARCHAR(1) NOT NULL DEFAULT 'N'
    COMMENT "flag that indicates whether this is a clinical trial study.",
  
  condition_studied VARCHAR(1000)
    COMMENT "Primary disease or condition being studied. Should be expressed using the National Library of Medicine's Medical Subject Headings (MeSH) controlled vocabulary where possible.",
  
  dcl_id INT NOT NULL DEFAULT 0
    COMMENT "reference to the data completeness level in the lk_data_completeness table",

  delete_study VARCHAR(1) DEFAULT 'N'
    COMMENT "this is the delete_study field.",
  
  description LONGTEXT
    COMMENT "detailed description of the study from the study protocol.",

  doi VARCHAR(250)
    COMMENT "",
  
  download_page_available VARCHAR(1) DEFAULT 'N'
    COMMENT "flag that indicates whether a page has been created for downloading content directly on the study detail page.",
  
  endpoints MEDIUMTEXT
    COMMENT "Measures used to accomplish objectives; if an objective is to assess 'X', then a corresponding endpont may be an assay that measures 'X'; additional HTML markup included in this field to faciliitate display on the ImmPort website",
  
  final_public_release_date DATE
    COMMENT "date when the study was released to the semi-public workspace.",
  
  gender_included VARCHAR(50)
    COMMENT "sex of participants does study have only males, only females or both.",
  
  hypothesis VARCHAR(4000)
    COMMENT "this is the hypothesis field.",
  
  initial_data_release_date DATE
    COMMENT "this is the initial_data_release_date field.",
  
  initial_data_release_version VARCHAR(10)
    COMMENT "this is the initial_data_release_version field.",
  
  intervention_agent VARCHAR(1000)
    COMMENT "from clinicaltrials.gov, a process or action that is the focus of a clinical study. this can include giving participants drugs, medical devices, procedures, vaccines, and other products that are either investigational or already available. interventions can also include noninvasive approaches such as surveys, education, and interviews.",
  
  latest_data_release_date DATE
    COMMENT "this is the latest_data_release_date field.",
  
  latest_data_release_version VARCHAR(10)
    COMMENT "this is the latest_data_release_version field.",
  
  maximum_age VARCHAR(40)
    COMMENT "upper boundary for ages allowed for study participation.",
  
  minimum_age VARCHAR(40)
    COMMENT "lower boundary for ages allowed for study participation.",
  
  objectives MEDIUMTEXT
    COMMENT "this is the objectives field.",
  
  official_title VARCHAR(500)
    COMMENT "official title utilized in publications, public resources (such as clinicaltrials.gov)",
  
  planned_public_release_date DATE
    COMMENT "date when the study is to be released to the semi-public workspace",
  
  shared_study VARCHAR(1) NOT NULL DEFAULT 'N'
    COMMENT "this is the shared_study field.",
  
  sponsoring_organization VARCHAR(250)
    COMMENT "name of the primary organization that oversees implementation of the study and is responsible for data analysis. defined in 21 cfr 50.3",
  
  target_enrollment INT
    COMMENT "the subject recruitment target for the study.",
  
  type VARCHAR(50) NOT NULL
    COMMENT "from clinicaltrials.gov: describes the nature of a clinical study. study types include interventional studies (or clinical trials), observational studies, and expanded access.",
  
  workspace_id INT NOT NULL
    COMMENT "reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions",
  
  PRIMARY KEY (study_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "provides overall description of a study in conjunction with the observational_parameters and intervention_parameters tables. many attributes of a study are taken from the clinicaltrials.gov protocol data element definitions including the entire contents of the ancillary observational_parameters and observational_attributes tables. note that the slightly inconsistent nomenclature of brief_summay and detailed_description are taken directly from the protocol data element document.";

CREATE INDEX idx_study_type on study(type);
CREATE INDEX idx_study_workspace on study(workspace_id);
