SELECT [Lynx_vwLandParcel].[PropertyNumber],
  [Lynx_vwLandParcel].[LandParcelNumber],
  [Lynx_vwLandParcel].[Type],
  [Lynx_vwLandParcel].[Lot],
  [Lynx_vwLandParcel].[PlanNo],
  [Lynx_vwLandParcel].[CrownAllotment],
  [Lynx_vwLandParcel].[Section],
  [Lynx_vwLandParcel].[Township],
  [Lynx_vwLandParcel].[Parish],    
CASE 
WHEN [Lynx_vwLandParcel].[Type] = 'Lodged Plan' 
Then [Lynx_vwLandParcel].[Lot] || '/LP' || [Lynx_vwLandParcel].[PlanNo] 

WHEN [Lynx_vwLandParcel].[Type] = 'Title Plan' 
Then [Lynx_vwLandParcel].[Lot] || '/TP' || [Lynx_vwLandParcel].[PlanNo]
 
WHEN [Lynx_vwLandParcel].[Type] = 'Plan of Subdivision' 
Then REPLACE([Lynx_vwLandParcel].[Lot], 'Proposed-','') || '/PS' || [Lynx_vwLandParcel].[PlanNo] 

WHEN [Lynx_vwLandParcel].[Type] = 'Consolidation Plan' 
Then 'PC' || [Lynx_vwLandParcel].[PlanNo]

WHEN [Lynx_vwLandParcel].[Type] = 'Stratum Plan' 
THEN [Lynx_vwLandParcel].[Lot] || '/SP' || [Lynx_vwLandParcel].[PlanNo]

WHEN [Lynx_vwLandParcel].[Type] = 'Crown Description' and [Lynx_vwLandParcel].[Township] is null
THEN Replace([Lynx_vwLandParcel].[CrownAllotment] || '~' || [Lynx_vwLandParcel].[Section] || '/PP ' || [Lynx_vwLandParcel].[Parish], '~NO', '')

WHEN [Lynx_vwLandParcel].[Type] = 'Crown Description' and [Lynx_vwLandParcel].[Township] is not null
THEN Replace([Lynx_vwLandParcel].[CrownAllotment] || '~' || [Lynx_vwLandParcel].[Section] || '/PP ' || [Lynx_vwLandParcel].[Township] || ' ' || [Lynx_vwLandParcel].[Parish], '~NO', '')

Else '' END as SPI

FROM [Lynx_vwLandParcel]

