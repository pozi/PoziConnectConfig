SELECT [Lynx_vwLandParcel].[PropertyNumber] AS [Propnum],
  [Lynx_vwLandParcel].[LandParcelNumber] AS [Crefno],
  [Lynx_vwLandParcel].[Type],
  [Lynx_vwLandParcel].[Lot],
  [Lynx_vwLandParcel].[PlanNo],
  [Lynx_vwLandParcel].[CrownAllotment],
  [Lynx_vwLandParcel].[Section],
  [Lynx_vwLandParcel].[Township],
  [Lynx_vwLandParcel].[Parish],
  CASE
    WHEN [Lynx_vwLandParcel].[Type] = 'Lodged Plan' THEN
    [Lynx_vwLandParcel].[Lot] || '\LP' || [Lynx_vwLandParcel].[PlanNo]
    WHEN [Lynx_vwLandParcel].[Type] = 'Title Plan' THEN
    [Lynx_vwLandParcel].[Lot] || '\TP' || [Lynx_vwLandParcel].[PlanNo]
    WHEN [Lynx_vwLandParcel].[Type] = 'Plan of Subdivision' THEN
    Replace([Lynx_vwLandParcel].[Lot], 'Proposed-', '') || '\PS' ||
    [Lynx_vwLandParcel].[PlanNo]
    WHEN [Lynx_vwLandParcel].[Type] = 'Consolidation Plan' THEN 'PC' ||
    [Lynx_vwLandParcel].[PlanNo]
    WHEN [Lynx_vwLandParcel].[Type] = 'Stratum Plan' THEN
    [Lynx_vwLandParcel].[Lot] || '\SP' || [Lynx_vwLandParcel].[PlanNo]
    WHEN [Lynx_vwLandParcel].[Type] = 'Crown Description' AND
    [Lynx_vwLandParcel].[Township] IS NULL THEN
    Replace([Lynx_vwLandParcel].[CrownAllotment] || '~' ||
    [Lynx_vwLandParcel].[Section] || '\PP' || [DSE_VMADMIN_PARISH].[PARISHC],
    '~NO', '')
    WHEN [Lynx_vwLandParcel].[Type] = 'Crown Description' AND
    [Lynx_vwLandParcel].[Township] IS NOT NULL THEN
    Replace([Lynx_vwLandParcel].[CrownAllotment] || '~' ||
    [Lynx_vwLandParcel].[Section] || '\PP' || [DSE_VMADMIN_TOWNSHIP].[TOWNSHIPC], '~NO', '') ELSE '' END AS [SPI],
  [DSE_VMADMIN_PARISH].[PARISHC],
  [DSE_VMADMIN_TOWNSHIP].[TOWNSHIPC]
FROM [Lynx_vwLandParcel]
  LEFT JOIN [DSE_VMADMIN_PARISH] ON UPPER([Lynx_vwLandParcel].[Parish]) =
    [DSE_VMADMIN_PARISH].[PARISH]
  LEFT JOIN [DSE_VMADMIN_TOWNSHIP] ON UPPER([Lynx_vwLandParcel].[Township]) =
    REPLACE([DSE_VMADMIN_TOWNSHIP].[TOWNSHIP], ' TP','')
WHERE [Lynx_vwLandParcel].[Status] = 'Active' AND [Lynx_vwLandParcel].[Ended] IS NULL
