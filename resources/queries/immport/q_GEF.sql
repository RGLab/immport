SELECT
  regexp_replace (file_info.name, '.CEL$', '', 'g') AS name,
  purpose,
  expsample_2_file_info.expsample_accession,
  '/_webdav/Studies/' || study_accession || '/%40files/rawdata/gene_expression/' || file_info.name AS file_link,
  study_accession
FROM
  file_info, expsample_2_file_info,
  biosample, biosample_2_expsample
WHERE
  file_info.file_info_id = expsample_2_file_info.file_info_id AND
  file_info.purpose = 'Gene expression result' AND
  biosample_2_expsample.expsample_accession = expsample_2_file_info.expsample_accession AND
  biosample.biosample_accession = biosample_2_expsample.biosample_accession
