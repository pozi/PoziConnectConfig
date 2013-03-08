SELECT [PATHWAY_lpaprti].[OGC_FID],
  [PATHWAY_lpaprti].[GEOMETRY],
  [PATHWAY_lpaprti].[tpklpaprti],
  [PATHWAY_lpaprti].[u_version],
  [PATHWAY_lpaprop].[tfklpaprop],
  [PATHWAY_lpaprti].[tfklpatitl],
  [PATHWAY_lpaprti].[tfklpadivn],
  [PATHWAY_lpaprti].[status],
  [PATHWAY_lpaprti].[createdate],
  [PATHWAY_lpaprti].[removedate],
  [PATHWAY_lpaprti].[prtiseq]
FROM [PATHWAY_lpaprop]
  INNER JOIN [PATHWAY_lpaprti] ON [PATHWAY_lpaprop].[tfklpaprop] =
    [PATHWAY_lpaprti].[tfklpaprop]
WHERE [PATHWAY_lpaprop].[tfklpaprop] IS NOT NULL AND
  [PATHWAY_lpaprti].[status] = 'C' AND [PATHWAY_lpaprop].[status] = 'C'