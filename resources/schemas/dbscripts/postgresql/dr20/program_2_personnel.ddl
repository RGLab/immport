DROP TABLE IF EXISTS program_2_personnel;

CREATE TABLE program_2_personnel
(
  
  program_id INT NOT NULL
    COMMENT "primary key.",

  personnel_id INT NOT NULL
    COMMENT "",

  role_type VARCHAR(12)
    COMMENT "",
  
  PRIMARY KEY (program_id,personnel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "umbrella research program (such as a u19 consortium like the humman immunology project consortium) that funded indvidual contracts or grants to perform research.";

CREATE INDEX idx_program_2_personnel on program_2_personnel(personnel_id,program_id);

