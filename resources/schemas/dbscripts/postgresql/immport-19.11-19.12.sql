ALTER TABLE immport.elisa_result ADD COLUMN analyte_accession VARCHAR(15);
ALTER TABLE immport.elisa_result ALTER COLUMN analyte_preferred TYPE VARCHAR(200);

ALTER TABLE immport.elispot_result ADD COLUMN analyte_accession VARCHAR(15);
ALTER TABLE immport.elispot_result ALTER COLUMN analyte_preferred TYPE VARCHAR(200);

ALTER TABLE immport.fcs_analyzed_result ALTER COLUMN population_stat_unit_preferred TYPE VARCHAR(200);
ALTER TABLE immport.fcs_analyzed_result ALTER COLUMN population_stat_unit_reported TYPE VARCHAR(200);

ALTER TABLE immport.mbaa_result ADD COLUMN analyte_accession VARCHAR(15);
ALTER TABLE immport.mbaa_result ALTER COLUMN analyte_preferred TYPE VARCHAR(200);

ALTER TABLE immport.pcr_result ADD COLUMN analyte_accession VARCHAR(15);
ALTER TABLE immport.pcr_result ALTER COLUMN gene_symbol_preferred TYPE VARCHAR(200);

ALTER TABLE immport.reagent ADD COLUMN analyte_accession VARCHAR(15);
ALTER TABLE immport.reagent ALTER COLUMN analyte_preferred TYPE VARCHAR(200);

ALTER TABLE immport.standard_curve ADD COLUMN analyte_accession VARCHAR(15);
ALTER TABLE immport.standard_curve ALTER COLUMN analyte_preferred TYPE VARCHAR(200);