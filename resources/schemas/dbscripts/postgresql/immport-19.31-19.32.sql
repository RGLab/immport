ALTER TABLE immport.dimStudy ADD CONSTRAINT pkstudy PRIMARY KEY (study);

ALTER TABLE immport.dimStudy ADD COLUMN brief_title VARCHAR(250);
ALTER TABLE immport.dimStudy ADD COLUMN shared_study VARCHAR(1);
ALTER TABLE immport.dimStudy ADD COLUMN research_focus VARCHAR(50);
ALTER TABLE immport.dimStudy ADD COLUMN pi_names VARCHAR(4000);
ALTER TABLE immport.dimStudy ADD COLUMN assays VARCHAR(4000);
ALTER TABLE immport.dimStudy ADD COLUMN sample_types VARCHAR(4000);
ALTER TABLE immport.dimStudy ADD COLUMN restricted BOOLEAN;