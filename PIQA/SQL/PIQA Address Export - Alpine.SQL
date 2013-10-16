SELECT
	*,
	street_name ||
		RTRIM ( ' ' || street_type ) ||
		RTRIM ( ' ' || street_suffix ) AS roadnt_pr,
	street_name ||
		RTRIM ( ' ' || street_type ) ||
		RTRIM ( ' ' || street_suffix ) || ' ' ||
		locality AS stjoin_pr,
	LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
		CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
		su_prefix_2 || su_no_2 || su_suff_2 ||
		CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
		house_prefix_1 || house_number_1 || house_suffix_1 ||
		CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
		house_prefix_2 || house_number_2 || house_suffix_2 ||
		RTRIM ( ' ' || street_name ) ||
		RTRIM ( ' ' || street_type ) ||
		RTRIM ( ' ' || street_suffix ) ||
		RTRIM ( ' ' || locality ) ) AS address_pr,
	LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
		CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
		su_prefix_2 || su_no_2 || su_suff_2 ||
		CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
		house_prefix_1 || house_number_1 || house_suffix_1 ||
		CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
		house_prefix_2 || house_number_2 || house_suffix_2 ||
		RTRIM ( ' ' || street_name ) ||
		RTRIM ( ' ' || street_type ) ||
		RTRIM ( ' ' || street_suffix ) ||
		RTRIM ( ' ' || locality ) ||
		RTRIM ( ' ' || propnum ) ) AS address_propnum_pr

FROM (

SELECT

	auprparc.ass_num AS propnum,
	'' AS su_type,
	'' AS su_prefix_1,
	IFNULL ( auprstad.pcl_unt , '' ) AS su_no_1,
	IFNULL ( auprstad.unt_alp , '' ) AS su_suff_1,
	'' AS su_prefix_2,
	'' AS su_no_2,
	'' AS su_suff_2,
	'' AS fl_type,
	IFNULL ( auprstad.flo_pre , '' ) AS fl_prefix_1,
	IFNULL ( auprstad.flo_num , '' ) AS fl_no_1,
	'' AS fl_suff_1,
	'' AS fl_prefix_2,
	'' AS fl_no_2,
	'' AS fl_suff_2,
	'' AS pr_name_1,
	'' AS pr_name_2,
	'' AS loc_des,
	'' AS house_prefix_1,
	IFNULL ( auprstad.hou_num , '' ) AS house_number_1,
	UPPER ( IFNULL ( auprstad.hou_alp , '' ) ) AS house_suffix_1,
	'' AS house_prefix_2,
	IFNULL ( auprstad.hou_end , '' ) AS house_number_2,
	UPPER ( IFNULL ( auprstad.end_alp , '' ) ) AS house_suffix_2,
	'' AS display_prefix_1,
	'' AS display_no_1,
	'' AS display_suffix_1,
	'' AS display_prefix_2,
	'' AS display_no_2,
	'' AS display_suffix_2,
	UPPER ( auprstad.str_nme ) AS street_name,
	CASE
		WHEN UPPER ( aualrefs.ref_val ) = 'AVEE' THEN 'AVENUE' 
		WHEN UPPER ( aualrefs.ref_val ) = 'AVEN' THEN 'AVENUE'
		WHEN UPPER ( aualrefs.ref_val ) = 'AVES' THEN 'AVENUE' 
		WHEN UPPER ( aualrefs.ref_val ) = 'AVEW' THEN 'AVENUE' 
		WHEN UPPER ( aualrefs.ref_val ) = 'AVEX' THEN 'AVENUE' 
		WHEN UPPER ( aualrefs.ref_val ) = 'RDN' THEN 'ROAD' 
		WHEN UPPER ( aualrefs.ref_val ) = 'RDS' THEN 'ROAD' 
		WHEN UPPER ( aualrefs.ref_val ) = 'RDE' THEN 'ROAD' 
		WHEN UPPER ( aualrefs.ref_val ) = 'RDW' THEN 'ROAD' 
		WHEN UPPER ( aualrefs.ref_val ) = 'RDX' THEN 'ROAD' 
		WHEN UPPER ( aualrefs.ref_val ) = 'STE' THEN 'STREET' 
		WHEN UPPER ( aualrefs.ref_val ) = 'STN' THEN 'STREET'
		WHEN UPPER ( aualrefs.ref_val ) = 'STS' THEN 'STREET'
		WHEN UPPER ( aualrefs.ref_val ) = 'STW' THEN 'STREET' 
		WHEN UPPER ( aualrefs.ref_val ) = 'STX' THEN 'STREET' 
		ELSE UPPER ( IFNULL ( aualrefs.dsc_no3 , '' ) ) 
	END as street_type,
	CASE
		WHEN auprstad.str_typ in ( 'AVEN' , 'RDN' , 'STN' ) THEN 'N'
		WHEN auprstad.str_typ in ( 'AVES' , 'RDS' , 'STS' ) THEN 'S'
		WHEN auprstad.str_typ in ( 'AVEE' , 'RDE' , 'STE' ) THEN 'E'
		WHEN auprstad.str_typ in ( 'AVEW' , 'RDW' , 'STW' ) THEN 'W'
		WHEN auprstad.str_typ in ( 'AVEX' , 'RDX' , 'STX' ) THEN 'EX'
		ELSE ''
	END as street_suffix,
	UPPER ( auprstad.sbr_nme ) AS locality,
	ausrsubr.pst_cde AS postcode

FROM 
	authority_auprparc auprparc INNER JOIN
		authority_auprstad auprstad ON auprparc.pcl_num = auprstad.pcl_num INNER JOIN
		authority_ausrsubr ausrsubr ON auprstad.sbr_nme = ausrsubr.sbr_nme LEFT OUTER JOIN
		authority_aualrefs aualrefs ON auprstad.str_typ = aualrefs.ref_val AND aualrefs.ref_typ = 'str_typ'

WHERE
	auprparc.pcl_flg in ( 'R' , 'P' , 'U' ) AND
	auprparc.ass_num <> 0 AND
	auprstad.seq_num = 0 AND
	auprparc.ass_num <> ''

)
