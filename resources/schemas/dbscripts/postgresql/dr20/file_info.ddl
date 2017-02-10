DROP TABLE IF EXISTS file_info;

CREATE TABLE file_info
(
  
  file_info_id INT NOT NULL
    COMMENT "Primary key.",
  
  detail VARCHAR(100) NOT NULL
    COMMENT "Reference to the details about the file in the lk_file_detail table.",
  
  filesize_bytes INT NOT NULL
    COMMENT "Size of the file in bytes.",
  
  name VARCHAR(250) NOT NULL
    COMMENT "Name of the submitted file.",
  
  original_file_name VARCHAR(250) NOT NULL
    COMMENT "Rhis is the original_file_name field.",
  
  purpose VARCHAR(100) NOT NULL
    COMMENT "Reference to the purpose of the file in the lk_file_purpose table.",
  
  workspace_id INT NOT NULL
    COMMENT "Reference to the workspace to which this record is currently assigned; duplicated for reporting purposes but not utilized in permissions.",
  
  PRIMARY KEY (file_info_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "Contains metadata and content for result files, template files, and other files archived to workspaces.";

CREATE INDEX idx_file_info_workspace on file_info(workspace_id);
