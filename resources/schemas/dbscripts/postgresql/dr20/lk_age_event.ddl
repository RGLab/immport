DROP TABLE IF EXISTS lk_age_event;

CREATE TABLE lk_age_event
(
  
  name VARCHAR(40) NOT NULL
    COMMENT "short name or idenifier.",
  
  description VARCHAR(1000) NOT NULL
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for when the age was measured in the study context.";
