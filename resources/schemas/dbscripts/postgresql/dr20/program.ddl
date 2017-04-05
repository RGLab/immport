DROP TABLE IF EXISTS program;

CREATE TABLE program
(
  
  program_id INT NOT NULL
    COMMENT "primary key.",
  
  category VARCHAR(50) NOT NULL
    COMMENT "this is the program_category field.",
  
  description VARCHAR(4000)
    COMMENT "summary of the details regarding the program.",
  
  end_date DATE
    COMMENT "official end date of the program.",
  
  link VARCHAR(2000)
    COMMENT "this is the link field.",
  
  name VARCHAR(200) NOT NULL
    COMMENT "official title of the program.",
  
  start_date DATE
    COMMENT "official start date of the program.",
  
  PRIMARY KEY (program_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "umbrella research program (such as a u19 consortium like the humman immunology project consortium) that funded indvidual contracts or grants to perform research.";
