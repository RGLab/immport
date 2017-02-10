DROP TABLE IF EXISTS planned_visit_2_arm;

CREATE TABLE planned_visit_2_arm
(
  
  planned_visit_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the planned_visit in the planned_visit table.",
  
  arm_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the arm in the arm_or_cohort table.",
  
  PRIMARY KEY (planned_visit_accession, arm_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "if all arms or cohorts have the same set of visits, then every arm or cohort will be associated with every visit. in interventional studies is is possible for the different arms to be differentiated only by the drug regimens (e.g., placebo vs. experimental drug) occuring during the visits, so the arms may be distinguishable at the event level only by differences in the attributes of actual substance merge events for each subject.";
