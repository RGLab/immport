DROP TABLE IF EXISTS lk_criterion_category;

CREATE TABLE lk_criterion_category
(
  
  name VARCHAR(40) NOT NULL
    COMMENT "name of criteria.",
  
  description VARCHAR(1000)
    COMMENT "long description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for inclusion_exclusion criterion_category.";
