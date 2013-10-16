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

SELECT DISTINCT

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
    IFNULL ( auprstad.hou_alp , '' ) AS house_suffix_1,
	'' AS house_prefix_2,
    IFNULL ( auprstad.hou_end , '' ) AS house_number_2,
    IFNULL ( auprstad.end_alp , '' ) AS house_suffix_2,
    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,
    UPPER ( auprstad.str_nme ) AS street_name,
    CASE
        WHEN auprstad.str_typ IN ( 'RD','RDN','RDS','RDE','RDW') THEN 'ROAD'
        WHEN auprstad.str_typ IN ( 'BVD' , 'BVDE' ) THEN 'BOULEVARD'
        WHEN auprstad.str_typ = 'HWY' THEN 'HIGHWAY'
        WHEN auprstad.str_typ IN ( 'CRT' , 'CT' ) THEN 'COURT'
        WHEN auprstad.str_typ = 'CRS' THEN 'CRESCENT'
        WHEN auprstad.str_typ = 'ST' THEN 'STREET'
        WHEN auprstad.str_typ IN ( 'TRK' , 'TR' ) THEN 'TRACK'
        WHEN auprstad.str_typ = 'LA' THEN 'LANE'
        WHEN auprstad.str_typ = 'RSE' THEN 'RISE'
        WHEN auprstad.str_typ IN ( 'DRV' , 'DR' ) THEN 'DRIVE'
        WHEN auprstad.str_typ IN ( 'AVE' , 'AV' ) THEN 'AVENUE'
        WHEN auprstad.str_typ = 'PL' THEN 'PLACE'
        WHEN auprstad.str_typ = 'CL' THEN 'CLOSE'
        WHEN auprstad.str_typ = 'NUL' THEN ''
        WHEN auprstad.str_typ = 'PDE' THEN 'PARADE'
        WHEN auprstad.str_typ = 'WY' THEN 'WAY'
        WHEN auprstad.str_typ = 'RND' THEN 'ROUND'
        WHEN auprstad.str_typ = 'GR' THEN 'GROVE'
        WHEN auprstad.str_typ = 'WYND' THEN 'WYND'
        WHEN auprstad.str_typ = 'HILL' THEN 'HILL'
        WHEN auprstad.str_typ = 'HTS' THEN 'HEIGHTS'
        WHEN auprstad.str_typ = 'TCE' THEN 'TERRACE'
        WHEN auprstad.str_typ = 'CH' THEN 'CHASE'
        WHEN auprstad.str_typ = 'MEW' THEN 'MEWS'
        WHEN auprstad.str_typ = 'WAY' THEN 'WAY'
        WHEN auprstad.str_typ = 'STP' THEN 'STRIP'
        ELSE auprstad.str_typ
    END AS street_type,
    CASE
        WHEN auprstad.str_typ = 'RDN' THEN 'N'
        WHEN auprstad.str_typ = 'RDS' THEN 'S'
        WHEN auprstad.str_typ = 'RDE' THEN 'E'
        WHEN auprstad.str_typ = 'RDW' THEN 'W'
        ELSE ''
    END AS street_suffix,
    UPPER ( auprstad.sbr_nme ) AS locality,
    '' AS postcode

FROM
    AUTHORITY_auprparc AS auprparc ,
    AUTHORITY_auprstad AS auprstad

WHERE
    auprparc.pcl_num = auprstad.pcl_num AND
    auprparc.pcl_flg in ( 'R' , 'P' , 'U' ) AND
    auprparc.ass_num <> 0 AND
    auprstad.seq_num = 0
)