/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */

PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
  COALESCE(study_time_collected,9999.0000) AS sequencenum,
  COALESCE(population_stat_unit_preferred, population_stat_unit_reported) AS cell_number_unit,
  result.*
FROM fcs_analyzed_result AS result
WHERE $STUDY IS NULL OR $STUDY = result.study_accession
