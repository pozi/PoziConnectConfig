SELECT

VMAddr.LGA_CODE AS "lga_code",
	'' AS "new_sub",
	(Select PR_PFI from TMP_VM_PROPERTY_PARCEL  where TMP_VM_PROPERTY_PARCEL.PR_PROPNUM = DiffVMProps.PR_PROPNUM) AS "property_PFI",		
	DiffVMProps.Parcel_PFI AS "parcel_PFI",
	'' AS "Address_PFI",
	DiffVMProps.SPI AS "spi",
	DiffVMProps.PC_PLANNO AS "plan_number",
	DiffVMProps.pc_lotno AS "lot_number",
	'' AS "base_propnum",
	'' AS PropNum,
	'' AS "crefno",
	'' AS "hsa_flag",
	'' AS "hsa_unit_id",
    VMAddr.su_type AS "blg_unit_type",
    '' AS "blg_unit_prefix_1",
    VMAddr.su_no_1 AS "blg_unit_id_1",
    VMAddr.su_suff_1 AS "blg_unit_suffix_1",
       '' AS "blg_unit_prefix_2",
	VMAddr.su_no_2 AS "blg_unit_id_2",
    VMAddr.su_suff_2 AS "blg_unit_suffix_2",
    VMAddr.fl_type AS "floor_type",
       '' AS "floor_prefix_1",
   VMAddr.fl_no_1 AS "floor_no_1",
   VMAddr.fl_suff_1 AS "floor_suffix_1",
   '' AS floor_prefix_2,
    '' AS floor_no_2,
    '' AS floor_suffix_2,
    '' AS building_name,
    '' AS complex_name,
    VMAddr.loc_desc AS "location_descriptor",
    '' AS house_prefix_1,
    VMAddr.house_number_1 AS "house_number_1",
    VMAddr.house_suffix_1 AS "house_suffix_1",
    '' AS house_prefix_2,
    VMAddr.house_number_2 AS "house_number_2",
    VMAddr.house_suffix_2 AS "house_suffix_2",
	'' AS access_type,
	'' AS new_road,
    VMAddr.street_name AS "road_name",
    VMAddr.street_type AS "road_type",
    VMAddr.street_suffix AS "road_suffix",
    VMAddr.locality AS "locality_name",
	'' AS "distance_related_flag",
	'' AS "is_primary",
	'' AS "easting",
	'' AS "northing",
	'' AS "datum/proj",
	'' AS "outside_property",	
	CASE
        WHEN  DiffVMProps.PR_MULTASS ='N'  THEN 'E'
		ELSE 'R'
	END AS "edit_code",
	'Incorrect Property Numbers associated to Councils SPI - Property to be retired' AS Comments 

FROM
    TMP_VM_COMPARE_DiffCouncilProps_usingSPI AS DiffVMProps 
LEFT JOIN
TMP_VM_PROPERTY_ADDRESS VMAddr ON DiffVMProps.PR_PROPNUM = VMAddr.propnum	
	