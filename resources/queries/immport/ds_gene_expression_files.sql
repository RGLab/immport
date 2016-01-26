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
    -- Both in GEF and GEO
    SELECT
    GEF.expsample_accession AS gef_es,
    GEF.name AS gef_name,
    GEF.file_link,
    GEO.expsample_accession AS gel_es,
    GEO.name AS gel_name,
    GEO.geo_link,
    FROM GEF INNER JOIN GEO ON GEF.name = GEO.name
                                       AND GEF.expsample_accession = GEO.expsample_accession

    UNION ALL 
   
    -- Only on GEF
    SELECT
    GEF.expsample_accession AS gef_es,
    GEF.name AS gef_name,
    GEF.file_link,
    CAST( NULL AS VARCHAR(50)),
    CAST( NULL AS VARCHAR(50)),
    CAST( NULL AS VARCHAR(50))
    FROM
    GEF
    WHERE NOT EXISTS ( SELECT * FROM GEO WHERE GEF.name = GEO.name
                                                 AND GEF.expsample_accession = GEO.expsample_accession)

    UNION ALL 

    -- Only on GEO
    SELECT
    CAST( NULL AS VARCHAR(50)),
    CAST( NULL AS VARCHAR(50)),
    CAST( NULL AS VARCHAR(50)),
    GEO.expsample_accession AS gel_es,
    GEO.name AS gel_name,
    GEO.geo_link
    FROM
    GEO
    WHERE NOT EXISTS ( SELECT * FROM GEF WHERE GEF.name = GEO.name
                                                 AND GEF.expsample_accession = GEO.expsample_accession)
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

