CREATE TABLE immport.dimAssay (SubjectId VARCHAR(100) NOT NULL, Assay VARCHAR(100));
CREATE INDEX subjectassay ON immport.dimAssay (SubjectId,Assay);
CREATE INDEX assaysubject ON immport.dimAssay (Assay,SubjectId);


CREATE TABLE immport.dimDemographic
(
   SubjectId VARCHAR(100),
   AgeInYears INTEGER,
   Species VARCHAR(100),
   Gender VARCHAR(100),
   Race VARCHAR(100),
   Age VARCHAR(100),
   Study VARCHAR(100)
);
CREATE INDEX participantage ON immport.dimDemographic (SubjectId,AgeInYears);
CREATE INDEX ageparticipant ON immport.dimDemographic (AgeInYears,SubjectId);
CREATE INDEX participantagegroup ON immport.dimDemographic (SubjectId,Age);
CREATE INDEX agegroupparticipant ON immport.dimDemographic (Age,SubjectId);
CREATE INDEX participantspecies ON immport.dimDemographic (SubjectId,Species);
CREATE INDEX speciesparticipant ON immport.dimDemographic (Species,SubjectId);
CREATE INDEX participantgender ON immport.dimDemographic (SubjectId,Gender);
CREATE INDEX genderparticipant ON immport.dimDemographic (Gender,SubjectId);
CREATE INDEX participantrace ON immport.dimDemographic (SubjectId,Race);
CREATE INDEX raceparticipant ON immport.dimDemographic (Race,SubjectId);


-- DROP TABLE immport.dimStudy;
CREATE TABLE immport.dimStudy (Study VARCHAR(100), Type VARCHAR(100), SortOrder INTEGER, Program VARCHAR(200));
CREATE INDEX typestudy ON immport.dimStudy (Type,Study);
CREATE INDEX studytype ON immport.dimStudy (Study,Type);


CREATE TABLE immport.dimStudyCondition (Study VARCHAR(100), Condition VARCHAR(100));
CREATE INDEX studycondition ON immport.dimStudyCondition (Study,Condition);
CREATE INDEX conditionstudy ON immport.dimStudyCondition (Condition,Study);


-- DROP TABLE immport.dimStudyTimepoint
CREATE TABLE immport.dimStudyTimepoint (Study VARCHAR(100), Timepoint VARCHAR(100), SortOrder INTEGER);
CREATE INDEX studytme ON immport.dimStudyTimepoint (Study,Timepoint);
CREATE INDEX timestudy ON immport.dimStudyTimepoint (Timepoint,Study);


ALTER TABLE immport.study ADD COLUMN restricted BOOLEAN DEFAULT TRUE;
