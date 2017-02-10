DROP TABLE IF EXISTS lk_protocol_type;

CREATE TABLE lk_protocol_type
(
  
  name VARCHAR(100) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the types of protocol documents captured in immport, such as study protocols, experiment protocols.";
