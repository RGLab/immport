/*
 * Copyright (c) 2013-2014 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
 */
PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT
subject.subject_accession || '.' || SUBSTRING(study_accession,4) as participantid,
subject.subject_accession,
subject.description,
--DR20 subject.phenotype,
--DR20 subject.age_reported,
--DR20 subject.age_unit,
--DR20 subject.age_event,
--DR20 subject.age_event_specify,
subject.strain,
subject.strain_characteristics,
subject.gender,
subject.ethnicity,
--DR20 subject.population_name,
subject.race,
subject.race_specify,
subject.species,
--DR20 subject.taxonomy_id,
subject.workspace_id
FROM subject INNER JOIN subject_2_study s2s ON subject.subject_accession = s2s.subject_accession
WHERE $STUDY IS NULL OR s2s.study_accession=$STUDY
