DROP TABLE IF EXISTS study_2_protocol;

CREATE TABLE study_2_protocol
(
  
  study_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the study defined in the study table.",
  
  protocol_accession VARCHAR(15) NOT NULL
    COMMENT "reference to the protocol defined in the protocol table.",
  
  PRIMARY KEY (study_accession, protocol_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "join table to associate studies with their respective protocol document records.";
