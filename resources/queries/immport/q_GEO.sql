-- Get all files available on GEO and referenced by ImmPort
SELECT
  repository_accession AS name,
  expsample_accession,
  'http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=' || repository_accession AS GEO_link
FROM
  expsample_public_repository
WHERE
  repository_name = 'GEO'
