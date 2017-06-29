-- add repository_accession and repository_name
ALTER TABLE immport.elisa_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.elisa_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.elispot_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.elispot_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.fcs_analyzed_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.fcs_analyzed_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.hai_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.hai_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.hla_typing_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.hla_typing_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.kir_typing_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.kir_typing_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.mbaa_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.mbaa_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.neut_ab_titer_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.neut_ab_titer_result ADD COLUMN repository_name VARCHAR(50);

ALTER TABLE immport.pcr_result ADD COLUMN repository_accession VARCHAR(20);
ALTER TABLE immport.pcr_result ADD COLUMN repository_name VARCHAR(50);

-- name_preferred is longer
ALTER TABLE immport.assessment_panel ALTER COLUMN name_preferred TYPE VARCHAR(125);


-- kir_typing_result
-- these fields should go away when DR21 is not supported
-- allele, ancestral_population, copy_number, gene_name, present_absent, result_set_id

ALTER TABLE immport.kir_typing_result ALTER COLUMN ancestral_population DROP NOT NULL;
ALTER TABLE immport.kir_typing_result ALTER COLUMN gene_name DROP NOT NULL;
ALTER TABLE immport.kir_typing_result ALTER COLUMN result_set_id DROP NOT NULL;
ALTER TABLE immport.kir_typing_result ADD COLUMN allele_1 VARCHAR(250);
ALTER TABLE immport.kir_typing_result ADD COLUMN allele_2 VARCHAR(250);
ALTER TABLE immport.kir_typing_result ADD COLUMN kir_haplotype VARCHAR(250);

-- mbaa_result
-- these fields should go away when DR21 is not supported
-- concentration_unit, concentration_value
ALTER TABLE immport.mbaa_result ADD COLUMN concentration_unit_reported VARCHAR(100);
ALTER TABLE immport.mbaa_result ADD COLUMN unit_preferred VARCHAR(50);
ALTER TABLE immport.mbaa_result ADD COLUMN concentration_value_reported VARCHAR(100);
ALTER TABLE immport.mbaa_result ADD COLUMN concentration_value_preferred FLOAT;


-- These tables are removed in DR22, will be removed when DR21 is no longer supported
-- lk_kir_gene lk_kir_locus lk_kir_present_absent, performance_metrics

;