ALTER TABLE immport.lk_exposure_material ALTER COLUMN name TYPE VARCHAR(100);

ALTER TABLE immport.fcs_header_marker ALTER COLUMN pns_preferred TYPE VARCHAR(100);

ALTER TABLE immport.immune_exposure ALTER COLUMN exposure_material_reported TYPE VARCHAR(150);
ALTER TABLE immport.immune_exposure ALTER COLUMN exposure_material_preferred TYPE VARCHAR(150);

ALTER TABLE immport.dimDemographic ALTER COLUMN exposure_material TYPE VARCHAR(150);