SELECT [vmprop_property_mp].[PROP_PROPNUM],
  [vmadd_address].[EZI_ADDRESS],
  [vmprop_property_mp].[PROP_MULTI_ASSESSMENT],
  [Fire_Hazzards].[GEOMETRY],
  [Fire_Hazzards].[Hazzard_Ty],
  [Fire_Hazzards].[First_Insp],
  [Fire_Hazzards].[Photo]
FROM [Fire_Hazzards],
  [vmprop_property_mp]
  INNER JOIN [vmadd_address] ON [vmprop_property_mp].[PROP_PFI] =
    [vmadd_address].[PROPERTY_PFI]