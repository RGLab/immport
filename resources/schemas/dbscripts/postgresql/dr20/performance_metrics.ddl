DROP TABLE IF EXISTS performance_metrics;

CREATE TABLE performance_metrics
(
  
  performance_metrics_id INT NOT NULL
    COMMENT "this is the performance_metrics_id field.",
  
  class_name VARCHAR(250)
    COMMENT "this is the class_name field.",
  
  duration FLOAT
    COMMENT "this is the duration field.",
  
  end_time DATE
    COMMENT "this is the end_time field.",
  
  ip_address VARCHAR(500)
    COMMENT "this is the ip_address field.",
  
  method_name VARCHAR(250)
    COMMENT "this is the method_name field.",
  
  parameter_values VARCHAR(4000)
    COMMENT "this is the parameter_values field.",
  
  parameters VARCHAR(4000)
    COMMENT "this is the parameters field.",
  
  session_id VARCHAR(250)
    COMMENT "this is the session_id field.",
  
  start_time DATE
    COMMENT "this is the start_time field.",
  
  username VARCHAR(12) NOT NULL
    COMMENT "this is the username field.",
  
  PRIMARY KEY (performance_metrics_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "the performance_metrics table.";
