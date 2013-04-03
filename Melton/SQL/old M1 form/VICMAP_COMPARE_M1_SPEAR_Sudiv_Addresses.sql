SELECT

	'344' AS "lga_code",
	'' AS "new_sub",
	'' AS "property_PFI",		
	'' AS "parcel_PFI",
	'' AS "Address_PFI",
	SPEAR_ParcInfo.spi AS "spi",
	SPEAR_ParcInfo.plan_number AS "plan_number",
	SPEAR_ParcInfo.lot_number AS "lot_number",	
	'' AS "base_propnum",
	 CounAddr.propnum AS "propnum",
	SPEAR_ParcInfo.Crefno AS "crefno",
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
	'' AS "easting",
	'' AS "northing",
	'' AS "datum/proj",
	'' AS "outside_property",
	
	CASE
        WHEN  SPEAR_ParcInfo.MultiAssCount =1  THEN 'E'
		ELSE 'A'
	END AS "edit_code"

FROM TMP_VM_COMPARE_Council_SPEAR_Subdivisions AS SPEAR_ParcInfo
LEFT JOIN
Temp_PIQA_Address CounAddr ON SPEAR_ParcInfo.PROPNUM = CounAddr.propnum	


	