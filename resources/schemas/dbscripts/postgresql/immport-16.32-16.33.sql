CREATE TABLE immport.subject_2_study
(
  subject_accession       VARCHAR(10) NOT NULL,
  study_accession         VARCHAR(15) NOT NULL
);
CREATE UNIQUE INDEX idx_subject_2_study_1 ON immport.subject_2_study(subject_accession,study_accession);
CREATE UNIQUE INDEX idx_subject_2_study_2 ON immport.subject_2_study(study_accession,subject_accession);
