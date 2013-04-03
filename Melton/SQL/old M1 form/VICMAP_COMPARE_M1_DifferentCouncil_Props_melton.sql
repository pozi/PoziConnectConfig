SELECT

			
	(Select PR_PFI from TMP_VM_PROPERTY_PARCEL   where TMP_VM_PROPERTY_PARCEL.PR_PROPNUM = DiffVMProps.PR_PROPNUM) AS "property_PFI",		
	'' AS "parcel_PFI",
	'' AS "multi_assess",
	DiffVMProps.PR_PROPNUM AS "retired_propnum",
	'' AS "base_propnum",
	'' AS PropNum,
	'' AS "crefno",
	'' AS "spi",
	'' AS "part_p",
	'' AS "plan_number",
	'' AS "lot_number",
	'' AS "allotment",
	'' AS "section_p",
	'' AS "portion",
	'' AS "block_c",
	'' AS "subdivision",
	'' AS "parish_code",
	'' AS "township_code",	
    VMAddr.su_type AS su_type,
    '' AS su_prefix_1,
    VMAddr.su_no_1 AS su_no_1,
    VMAddr.su_suff_1 AS su_suff_1,
    '' AS "su_prefix_2",
	VMAddr.su_no_2 AS "su_no_2",
    VMAddr.su_suff_2 AS su_suff_2,
    VMAddr.fl_type AS fl_type,
    '' AS fl_prefix_1,
   VMAddr.fl_no_1 AS fl_no_1,
   VMAddr.fl_suff_1 AS fl_suff_1,
   '' AS fl_prefix_2,
    '' AS fl_no_2,
    '' AS fl_suff_2,
    '' AS pr_name_1,
    '' AS pr_name_2,
    '' AS loc_des,
    '' AS house_prefix_1,
    VMAddr.house_number_1 AS house_number_1,
    VMAddr.house_suffix_1 AS house_suffix_1,
    '' AS house_prefix_2,
    VMAddr.house_number_2 AS house_number_2,
    VMAddr.house_suffix_2 AS house_suffix_2,
    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,
    VMAddr.street_name AS street_name,
    VMAddr.street_type AS street_type,
    VMAddr.street_suffix AS street_suffix,
    VMAddr.locality AS locality,
    VMAddr.postcode AS postcode,
	'' AS "dist_related_flag",
	'' AS "primary",
	'' AS "easting",
	'' AS "northing",
	'' AS "datum/proj",
	'' AS "os_property",
	
	CASE
        WHEN  DiffVMProps.PR_MULTASS ='N'  THEN 'E'
		ELSE 'R'
	END AS "edit_code",
	'Difference in Council props' AS Comments

FROM
    TMP_VM_COMPARE_DiffCouncilProps_usingSPI AS DiffVMProps 
LEFT JOIN
TMP_VM_PROPERTY_ADDRESS VMAddr ON DiffVMProps.PR_PROPNUM = VMAddr.PROPNUM
	