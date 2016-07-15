ALTER TABLE immport.fcs_analyzed_result DROP COLUMN IF EXISTS pop_cell_number_unit_preferred;
ALTER TABLE immport.fcs_analyzed_result ADD COLUMN pop_cell_number_unit_preferred VARCHAR(50);
