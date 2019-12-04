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
  COALESCE((SELECT uniprot_entry FROM lk_analyte WHERE lk_analyte.analyte_accession=result.analyte_accession AND uniprot_entry != '-'),analyte_reported,analyte_preferred) AS analyte,
  analyte_preferred,
  analyte_reported,
  arm_accession,
  assay_group_id,
  assay_id,
  biosample_accession,
  comments,
  -- for backward compatibilty with pre DR22
  COALESCE(IFDEFINED(concentration_unit),concentration_unit_reported) AS concentration_unit,
  COALESCE(IFDEFINED(concentration_value),concentration_value_reported) AS concentration_value,
  experiment_accession,
  mfi,
  mfi_coordinate,
  source_accession,
  source_type,
  study_accession,
  study_time_collected,
  study_time_collected_unit,
  subject_accession,
  workspace_id,
  repository_accession,
  repository_name,
  concentration_unit_reported,
  unit_preferred,
  concentration_value_reported,
  concentration_value_preferred
FROM mbaa_result AS result
WHERE subject_accession IS NOT NULL -- the mbaa_result table contains control and standard sample records as well
  AND ($STUDY IS NULL OR $STUDY = result.study_accession)
