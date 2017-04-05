DROP TABLE IF EXISTS lk_adverse_event_severity;

CREATE TABLE lk_adverse_event_severity
(
  
  name VARCHAR(60) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary to categorize the severity of a recorded adverse event.";
