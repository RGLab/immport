DROP TABLE IF EXISTS expsample_mbaa_detail;

CREATE TABLE expsample_mbaa_detail
(
  
  expsample_accession VARCHAR(15) NOT NULL
    COMMENT "Primary key.",
  
  assay_group_id VARCHAR(100)
    COMMENT "The assay group id is an optional element that links results from several plates or chips  together so they can be associated with a common set of standard curve measurements and control sample",
  
  assay_id VARCHAR(100)
    COMMENT "Required element that binds results from the same plate or chip together so they can be associated with a common set of standard curve measurements and controlsample measurements. what constitutes an assay depends on the experimental protocol. in this case, an assay indicates a set of samples, standard curves and control samples measured on a single plate. this information is often used for normalization purposes.",
  
  dilution_factor VARCHAR(100)
    COMMENT "An indication of the amount of control sample used in the assay based on the initial amount or concentration from the source.",
  
  plate_type VARCHAR(100)
    COMMENT "Reference to the plate types in the LK_PLATE_TYPE table",
  
  PRIMARY KEY (expsample_accession)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
  COMMENT "mbaa specific attributes of experiment sample";
