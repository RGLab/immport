-- summary table, not actually used by cube, but similar in structure
-- "assay" is the name used in the cube, "name" is the dataset name
CREATE TABLE immport.dimStudyAssay (Study VARCHAR(100), Assay VARCHAR(100), Name VARCHAR(100), Label VARCHAR(100));
CREATE INDEX ix_study ON immport.dimStudyAssay (Study,Assay);
