SELECT PATHWAY_lpaprti.OGC_FID AS OGC_FID,
  PATHWAY_lpaprti.GEOMETRY AS GEOMETRY,
  PATHWAY_lpaprti.tpklpaprti AS tpklpaprti,
  PATHWAY_lpaprti.u_version AS u_version,
  PATHWAY_lpaprop.tpklpaprop AS tfklpaprop,
  PATHWAY_lpaprti.tfklpatitl AS tfklpatitl,
  PATHWAY_lpaprti.tfklpadivn AS tfklpadivn,
  PATHWAY_lpaprti.status AS status,
  PATHWAY_lpaprti.createdate AS createdate,
  PATHWAY_lpaprti.removedate AS removedate,
  PATHWAY_lpaprti.prtiseq AS prtiseq
FROM PATHWAY_lpaprop
  INNER JOIN PATHWAY_lpaprti ON PATHWAY_lpaprop.tfklpaprop =
    PATHWAY_lpaprti.tfklpaprop
WHERE PATHWAY_lpaprop.tfklpaprop IS NOT NULL AND
  PATHWAY_lpaprti.status = 'C' AND PATHWAY_lpaprop.status = 'C'