
CREATE TABLE immport.dimSample
(
  SampleId  VARCHAR(100) NOT NULL,    -- for now == biosample_accession
  SubjectId VARCHAR(100) NOT NULL,
  Type      VARCHAR(100),
  Timepoint VARCHAR(100),
  Timepoint_SortOrder INT4
);
CREATE INDEX subjectsample ON immport.dimSample (SubjectId,SampleId);
CREATE INDEX samplesubject ON immport.dimSample (SampleId,SubjectId);

CREATE TABLE immport.dimSampleAssay
(
  SampleId  VARCHAR(100) NOT NULL,
  Assay     VARCHAR(100) NOT NULL
);
CREATE INDEX assaysample ON immport.dimSampleAssay (Assay,SampleId);
CREATE INDEX sampleassay ON immport.dimSampleAssay (SampleId,Assay);
