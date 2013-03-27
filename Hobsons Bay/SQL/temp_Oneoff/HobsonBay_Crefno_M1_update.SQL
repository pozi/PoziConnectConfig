-- Updates all crefnos missing in VICMAP. (Excludes SPIs with Multiple Crefnos)

SELECT distinct

  ''		AS "property_PFI",	
--	(Select PR_PFI from TMP_VM_PROPERTY_PARCEL  where TMP_VM_PROPERTY_PARCEL.parcel_spi = CouncPropPar.SPI) AS "property_PFI",		
	MissingVMProps.parcel_PFI AS "parcel_PFI",
	'' AS "multi_assess",
	'' AS "retired_propnum",
	'' AS "base_propnum",
  '' AS "propnum",
	CouncPropPar.Crefno AS "crefno",
	CouncPropPar.SPI AS "spi",
	'' AS "part_p",
	MissingVMProps.PC_PLANNO AS "plan_number",
	MissingVMProps.pc_lotno AS "lot_number",
	'' AS "allotment",
	'' AS "section_p",
	'' AS "portion",
	'' AS "block_c",
	'' AS "subdivision",
	'' AS "parish_code",
	'' AS "township_code",	
'' AS "su_type",
    '' AS su_prefix_1,
'' AS su_no_1,
'' AS su_suff_1,
    '' AS "su_prefix_2",
'' AS "su_no_2",
'' AS "su_suff_2",
'' AS "fl_type",
    '' AS fl_prefix_1,
''AS "fl_no_1",
'' AS "fl_suff_1",
   '' AS fl_prefix_2,
    '' AS fl_no_2,
    '' AS fl_suff_2,
    '' AS pr_name_1,
    '' AS pr_name_2,
--    CounAddr.loc_des AS "loc_des",
    '' AS house_prefix_1,
--    CounAddr.house_number_1 AS "house_number_1",
--    CounAddr.house_suffix_1 AS "house_suffix_1",
    '' AS house_prefix_2,
--    CounAddr.house_number_2 AS "house_number_2",
--    CounAddr.house_suffix_2 AS "house_suffix_2",
    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,
'' AS "street_name",
'' AS "street_type",
'' AS "street_suffix",
'' AS "locality",
'' AS "postcode",	

 
 'P' AS "edit_code",

	'New\Existing Council crefno to be updated in Vicmap' AS Comments

FROM 
TMP_VM_PROPERTY_PARCEL MissingVMProps 
     INNER JOIN 
     TMP_COUNCIL_PROPERTY_PARCEL CouncPropPar ON MissingVMProps.parcel_spi=CouncPropPar.SPI

where PC_CREFNO is null
and CouncPropPar.SPI not in
(
Select SPI from
(
Select SPI,count(distinct crefno) as ct_cref
from Temp_PIQA_Parcel 

GROUP BY SPI 
)
where ct_cref>1
)