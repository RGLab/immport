/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */

PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
  COALESCE(study_time_collected,9999.0000) AS sequencenum,
  -- backward compatibility
  COALESCE(population_statistic_preferred, CAST(population_statistic_reported AS DOUBLE)) AS population_cell_number,
  CASE
    WHEN population_statistic_preferred IS NOT NULL THEN population_stat_unit_preferred
    ELSE population_stat_unit_reported
  END  AS cell_number_unit,
  -- fix spelling
  population_defnition_preferred as population_definition_preferred,
  population_defnition_reported as population_definition_reported,
  result.*
FROM fcs_analyzed_result AS result
WHERE $STUDY IS NULL OR $STUDY = result.study_accession
