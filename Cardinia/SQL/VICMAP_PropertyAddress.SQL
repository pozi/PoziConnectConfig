SELECT [ad].[BLGUNTTYP] AS [su_type],
  [ad].[BUNIT_PRE1] AS [su_prefix_1],
 [ad].[BUNIT_ID1] AS [su_no_1]
, ad.[BUNIT_SUF1] AS su_suff_1
, ad.[BUNIT_PRE2] AS su_prefix_2
, [ad].[BUNIT_ID2] AS [su_no_2]
, ad.[BUNIT_SUF2] AS su_suff_2
, ad.[FLOOR_TYPE] AS fl_type
, ad.[FL_PREF1] AS fl_prefix_1
, [ad].[FLOOR_NO_1] AS [fl_no_1]
, ad.[FL_SUF1] AS fl_suff_1
, ad.[FL_PREF2] AS fl_prefix_2
, [ad].[FLOOR_NO_2] AS [fl_no_2]
, ad.[BUILDING] AS pr_name_1
, ad.[COMPLEX] AS pr_name_2
, ad.[Loc_Desc] AS loc_desc
, ad.[HSE_PREF1] AS house_prefix_1
, [ad].[HSE_NUM1] AS [house_number_1]
, ad.[HSE_SUF1] AS house_suffix_1
, ad.[HSE_PREF2] AS house_prefix_2
, [ad].[HSE_NUM2] AS [house_number_2]
, ad.[HSE_SUF2] AS house_suffix_2
, ad.[DISP_PREF1] AS display_prefix_1
, [ad].[DISP_NUM1] AS [display_no_1]
, ad.[DISP_SUF1] AS display_suffix_1
, ad.[DISP_PREF2] AS display_prefix_2
, [ad].[DISP_NUM2] AS [display_no_2],
  [ad].[DISP_SUF2] AS [display_suffix_2],
  [ad].[ROAD_NAME] AS [street_name],
  [ad].[ROAD_TYPE] AS [street_type],
  [ad].[RD_SUF] AS [street_suffix],
  [ad].[LOCALITY] AS [Locality],
  [ad].[POSTCODE] AS [Postcode],
  [ad].[PFI] AS [Ad_PFI],
  [pr].[PROP_PFI] AS [Pr_PFI],
  [pr].[PR_LGAC] AS [LGA_CODE],
  [pr].[PR_MULTASS] AS [PR_MULTASS],
  [pr].[PR_PTYPE] AS [PR_PTYPE],
  [pr].[PR_PROPNUM] AS [PROPNUM],
  [ad].[EZI_ADD] AS [EZI_ADD],
  [ad].[NUM_RD_ADD] || ' ' || [ad].[LOCALITY] AS [EZI_ADD_NO_PC],
  [ad].[GEOMETRY] AS [GEOMETRY]
FROM [DSE_VMPROP_PROPERTY] [pr]
  LEFT OUTER JOIN [DSE_VMADD_ADDRESS] [ad] ON [pr].[PROP_PFI] = [ad].[PR_PFI]
WHERE  [pr].[PR_LGAC] = 311 AND [pr].[PR_PTYPE] = 'O' AND [pr].[PV_FTYPE] IN ('5721',
  '5741', '27721', '27741') AND [ad].[IS_PRIMARY] = 'Y'
