-- NOTE: Leo prematurely bumped the version on 'trunk' to 18.30, hence the high script number

ALTER TABLE immport.dimDemographic ADD COLUMN exposure_material VARCHAR(100) NULL;
ALTER TABLE immport.dimDemographic ADD COLUMN exposure_process VARCHAR(100) NULL;
ALTER TABLE immport.immune_exposure ALTER COLUMN exposure_process_reported DROP NOT NULL;