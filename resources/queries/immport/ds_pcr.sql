/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */

PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
  COALESCE(study_time_collected,9999.0000) as sequencenum,
  gene_id AS entrez_gene_id,
  result.arm_accession,
  result.biosample_accession,
  result.comments,
  result.experiment_accession,
  result.expsample_accession,
  result.gene_id,
  result.gene_name,
  COALESCE(gene_symbol_preferred,gene_symbol_reported,gene_symbol) AS gene_symbol,
  result.gene_symbol_preferred,
  result.gene_symbol_reported,
  result.other_gene_accession,
  result.study_accession,
  result.study_time_collected,
  result.study_time_collected_unit,
  result.subject_accession,
  result.unit_preferred,
  result.unit_reported,
  result.value_preferred,
  result.value_reported,
  result.workspace_id,
  result.repository_accession,
  result.repository_name
FROM pcr_result AS result
WHERE $STUDY IS NULL OR $STUDY = result.study_accession
