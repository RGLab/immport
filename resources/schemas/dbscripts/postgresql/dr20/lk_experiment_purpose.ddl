DROP TABLE IF EXISTS lk_experiment_purpose;

CREATE TABLE lk_experiment_purpose
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "short name or identifier.",
  
  description VARCHAR(1000)
    COMMENT "long text description.",
  
  link VARCHAR(2000)
    COMMENT "link to external term",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "controlled vocabulary for the purpose of the experiment, such as the domain of biology being interrogated e.g., virus titer, genotyping.";
