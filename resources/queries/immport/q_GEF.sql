-- Get all files made available by immport
SELECT
  regexp_replace (file_info.name, '.CEL$', '', 'g') AS name,
  file_info.name AS file_info_name,
  file_info.filesize_bytes as filesize,
  purpose,
  expsample_2_file_info.expsample_accession
FROM
  file_info, expsample_2_file_info
WHERE
  file_info.file_info_id = expsample_2_file_info.file_info_id AND
  file_info.purpose = 'Gene expression result'
