SELECT [pa].[PARCEL_PFI] AS [parcel_pfi],
  [pa].[PC_CREFNO] AS [PC_CREFNO],
  [pa].[PARCEL_SPI] AS [parcel_spi],
  [pa].[PC_PLANNO] AS [PC_PLANNO],
  [pa].[PC_LOTNO] AS [pc_lotno],
  [pa].[PC_STAT] AS [pc_status],
  [pr].[PR_LGAC] AS [LGA_code],
  [pr].[PROP_PFI] AS [Pr_PFI],
  [pr].[PR_MULTASS] AS [PR_MULTASS],
  [pr].[PR_PTYPE] AS [PR_PTYPE],
  [pr].[PV_FTYPE] AS [PV_FTYPE],
  [pr].[PR_PROPNUM] AS [PR_PROPNUM],
  [pac].[PACount] AS [VM_MultiAssCount],
  [addr].[EZI_ADD] AS [ezi_add],
  [pr].[GEOMETRY] AS [GEOMETRY],
  [prc].[VM_MultiParcCount] as [VM_MultiParcelCount]
FROM [DSE_VMPROP_PARCEL] [pa]
  INNER JOIN [DSE_VMPROP_PARCEL_PROPERTY] [papr] ON [pa].[PARCEL_PFI] =
    [papr].[PARCEL_PFI]
  INNER JOIN [DSE_VMPROP_PROPERTY] [pr] ON [papr].[PR_PFI] = [pr].[PROP_PFI]
  INNER JOIN [VM_Parcel_Count] [pac] ON [pa].[PARCEL_PFI] = [pac].[PARCEL_PFI]
  LEFT OUTER JOIN [DSE_VMADD_ADDRESS] [addr] ON [pr].[PROP_PFI] =
    [addr].[PR_PFI]
  INNER JOIN [VM_Property_Count] [prc] ON [papr].[PR_PFI] = [prc].[PR_PFI]
WHERE [pr].[PR_LGAC] = 367 AND [pr].[PR_PTYPE] = 'O'