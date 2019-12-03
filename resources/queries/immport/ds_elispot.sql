/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */
PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
  COALESCE(study_time_collected,9999.0000) as sequencenum,
  COALESCE((SELECT uniprot_entry FROM lk_analyte WHERE lk_analyte.analyte_accession=result.analyte_accession AND uniprot_entry != '-'),analyte_reported,analyte_preferred) AS analyte,
  result.*
FROM elispot_result AS result
WHERE $STUDY IS NULL OR $STUDY = result.study_accession
