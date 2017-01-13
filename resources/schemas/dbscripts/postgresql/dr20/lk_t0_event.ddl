DROP TABLE IF EXISTS lk_t0_event;

CREATE TABLE lk_t0_event
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000) NOT NULL
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for what the time zero event is in the study context;";
