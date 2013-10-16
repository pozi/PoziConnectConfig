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
    CASE
        WHEN auprstad.pcl_unt <> '' THEN IFNULL ( auprstad.unt_alp , '' )
        ELSE ''
    END AS su_suff_1,
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
    UPPER ( TRIM ( auprstad.str_nme ) ) AS street_name,
    CASE
        WHEN TRIM ( auprstad.str_typ ) = 'AVE' THEN 'AVENUE'
        WHEN TRIM ( auprstad.str_typ ) = 'BLVD' THEN 'BOULEVARD'
        WHEN TRIM ( auprstad.str_typ ) = 'BWAY' THEN 'BYWAY'
        WHEN TRIM ( auprstad.str_typ ) = 'CL' THEN 'CLOSE'
        WHEN TRIM ( auprstad.str_typ ) = 'CRES' THEN 'CRESCENT'
        WHEN TRIM ( auprstad.str_typ ) = 'CRT' THEN 'COURT'
        WHEN TRIM ( auprstad.str_typ ) = 'CSWY' THEN 'CAUSEWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'DR' , 'DVE' ) THEN 'DRIVE'
        WHEN TRIM ( auprstad.str_typ ) = 'GVE' THEN 'GROVE'
        WHEN TRIM ( auprstad.str_typ ) = 'HWY' THEN 'HIGHWAY'
        WHEN TRIM ( auprstad.str_typ ) = 'IS' THEN 'ISLAND'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'LANE' , 'LNST' , 'LNW' ) THEN 'LANE'
        WHEN TRIM ( auprstad.str_typ ) = 'PASS' THEN 'PASS'
        WHEN TRIM ( auprstad.str_typ ) = 'PDE' THEN 'PARADE'
        WHEN TRIM ( auprstad.str_typ ) = 'PL' THEN 'PLACE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RD' , 'RDE' , 'RDNT' , 'RDST' , 'RDW' )THEN 'ROAD'
        WHEN TRIM ( auprstad.str_typ ) = 'RISE' THEN 'RISE'
        WHEN TRIM ( auprstad.str_typ ) = 'SQ' THEN 'SQUARE'
        WHEN TRIM ( auprstad.str_typ ) = 'ST' THEN 'STREET'
        WHEN TRIM ( auprstad.str_typ ) = 'TCE' THEN 'TERRACE'
        WHEN TRIM ( auprstad.str_typ ) = 'TRK' THEN 'TRACK'
        WHEN TRIM ( auprstad.str_typ ) = 'WAY' THEN 'WAY'
        ELSE IFNULL ( auprstad.str_typ , '' )
    END AS street_type,
    CASE
        WHEN auprstad.str_typ in ( 'LNNT' , 'RDNT' , 'STNT' ) THEN 'N'
        WHEN auprstad.str_typ in ( 'LNST' , 'RDST' , 'STST' ) THEN 'S'
        WHEN auprstad.str_typ in ( 'LNE' , 'RDE' , 'STE' ) THEN 'E'
        WHEN auprstad.str_typ in ( 'LNW' , 'RDW' , 'STW' ) THEN 'W'
        WHEN auprstad.str_typ in ( 'LNX' , 'RDX' , 'STX' ) THEN 'EX'
        ELSE ''
    END AS street_suffix,
    UPPER ( TRIM ( auprstad.sbr_nme ) ) AS locality,
    '' AS postcode

FROM 
    authority_auprparc auprparc INNER JOIN
        authority_auprstad auprstad ON auprparc.pcl_num = auprstad.pcl_num

WHERE
    auprparc.pcl_flg in ( 'R' , 'P' , 'U' ) AND
    auprparc.ass_num <> 0 AND
    auprstad.seq_num = 0

)
