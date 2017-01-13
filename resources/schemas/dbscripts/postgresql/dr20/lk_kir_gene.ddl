DROP TABLE IF EXISTS lk_kir_gene;

CREATE TABLE lk_kir_gene
(
  
  name VARCHAR(50) NOT NULL
    COMMENT "this is the gene_name field.",
  
  description VARCHAR(1000)
    COMMENT "this is the gene_description field.",
  
  link VARCHAR(2000)
    COMMENT "this is the link field.",
  
  PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "this is the lk_kir_gene table.";
