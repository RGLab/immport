SELECT core.fn_dropifexists('lk_data_format', 'immport', 'TABLE', NULL);
SELECT core.fn_dropifexists('lk_experiment_purpose', 'immport', 'TABLE', NULL);
SELECT core.fn_dropifexists('lk_file_purpose', 'immport', 'TABLE', NULL);
SELECT core.fn_dropifexists('lk_kir_gene', 'immport', 'TABLE', NULL);
SELECT core.fn_dropifexists('lk_kir_present_absent', 'immport', 'TABLE', NULL);

ALTER TABLE immport.file_info DROP COLUMN IF EXISTS purpose;

ALTER TABLE immport.expsample_2_file_info DROP COLUMN IF EXISTS data_format;

ALTER TABLE immport.lk_analyte DROP COLUMN IF EXISTS gene_symbol;
ALTER TABLE immport.lk_analyte DROP COLUMN IF EXISTS uniprot_entry;
ALTER TABLE immport.lk_analyte DROP COLUMN IF EXISTS uniprot_entry_name;
ALTER TABLE immport.lk_analyte ADD COLUMN gene_symbol VARCHAR(100);
ALTER TABLE immport.lk_analyte ADD COLUMN uniprot_entry VARCHAR(20);
ALTER TABLE immport.lk_analyte ADD COLUMN uniprot_entry_name VARCHAR(255);
