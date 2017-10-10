 /*
 * Copyright (c) 2013-2017 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

DROP VIEW IF EXISTS immport.v_results_union;

CREATE OR REPLACE VIEW immport.v_results_union AS

SELECT
  subject_accession || '.' || SUBSTRING(study_accession,4) as subjectid,
  assay,arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id,
  CASE study_time_collected_unit
    WHEN 'Days' THEN FLOOR(study_time_collected)
    WHEN 'Hours' THEN FLOOR(study_time_collected/24)
    ELSE NULL
  END as study_day
FROM (

SELECT 'ELISA' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.elisa_result

UNION ALL

SELECT 'ELISPOT' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.elispot_result

UNION ALL

SELECT 'Flow Cytometry' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.fcs_analyzed_result

UNION ALL

SELECT 'HAI' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.hai_result

UNION ALL

SELECT 'HLA Typing' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.hla_typing_result

UNION ALL

SELECT 'KIR' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.kir_typing_result

UNION ALL

SELECT 'MBAA' AS assay,
arm_accession,biosample_accession,NULL AS expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.mbaa_result


UNION ALL

SELECT 'Neutralizing Antibody' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.neut_ab_titer_result

UNION ALL

SELECT 'PCR' AS assay,
arm_accession,biosample_accession,expsample_accession,experiment_accession,study_accession,study_time_collected,study_time_collected_unit,subject_accession,workspace_id
FROM immport.pcr_result

UNION ALL

SELECT
   CASE file_info.detail
     WHEN 'Gene expression result' THEN 'Gene Expression'
     WHEN 'CyTOF result' THEN 'CyTOF'
     ELSE 'UNKNOWN'
   END as assay,
   arm_or_cohort.arm_accession,
   biosample.biosample_accession,
   expsample_2_biosample.expsample_accession,
   expsample.experiment_accession,
   biosample.study_accession,
   biosample.study_time_collected,
   biosample.study_time_collected_unit,
   biosample.subject_accession,
   biosample.workspace_id
FROM
  immport.biosample
  JOIN immport.expsample_2_biosample ON biosample.biosample_accession = expsample_2_biosample.biosample_accession
  JOIN immport.expsample ON expsample_2_biosample.expsample_accession = expsample.expsample_accession
  JOIN immport.arm_2_subject ON biosample.subject_accession = arm_2_subject.subject_accession
  JOIN immport.arm_or_cohort ON arm_2_subject.arm_accession = arm_or_cohort.arm_accession AND biosample.study_accession = arm_or_cohort.study_accession
  JOIN (
    SELECT
      file_info.detail, expsample_2_file_info.expsample_accession
    FROM
      immport.file_info INNER JOIN immport.expsample_2_file_info ON file_info.file_info_id = expsample_2_file_info.file_info_id
    WHERE
      file_info.detail IN ('Gene expression result', 'CyTOF result')
  UNION
    SELECT
      'Gene expression result' as detail,
      expsample_accession
    FROM
      immport.expsample_public_repository
    WHERE
      repository_name = 'GEO' AND repository_accession like 'GSM%'
  ) file_info ON file_info.expsample_accession = expsample.expsample_accession
) X;


CREATE OR REPLACE VIEW immport.v_results_summary AS

  SELECT 'ELISA' AS assay, 'elisa' AS name, 'Enzyme-linked immunosorbent assay (ELISA)' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.elisa_result) _

  UNION ALL

  SELECT 'ELISPOT' AS assay, 'elispot' AS name, 'Enzyme-Linked ImmunoSpot (ELISPOT)' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.elispot_result) _

  UNION ALL

  SELECT 'Flow Cytometry' AS assay, 'fcs_analyzed_result' AS name, 'Flow cytometry analyzed results' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.fcs_analyzed_result) _

  UNION ALL

  SELECT 'HAI' AS assay, 'hai' AS name, 'Hemagglutination inhibition (HAI)' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.hai_result) _

  UNION ALL

  SELECT 'HLA Typing' AS assay, 'hla_typing' As name, 'Human leukocyte antigen (HLA) typing' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.hla_typing_result) _

  UNION ALL

  SELECT 'KIR' AS assay, 'kir_typing' AS name, 'Killer cell immunoglobulin-like receptors (KIR) typing' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.kir_typing_result) _

  UNION ALL

  SELECT 'MBAA' AS assay, 'mbaa' AS name, 'Multiplex bead array asssay' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.mbaa_result) _


  UNION ALL

  SELECT 'Neutralizing Antibody' AS assay, 'neut_ab_titer' AS name, 'Neutralizing antibody titer' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.neut_ab_titer_result) _

  UNION ALL

  SELECT 'PCR' AS assay, 'pcr' AS name, 'Polymerisation chain reaction (PCR)' AS label, study_accession
  FROM (SELECT DISTINCT study_accession FROM immport.pcr_result) _

  UNION ALL

  SELECT DISTINCT
       'Gene Expression' AS assay,
       'gene_expression_files' AS name,
       'Gene expression microarray data files' AS label,
     biosample.study_accession
  FROM
    immport.biosample
    JOIN immport.expsample_2_biosample ON biosample.biosample_accession = expsample_2_biosample.biosample_accession
  WHERE expsample_2_biosample.expsample_accession IN
  (
      SELECT expsample_2_file_info.expsample_accession
      FROM immport.expsample_2_file_info JOIN immport.file_info ON expsample_2_file_info.file_info_id = file_info.file_info_id
      WHERE
        file_info.detail IN ('Gene expression result')
    UNION
      SELECT
         expsample_public_repository.expsample_accession
      FROM
        immport.expsample_public_repository
      WHERE
        repository_name = 'GEO' AND repository_accession LIKE 'GSM%'
  )

  UNION ALL

  SELECT DISTINCT
       'FCS sample files' AS assay,
       'fcs_sample_files'  AS name,
       'FCS sample files' AS label,
     biosample.study_accession
  FROM
    immport.biosample
    JOIN immport.expsample_2_biosample ON biosample.biosample_accession = expsample_2_biosample.biosample_accession
    JOIN immport.expsample ON expsample_2_biosample.expsample_accession = expsample.expsample_accession
    JOIN immport.expsample_2_file_info ON expsample_2_biosample.expsample_accession = expsample_2_file_info.expsample_accession
    JOIN immport.file_info ON expsample_2_file_info.file_info_id = file_info.file_info_id
--    JOIN immport.arm_2_subject ON biosample.subject_accession = arm_2_subject.subject_accession
--    JOIN immport.arm_or_cohort ON arm_2_subject.arm_accession = arm_or_cohort.arm_accession AND biosample.study_accession = arm_or_cohort.study_accession
  WHERE
    file_info.name LIKE '%.fcs' AND
    file_info.detail IN ('Flow cytometry result', 'CyTOF result')

UNION ALL

  SELECT DISTINCT
       'FCS control files' AS assay,
       'fcs_control_files' AS name,
       'FCS control files' AS label,
     biosample.study_accession
  FROM
    immport.biosample
    JOIN immport.expsample_2_biosample ON biosample.biosample_accession = expsample_2_biosample.biosample_accession
    JOIN immport.expsample ON expsample_2_biosample.expsample_accession = expsample.expsample_accession
    JOIN immport.expsample_2_file_info ON expsample_2_biosample.expsample_accession = expsample_2_file_info.expsample_accession
    JOIN immport.file_info ON expsample_2_file_info.file_info_id = file_info.file_info_id
--    JOIN immport.arm_2_subject ON biosample.subject_accession = arm_2_subject.subject_accession
--    JOIN immport.arm_or_cohort ON arm_2_subject.arm_accession = arm_or_cohort.arm_accession AND biosample.study_accession = arm_or_cohort.study_accession
  WHERE
    file_info.name LIKE '%.fcs' AND
    file_info.detail = 'Flow cytometry compensation or control'
;



CREATE OR REPLACE FUNCTION immport.fn_populateDimensions() RETURNS INTEGER AS $$
BEGIN

  -- dimStudyAssay

  DELETE FROM immport.dimStudyAssay;
  INSERT INTO immport.dimStudyAssay (Study, Assay, Name, Label, CategoryLabel)
  SELECT DISTINCT
    study_accession as Study, assay, name, label,
    CASE name
      WHEN 'demographics' THEN 'Demographics'
      WHEN 'cohort_membership' THEN 'Demographics'
      WHEN 'gene_expression_files' THEN 'Raw data files'
      WHEN 'fcs_sample_files' THEN 'Raw data files'
      WHEN 'fcs_control_files' THEN 'Raw data files'
      ELSE 'Assays'
    END AS CategoryLabel
  FROM immport.v_results_summary
  WHERE study_accession IS NOT NULL;


  -- dimAssay

  DELETE FROM immport.dimAssay;
  INSERT INTO immport.dimAssay (SubjectId, Assay)
  SELECT DISTINCT
    subject_accession || '.' || SUBSTRING(study_accession,4) AS SubjectId,
    assay as Assay
  FROM immport.v_results_union
  WHERE subject_accession IS NOT NULL AND study_accession IS NOT NULL;


  -- dimDemographic

  DELETE FROM immport.dimDemographic;
  INSERT INTO immport.dimDemographic (SubjectId, Study, AgeInYears, Species, Gender, Race, Age)
  SELECT DISTINCT
    subject.subject_accession || '.' || SUBSTRING(s2s.study_accession,4) AS SubjectId,
    s2s.study_accession AS Study,
    CASE age_unit
    WHEN 'Years' THEN floor(age_reported)
      WHEN 'Weeks' THEN 0
      WHEN 'Months' THEN 0
      ELSE NULL
    END as AgeInYears,
    species As Species,
    gender AS Gender,
    coalesce(race,'Not_Specified') AS Race,
    CASE
      WHEN floor(age_reported) < 10 THEN '0-10'
      WHEN floor(age_reported) < 20 THEN '11-20'
      WHEN floor(age_reported) < 30 THEN '21-30'
      WHEN floor(age_reported) < 40 THEN '31-40'
      WHEN floor(age_reported) < 50 THEN '41-50'
      WHEN floor(age_reported) < 60 THEN '51-60'
      WHEN floor(age_reported) < 70 THEN '61-70'
      WHEN floor(age_reported) >= 70 THEN '> 70'
      ELSE 'Unknown'
    END AS Age
  FROM immport.subject INNER JOIN immport.subject_2_study s2s ON subject.subject_accession = s2s.subject_accession
    LEFT JOIN (
      SELECT a2sj.subject_accession, arm.study_accession, a2sj.age_unit, a2sj.min_subject_age as age_reported
      FROM immport.arm_2_subject a2sj INNER JOIN immport.arm_or_cohort arm ON a2sj.arm_accession = arm.arm_accession
    ) s2age ON s2age.subject_accession = s2s.subject_accession AND s2age.study_accession = s2s.study_accession;


  -- dimStudy

  DELETE FROM immport.dimStudy;

  INSERT INTO immport.dimStudy (Study, Type, Program, SortOrder)
    SELECT DISTINCT
      study.study_accession as Study,
      study.type as Type,
      P.name as Program,
      cast(substring(study.study_accession,4) as integer) as SortOrder
    FROM immport.study
      LEFT OUTER JOIN immport.contract_grant_2_study cg2s ON study.study_accession = cg2s.study_accession
      LEFT OUTER JOIN immport.contract_grant C ON cg2s.contract_grant_id = C.contract_grant_id
      LEFT OUTER JOIN immport.program P on C.program_id = P.program_id;


  -- dimStudyCondition

  DELETE FROM immport.dimStudyCondition;
  INSERT INTO immport.dimStudyCondition (Study, Condition)

      SELECT study_accession AS Study, 'Ragweed Allergy' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%ragweed%'

      UNION ALL

      SELECT study_accession AS Study, 'Atopic Dermatitis' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%atopic dermatitis%'

      UNION ALL

      SELECT study_accession AS Study, 'Clostridium difficile' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%clostridium difficile%' OR
        lower(official_title || ' ' || condition_studied) like '%c. difficile%'

      UNION ALL

      SELECT study_accession AS Study, 'Renal transplant' as Condition
      FROM immport.study
      WHERE
        (lower(official_title || ' ' || condition_studied) like '%renal%' OR
        lower(official_title || ' ' || condition_studied) like '%kidney%') AND
        lower(official_title || ' ' || condition_studied) like '%transplant%'


      UNION ALL

      SELECT study_accession AS Study, 'Arthritis' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%arthritis%'


      UNION ALL

      SELECT study_accession AS Study, 'Hepatitis C' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%hepatitis c%'

      UNION ALL

      SELECT study_accession AS Study, 'Influenza' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%flu%'

      UNION ALL

      SELECT study_accession AS Study, 'Smallpox' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%smallpox%'


      UNION ALL

      SELECT study_accession AS Study, 'Tuberculosis' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%tuberculosis%'

      UNION ALL

      SELECT study_accession AS Study, 'Lupus' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%lupus%'

      UNION ALL

      SELECT study_accession AS Study, 'West Nile virus' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%west nile%' OR
        lower(official_title || ' ' || condition_studied) like '%WNv%'

      UNION ALL

      SELECT study_accession AS Study, 'Asthma' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%asthma%'


      UNION ALL

      SELECT study_accession AS Study, 'Typhoid' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%typhoid%'

      UNION ALL

      SELECT study_accession AS Study, 'Cholera' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%cholera%'

      UNION ALL

      SELECT study_accession AS Study, 'Vasculitis' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%vasculitis%'

      UNION ALL

      SELECT study_accession AS Study, 'Diabetes' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%diabet%'

      UNION ALL

      SELECT study_accession AS Study, 'Vaccinia' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%vaccinia%'

      UNION ALL

      SELECT study_accession AS Study, 'Helicobacter pylori' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%pylori%'

      UNION ALL

      SELECT study_accession AS Study, 'Escherichia coli' as Condition
      FROM immport.study
      WHERE
        lower(official_title || ' ' || condition_studied) like '%escherichia coli%'
  ;

  INSERT INTO immport.dimStudyCondition (Study, Condition)
  SELECT study_accession AS Study, 'Other' as Condition
  FROM immport.study
  WHERE study_accession NOT IN (SELECT Study FROM immport.dimStudyCondition);



  -- dimStudyTimepoint

  DELETE FROM immport.dimStudyTimepoint;
  INSERT INTO immport.dimStudyTimepoint (Study, Timepoint, SortOrder)
   SELECT DISTINCT
    study_accession as Study,
    CASE
      WHEN study_day < 0 THEN '<0'
      WHEN study_day <= 14 THEN CAST(study_day AS VARCHAR)
      WHEN study_day < 28 THEN '15-27'
      WHEN study_day = 28 THEN '28'
      WHEN study_day < 56 THEN '29-55'
      WHEN study_day = 56 THEN '56'
      WHEN study_day > 56 THEN '>56'
      ELSE 'Unknown'
    END as Timepoint,
    CASE
      WHEN study_day < 0 THEN -1
      WHEN study_day <= 14 THEN study_day
      WHEN study_day < 28 THEN 15
      WHEN study_day = 28 THEN 28
      WHEN study_day < 56 THEN 29
      WHEN study_day = 56 THEN 56
      WHEN study_day > 56 THEN 57
      ELSE -2
    END as sortorder
  FROM immport.v_results_union
  ORDER BY study_accession, sortorder;

/*
  -- summarySubjectAssayStudy
  DELETE FROM immport.summarySubjectAssayStudy;
  INSERT INTO  immport.summarySubjectAssayStudy (subject_accession, assay, study_accession)
  SELECT DISTINCT subject_accession, assay, study_accession
  FROM immport.v_results_union
  WHERE subject_accession IS NOT NULL AND assay IS NOT NULL AND study_accession IS NOT NULL;
*/

  RETURN 1;
  END;
$$ LANGUAGE plpgsql;
