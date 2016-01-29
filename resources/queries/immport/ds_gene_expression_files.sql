PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT DISTINCT
ge_links.name AS file_info_name,
ge_links.file_link AS file_link,
ge_links.geo_link AS geo_link,
ge_links.expsample_accession,
biosample.biosample_accession,
biosample.subject_accession || '.' || SUBSTRING(biosample.study_accession,4) as participantid,
COALESCE(biosample.study_time_collected,9999.0000) as sequencenum,
biosample.biosampling_accession,
biosample.description,
biosample.name AS biosample_name,
biosample.type,
biosample.subtype,
biosample.study_time_collected,
biosample.study_time_collected_unit,
biosample.study_time_t0_event,
biosample.study_time_t0_event_specify,
biosample.study_accession,
arm_or_cohort.arm_accession,
arm_or_cohort.name AS arm_name
FROM (
  SELECT
  (CASE WHEN (gef_name IS NULL OR gef_name = '') THEN gel_name ELSE gef_name END) AS name,
  (CASE WHEN (gef_es IS NULL OR gef_es = '') THEN gel_es ELSE gef_es END) AS expsample_accession,
  file_link,
  geo_link
  FROM (
    SELECT
    q_GEF.expsample_accession AS gef_es,
    q_GEF.name AS gef_name,
    q_GEF.file_link,
    q_GEO.expsample_accession AS gel_es,
    q_GEO.name AS gel_name,
    q_GEO.geo_link
    FROM q_GEF FULL OUTER JOIN q_GEO ON q_GEF.name = q_GEO.name
                                    AND q_GEF.expsample_accession = q_GEO.expsample_accession
  ) AS ge_links
) AS ge_links,
biosample, biosample_2_expsample, arm_2_subject, arm_or_cohort
WHERE
biosample.biosample_accession = biosample_2_expsample.biosample_accession AND
biosample_2_expsample.expsample_accession = ge_links.expsample_accession AND
biosample.subject_accession = arm_2_subject.subject_accession AND
arm_2_subject.arm_accession = arm_or_cohort.arm_accession AND
biosample.study_accession = arm_or_cohort.study_accession
AND ($STUDY IS NULL OR $STUDY = biosample.study_accession)

