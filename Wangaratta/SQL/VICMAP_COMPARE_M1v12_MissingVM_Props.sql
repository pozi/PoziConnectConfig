SELECT

MissingVMProps.LGA_code AS "lga_code",

CASE
      WHEN MissingVMProps.PC_Status ='A' THEN ''
	  ELSE 'Y'
	END AS "new_sub",
	
	(Select PR_PFI from TMP_VM_PROPERTY_PARCEL  where TMP_VM_PROPERTY_PARCEL.parcel_spi = MissingVMProps.SPI) AS "property_PFI",		
	MissingVMProps.Parcel_PFI AS "parcel_PFI",
	'' AS "Address_PFI",
	MissingVMProps.SPI AS "spi",
	MissingVMProps.PC_PLANNO AS "plan_number",
	MissingVMProps.pc_lotno AS "lot_number",
	'' AS "base_propnum",
	 CounAddr.propnum AS "propnum",
	MissingVMProps.Crefno AS "crefno",
	'' AS "hsa_flag",
	'' AS "hsa_unit_id",
    CounAddr.su_type AS "blg_unit_type",
    '' AS "blg_unit_prefix_1",
    CounAddr.su_no_1 AS "blg_unit_id_1",
    CounAddr.su_suff_1 AS "blg_unit_suffix_1",
    '' AS "blg_unit_prefix_2",
	CounAddr.su_no_2 AS "blg_unit_id_2",
    CounAddr.su_suff_2 AS "blg_unit_suffix_2",
    CounAddr.fl_type AS "floor_type",
    '' AS "floor_prefix_1",
   CounAddr.fl_no_1 AS "floor_no_1",
   CounAddr.fl_suff_1 AS "floor_suffix_1",
    '' AS floor_prefix_2,
    '' AS floor_no_2,
    '' AS floor_suffix_2,
    '' AS building_name,
    '' AS complex_name,
    CounAddr.loc_des AS "location_descriptor",
    '' AS house_prefix_1,
    CounAddr.house_number_1 AS "house_number_1",
    CounAddr.house_suffix_1 AS "house_suffix_1",
    '' AS house_prefix_2,
    CounAddr.house_number_2 AS "house_number_2",
    CounAddr.house_suffix_2 AS "house_suffix_2",
	'' AS access_type,
	'' AS new_road,
    CounAddr.street_name AS "road_name",
    CounAddr.street_type AS "road_type",
    CounAddr.street_suffix AS "road_suffix",
    CounAddr.locality AS "locality_name",
	'' AS "distance_related_flag",
	'' AS "is_primary",
	CASE 
		WHEN MissingVMProps.Rural_addr ='yes' THEN 'Enter X Coord'
		ELSE ''
		END AS "easting",		
	CASE 
		WHEN MissingVMProps.Rural_addr ='yes' THEN 'Enter Y Coord'
		ELSE ''
		END AS "northing",
	'' AS "datum/proj",
	'' AS "os_property",	
	
	CASE
        WHEN  MissingVMProps.MultiAssCount =1  THEN 'E'
		ELSE 'A'
	END AS "edit_code",
	'New\Existing Council property no to be updated in Vicmap' AS Comments

FROM
    TMP_VM_COMPARE_MissingVMProps_usingSPI AS MissingVMProps 
LEFT JOIN
Temp_PIQA_Address CounAddr ON MissingVMProps.PROPNUM = CounAddr.propnum	
	