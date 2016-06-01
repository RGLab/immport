-- Get all files available on GEO and referenced by ImmPort
SELECT
  repository_accession AS name,
  expsample_accession
FROM
  expsample_public_repository
WHERE
  repository_name = 'GEO' AND
  STARTSWITH(repository_accession, 'GSM')
