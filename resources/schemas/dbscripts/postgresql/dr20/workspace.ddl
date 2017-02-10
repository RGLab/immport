DROP TABLE IF EXISTS workspace;

CREATE TABLE workspace
(
  
  workspace_id INT NOT NULL
    COMMENT "primary key.",
  
  category VARCHAR(50) NOT NULL
    COMMENT "this is the project_category field.",
  
  name VARCHAR(125) NOT NULL
    COMMENT "official title of the project.",
  
  type VARCHAR(20) NOT NULL
    COMMENT "this is the rpi_type field.",
  
  PRIMARY KEY (workspace_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "defines sandboxes where users can submit data for private use, for collaborating with a selected group of individuals, or can share to the wider immport community.";
