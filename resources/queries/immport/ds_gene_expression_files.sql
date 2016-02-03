PARAMETERS($STUDY VARCHAR DEFAULT NULL)
SELECT DISTINCT
es_name.name AS file_info_name,
purpose AS file_info_purpose,
es_name.expsample_accession,
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
FROM(
  SELECT
  name,
  IFDEFINED(purpose) AS purpose,
  expsample_accession,
  FROM
  file_info, expsample_2_file_info
  WHERE
  file_info.file_info_id = expsample_2_file_info.file_info_id AND
  file_info.purpose = 'Gene expression result'
  UNION
  SELECT
  'GEO link' AS purpose,
  repository_accession AS name,
  expsample_accession
  FROM
  expsample_public_repository
) AS es_name,
biosample, biosample_2_expsample, arm_2_subject, arm_or_cohort
WHERE
biosample.biosample_accession = biosample_2_expsample.biosample_accession AND 
biosample_2_expsample.expsample_accession = es_name.expsample_accession AND 
biosample.subject_accession = arm_2_subject.subject_accession AND 
arm_2_subject.arm_accession = arm_or_cohort.arm_accession AND 
biosample.study_accession = arm_or_cohort.study_accession
AND ($STUDY IS NULL OR $STUDY = biosample.study_accession)
