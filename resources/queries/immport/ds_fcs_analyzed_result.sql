/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */

PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
  COALESCE(study_time_collected,9999.0000) AS sequencenum,
  COALESCE(parent_population_preferred, parent_population_reported) AS base_parent_population,
  -- backward compatibility
  COALESCE(population_statistic_preferred, CAST(population_statistic_reported AS DOUBLE)) AS population_cell_number,
  COALESCE(population_stat_unit_preferred, population_stat_unit_reported) AS cell_number_unit,
  -- fix spelling
  population_defnition_preferred as population_definition_preferred,
  population_defnition_reported as population_definition_reported,
  result.*
FROM fcs_analyzed_result AS result
WHERE $STUDY IS NULL OR $STUDY = result.study_accession
