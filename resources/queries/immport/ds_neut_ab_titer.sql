/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */
PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
  COALESCE(study_time_collected,9999.0000) as sequencenum,
  COALESCE(virus_strain_preferred, virus_strain) as virus,
  result.*
FROM neut_ab_titer_result AS result
WHERE $STUDY IS NULL OR $STUDY = result.study_accession
