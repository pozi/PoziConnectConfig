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
    CASE
        WHEN TRIM ( auprstad.str_nme ) LIKE '% RD NORTH' THEN SUBSTR ( TRIM(auprstad.str_nme) , 1 , LENGTH ( TRIM(auprstad.str_nme) ) - 9 )
        WHEN TRIM ( auprstad.str_nme ) LIKE '% RD SOUTH' THEN SUBSTR ( TRIM(auprstad.str_nme) , 1 , LENGTH ( TRIM(auprstad.str_nme) ) - 9 )
        WHEN TRIM ( auprstad.str_nme ) LIKE '% RD EAST' THEN SUBSTR ( TRIM(auprstad.str_nme) , 1 , LENGTH ( TRIM(auprstad.str_nme) ) - 8 )
        WHEN TRIM ( auprstad.str_nme ) LIKE '% RD WEST' THEN SUBSTR ( TRIM(auprstad.str_nme) , 1 , LENGTH ( TRIM(auprstad.str_nme) ) - 8 )
        ELSE UPPER ( TRIM ( auprstad.str_nme ) )
    END AS street_name,
    CASE
        WHEN TRIM ( auprstad.str_typ ) IN ( 'AV' , 'AVE' ) THEN 'AVENUE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'BEND' ) THEN 'BEND'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'BWAY' ) THEN 'BYWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'BLVD' , 'BVD' ) THEN 'BOULEVARD'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CCT' ) THEN 'CIRCUIT'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CH' ) THEN 'CHASE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CIR' ) THEN 'CIRCLE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CL' ) THEN 'CLOSE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CNR' ) THEN 'CORNER'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'COU' ) THEN 'COURSE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'COVE' ) THEN 'COVE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CRES' ) THEN 'CRESCENT'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CRSE' ) THEN 'COURSE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CRSS' ) THEN 'CROSS'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CRST' ) THEN 'CREST'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CRT' , 'CT' ) THEN 'COURT'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'CSWY' ) THEN 'CAUSEWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'DR' , 'DVE' ) THEN 'DRIVE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'ESP' ) THEN 'ESPLANADE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'FAWY' ) THEN 'FAIRWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'FWY' ) THEN 'FREEWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'GDN' ) THEN 'GARDEN'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'GDNS' ) THEN 'GARDENS'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'GLD' ) THEN 'GLADE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'GLEN' ) THEN 'GLEN'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'GRA' ) THEN 'GRANGE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'GRN' ) THEN 'GREEN'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'GR' , 'GV' , 'GVE' ) THEN 'GROVE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'HILL' ) THEN 'HILL'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'HTS' ) THEN 'HEIGHTS'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'HWY' ) THEN 'HIGHWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'IS' ) THEN 'ISLAND'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'JNC' ) THEN 'JUNCTION'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'LANE' ) THEN 'LANE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'LNK' , 'LINK' ) THEN 'LINK'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'LOOP' ) THEN 'LOOP'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'MALL' ) THEN 'MALL'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'MEWS' ) THEN 'MEWS'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'NOOK' ) THEN 'NOOK'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'OTLK' ) THEN 'OUTLOOK'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'PASS' ) THEN 'PASS'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'PDE' ) THEN 'PARADE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'PKWY' ) THEN 'PARKWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'PL' ) THEN 'PLACE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'PNT' ) THEN 'POINT'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'PROM' ) THEN 'PROMENADE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'PU' ) THEN 'PURSUIT'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RD' , 'ROAD' ) THEN 'ROAD'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RDGE' ) THEN 'RIDGE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'REST' ) THEN 'REST'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RIDE' ) THEN 'RIDE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RISE' ) THEN 'RISE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RND' ) THEN 'ROUND'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'ROW' ) THEN 'ROW'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RTT' ) THEN 'RETREAT'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'RUN' ) THEN 'RUN'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'SQ' ) THEN 'SQUARE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'ST' ) THEN 'STREET'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'TCE' ) THEN 'TERRACE'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'TRK' ) THEN 'TRACK'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'TURN' ) THEN 'TURN'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'VIEW' ) THEN 'VIEW'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'VWS' ) THEN 'VIEWS'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'VSTA' ) THEN 'VISTA'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'WALK' ) THEN 'WALK'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'WAY' ) THEN 'WAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'WKWY' ) THEN 'WALKWAY'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'WA' , 'WTRS' ) THEN 'WATERS'
        WHEN TRIM ( auprstad.str_typ ) IN ( 'WYND' ) THEN 'WYND'
        WHEN TRIM ( auprstad.str_typ ) IN ( '.' ) THEN ''
        ELSE IFNULL ( auprstad.str_typ , '' )
    END AS street_type,
    CASE
        WHEN TRIM ( auprstad.str_typ ) = '' AND TRIM ( auprstad.str_nme ) LIKE '% NORTH' THEN 'N'
        WHEN TRIM ( auprstad.str_typ ) = '' AND TRIM ( auprstad.str_nme ) LIKE '% SOUTH' THEN 'S'
        WHEN TRIM ( auprstad.str_typ ) = '' AND TRIM ( auprstad.str_nme ) LIKE '% EAST' THEN 'E'
        WHEN TRIM ( auprstad.str_typ ) = '' AND TRIM ( auprstad.str_nme ) LIKE '% WEST' THEN 'W'
        ELSE ''
    END AS street_suffix,
    UPPER ( TRIM ( auprstad.sbr_nme ) ) AS locality,
    '' AS postcode

FROM 
    AUTHORITY_auprparc auprparc INNER JOIN
        AUTHORITY_auprstad auprstad ON auprparc.pcl_num = auprstad.pcl_num

WHERE
    auprparc.pcl_flg IN ( 'R' , 'P' , 'U' ) AND
    auprparc.ass_num NOT IN ( '' , '0' ) AND
    auprstad.seq_num = 0

)
