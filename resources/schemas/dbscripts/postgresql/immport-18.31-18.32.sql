-- DROP TABLE IF EXISTS immport.dimSampleType;
CREATE TABLE immport.dimSampleType
(
  subjectid character varying(100) NOT NULL,
  type character varying(100) NOT NULL
);
CREATE INDEX subjectsampletype ON immport.dimSampleType (subjectid,type);
CREATE INDEX sampletypesubject ON immport.dimSampleType (type,subjectid);
