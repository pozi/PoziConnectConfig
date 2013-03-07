SELECT

			
	(Select PR_PFI from TMP_VM_PROPERTY_PARCEL  where TMP_VM_PROPERTY_PARCEL.parcel_spi = MissingVMProps.SPI) AS "property_PFI",		
	MissingVMProps.Parcel_PFI AS "parcel_PFI",
	'' AS "multi_assess",
	'' AS "retired_propnum",
	'' AS "base_propnum",
	 CounAddr.[propnum],
	'' AS "crefno",
	MissingVMProps.SPI AS "spi",
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
    CounAddr.su_type,
    '' AS su_prefix_1,
    CounAddr.su_no_1,
    CounAddr.su_suff_1,
    '' AS "su_prefix_2",
    CounAddr.su_suff_2,
    CounAddr.fl_type,
    '' AS fl_prefix_1,
   CounAddr.fl_no_1,
   CounAddr.fl_suff_1,
   '' AS fl_prefix_2,
    '' AS fl_no_2,
    '' AS fl_suff_2,
    '' AS pr_name_1,
    '' AS pr_name_2,
    CounAddr.loc_des,
    '' AS house_prefix_1,
    CounAddr.house_number_1,
    CounAddr.house_suffix_1,
    '' AS house_prefix_2,
    CounAddr.house_number_2,
    CounAddr.house_suffix_2,
    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,
    CounAddr.street_name,
    CounAddr.street_type,
    CounAddr.street_suffix,
    CounAddr.locality,
    CounAddr.postcode,	
	CASE
        WHEN  MissingVMProps.MultiAssCount =1  THEN 'E'
		ELSE 'A'
	END AS "edit_code"

FROM
    TMP_VM_COMPARE_MissingVMProps_usingSPI AS MissingVMProps 
LEFT JOIN
Temp_PIQA_Address CounAddr ON MissingVMProps.PROPNUM = CounAddr.propnum	
	