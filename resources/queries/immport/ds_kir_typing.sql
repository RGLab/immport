/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */
PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
  COALESCE(study_time_collected,9999.0000) as sequencenum,

  result_id,
  -- for backward compatibility with pre DR22
  COALESCE(IFDEFINED(allele), allele_1) AS allele,
  ancestral_population,
  arm_accession,
  biosample_accession,
  comments,
  copy_number,
  experiment_accession,
  expsample_accession,
  gene_name,
  present_absent,
  result_set_id,
  study_accession,
  study_time_collected,
  study_time_collected_unit,
  subject_accession,
  workspace_id,
  repository_accession,
  repository_name,
  allele_1,
  allele_2,
  kir_haplotype
FROM kir_typing_result AS result
WHERE $STUDY IS NULL OR $STUDY = result.study_accession
