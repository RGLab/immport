
-- NOTE: disease_reported inconsistency between .ddl file (NOT NULL) and .txt file (lots of NULLs)
ALTER TABLE immport.immune_exposure ALTER COLUMN disease_reported DROP NOT NULL;
ALTER TABLE immport.immune_exposure ALTER COLUMN disease_preferred DROP NOT NULL;
-- NOTE: exposure_material_reported inconsistency between .ddl file (NOT NULL) and .txt file (lots of NULLs)
ALTER TABLE immport.immune_exposure ALTER COLUMN exposure_material_reported DROP NOT NULL;
ALTER TABLE immport.immune_exposure ALTER COLUMN exposure_material_preferred DROP NOT NULL;
ALTER TABLE immport.immune_exposure ALTER COLUMN exposure_process_preferred DROP NOT NULL;
ALTER TABLE immport.immune_exposure ALTER COLUMN exposure_process_preferred DROP NOT NULL;
