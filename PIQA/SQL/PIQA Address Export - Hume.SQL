
SELECT
    *,
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) AS "roadnt_pr",
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) || ' ' ||
        locality AS "stjoin_pr",
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
        RTRIM ( ' ' || locality ) ) AS "address_pr",
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
        RTRIM ( ' ' || propnum ) ) AS "address_propnum_pr"

FROM (

SELECT

    CAST ( P.property_no AS varchar(20) ) AS "propnum",

    '' AS "su_type",
    '' AS "su_prefix_1",
    CASE
        WHEN A.unit_no IS NOT NULL AND A.unit_no <> 0 THEN CAST ( A.unit_no AS varchar(5) )
        ELSE ''
    END AS "su_no_1",
    UPPER ( IFNULL ( A.unit_no_suffix , '' ) ) AS "su_suff_1",
    '' AS "su_prefix_2",
    CASE
        WHEN A.unit_no_to IS NOT NULL AND A.unit_no_to <> 0 THEN CAST ( A.unit_no_to AS varchar(5) )
        ELSE ''
    END AS "su_no_2",
    UPPER ( IFNULL ( A.unit_no_to_suffix , '' ) ) AS "su_suff_2",

    UPPER ( IFNULL ( A.floor_desc , '' ) ) AS "fl_type",
    '' AS "fl_prefix_1",
    CASE
        WHEN A.floor_no IS NOT NULL AND A.floor_no <> 0 THEN CAST ( A.floor_no AS varchar(5) )
        ELSE ''
    END AS "fl_no_1",
    UPPER ( IFNULL ( A.floor_suffix , '' ) ) AS "fl_suff_1",
    '' AS "fl_prefix_2",
    CASE
        WHEN A.floor_no_to IS NOT NULL AND A.floor_no_to <> 0 THEN CAST ( A.floor_no_to AS varchar(5) )
        ELSE ''
    END AS "fl_no_2",
    UPPER ( IFNULL ( A.floor_suffix_to , '' ) ) AS "fl_suff_2",

    '' AS "pr_name_1",
    '' AS "pr_name_2",
    '' AS "loc_des",

    '' AS "house_prefix_1",
    CASE
        WHEN A.house_no IS NOT NULL AND A.house_no <> 0 THEN CAST ( A.house_no AS varchar(10) )
        ELSE ''
    END AS "house_number_1",
    UPPER ( IFNULL ( A.house_no_suffix , '' ) ) AS "house_suffix_1",
    '' AS "house_prefix_2",
    CASE
        WHEN A.house_no_to IS NOT NULL AND A.house_no_to <> 0 THEN CAST ( A.house_no_to AS varchar(10) )
        ELSE ''
    END AS "house_number_2",
    UPPER ( IFNULL ( A.house_no_to_suffix , '' ) ) AS "house_suffix_2",

    '' AS "display_prefix_1",
    '' AS "display_no_1",
    '' AS "display_suffix_1",
    '' AS "display_prefix_2",
    '' AS "display_no_2",
    '' AS "display_suffix_2",

    CASE
        WHEN UPPER ( SUBSTR ( S.street_name , -3 ) ) IN ( ' AV' , ' CH' , ' CL' , ' CT' , ' CR' , ' DR' , ' GL' , ' GR' , ' GN' , ' LN' , ' PL' , ' RD' , ' SQ' , ' ST' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 3 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -4 ) ) IN ( ' ARC' , ' AVE', ' BVD' , ' CCT' , ' CNR' , ' CON' , ' CRT' , ' FWY' , ' GLD' , ' GRN' , ' HTS' , ' HWY' , ' PDE' , ' PNT' , ' RTT' , ' RUN' , ' TCE' , ' WAY' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 4 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -5 ) ) IN ( ' BEND' , ' BLVD' , ' BOWL' , ' CRES' , ' GDNS' , ' GLEN' , ' LANE' , ' LINK' , ' LOOP' , ' MEWS' , ' NOOK' , ' PASS' , ' RISE' , ' TURN' , ' VIEW' , ' WALK' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 5 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -6 ) ) IN ( ' ALLEY' , ' CLOSE' , 'PLACE' , ' VIEWS' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 6 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -7 ) ) IN ( ' CIRCLE' , ' RETURN' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 7 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -9 ) ) IN ( ' APPROACH' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 9 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -8 ) ) IN ( ' RD EAST', ' RD WEST' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 8 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -9 ) ) IN ( ' RD NORTH', ' RD SOUTH' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 9 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -10 ) ) IN ( ' ROAD DEVN' , ' WALK EAST', ' WALK WEST' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 10 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -11 ) ) IN ( ' WALK NORTH', ' WALK SOUTH' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 11 ) )
        ELSE UPPER ( S.street_name )
    END AS "street_name",

    CASE
        WHEN S.street_name LIKE '% ALLEY' OR S.street_name LIKE '% ALLEY %' THEN 'ALLEY'
        WHEN S.street_name LIKE '% APPROACH' OR S.street_name LIKE '% APPROACH %' THEN 'APPROACH'
        WHEN S.street_name LIKE '% ARC' OR S.street_name LIKE '% ARC %' THEN 'ARCADE'
        WHEN S.street_name LIKE '% AV' OR S.street_name LIKE '% AV %' THEN 'AVENUE'
        WHEN S.street_name LIKE '% AVE' OR S.street_name LIKE '% AVE %' THEN 'AVENUE'
        WHEN S.street_name LIKE '% BEND' OR S.street_name LIKE '% BEND %' THEN 'BEND'
        WHEN S.street_name LIKE '% BLVD' OR S.street_name LIKE '% BLVD %' THEN 'BOULEVARD'
        WHEN S.street_name LIKE '% BVD' OR S.street_name LIKE '% BVD %' THEN 'BOULEVARD'
        WHEN S.street_name LIKE '% BOWL%' OR S.street_name LIKE '% BOWL %' THEN 'BOWL'
        WHEN S.street_name LIKE '% CCT' OR S.street_name LIKE '% CCT %' THEN 'CIRCUIT'
        WHEN S.street_name LIKE '% CH' OR S.street_name LIKE '% CH %' THEN 'CHASE'
        WHEN S.street_name LIKE '% CIRCLE' OR S.street_name LIKE '% CIRCLE %' THEN 'CIRCLE'
        WHEN S.street_name LIKE '% CL' OR S.street_name LIKE '% CL %' THEN 'CLOSE'
        WHEN S.street_name LIKE '% CLOSE' OR S.street_name LIKE '% CLOSE %' THEN 'CLOSE'
        WHEN S.street_name LIKE '% CNR' OR S.street_name LIKE '% CNR %' THEN 'CORNER'
        WHEN S.street_name LIKE '% CON' OR S.street_name LIKE '% CON %' THEN 'CONCOURSE'
        WHEN S.street_name LIKE '% CRT' OR S.street_name LIKE '% CRT %' THEN 'COURT'
        WHEN S.street_name LIKE '% CT' OR S.street_name LIKE '% CT %' THEN 'COURT'
        WHEN S.street_name LIKE '% CR' OR S.street_name LIKE '% CR %' THEN 'CRESCENT'
        WHEN S.street_name LIKE '% CRES' OR S.street_name LIKE '% CRES %' THEN 'CRESCENT'
        WHEN S.street_name LIKE '% DR' OR S.street_name LIKE '% DR %' THEN 'DRIVE'
        WHEN S.street_name LIKE '% FWY' OR S.street_name LIKE '% FWY %' THEN 'FREEWAY'
        WHEN S.street_name LIKE '% GDNS' OR S.street_name LIKE '% GDNS %' THEN 'GARDENS'
        WHEN S.street_name LIKE '% GL' OR S.street_name LIKE '% GL %' THEN 'GLADE'
        WHEN S.street_name LIKE '% GLD' OR S.street_name LIKE '% GLD %' THEN 'GLADE'
        WHEN S.street_name LIKE '% GLEN' OR S.street_name LIKE '% GLEN %' THEN 'GLEN'
        WHEN S.street_name LIKE '% GR' OR S.street_name LIKE '% GR %' THEN 'GROVE'
        WHEN S.street_name LIKE '% GN' OR S.street_name LIKE '% GN %' THEN 'GREEN'
        WHEN S.street_name LIKE '% GRN' OR S.street_name LIKE '% GRN %' THEN 'GREEN'
        WHEN S.street_name LIKE '% HTS' OR S.street_name LIKE '% HTS %' THEN 'HEIGHTS'
        WHEN S.street_name LIKE '% HWY' OR S.street_name LIKE '% HWY %' THEN 'HIGHWAY'
        WHEN S.street_name LIKE '% LANE' OR S.street_name LIKE '% LANE %' THEN 'LANE'
        WHEN S.street_name LIKE '% LN' OR S.street_name LIKE '% LN %' THEN 'LANE'
        WHEN S.street_name LIKE '% LINK' OR S.street_name LIKE '% LINK %' THEN 'LINK'
        WHEN S.street_name LIKE '% LOOP' OR S.street_name LIKE '% LOOP %' THEN 'LOOP'
        WHEN S.street_name LIKE '% MEWS' OR S.street_name LIKE '% MEWS %' THEN 'MEWS'
        WHEN S.street_name LIKE '% NOOK' OR S.street_name LIKE '% NOOK %' THEN 'NOOK'
        WHEN S.street_name LIKE '% PASS' OR S.street_name LIKE '% PASS %' THEN 'PASS'
        WHEN S.street_name LIKE '% PDE' OR S.street_name LIKE '% PDE %' THEN 'PARADE'
        WHEN S.street_name LIKE '% PL' OR S.street_name LIKE '% PL %' THEN 'PLACE'
        WHEN S.street_name LIKE '% PLACE' OR S.street_name LIKE '% PLACE %' THEN 'PLACE'
        WHEN S.street_name LIKE '% PNT' OR S.street_name LIKE '% PNT %' THEN 'POINT'
        WHEN S.street_name LIKE '% RD' OR S.street_name LIKE '% RD %' THEN 'ROAD'
        WHEN S.street_name LIKE '% RETURN' OR S.street_name LIKE '% RETURN %' THEN 'RETURN'
        WHEN S.street_name LIKE '% RISE' OR S.street_name LIKE '% RISE %' THEN 'RISE'
        WHEN S.street_name LIKE '% RTT' OR S.street_name LIKE '% RTT %' THEN 'RETREAT'
        WHEN S.street_name LIKE '% RUN' OR S.street_name LIKE '% RUN %' THEN 'RUN'
        WHEN S.street_name LIKE '% SQ' OR S.street_name LIKE '% SQ %' THEN 'SQUARE'
        WHEN S.street_name LIKE '% ST' OR S.street_name LIKE '% ST %' THEN 'STREET'
        WHEN S.street_name LIKE '% TCE' OR S.street_name LIKE '% TCE %' THEN 'TERRACE'
        WHEN S.street_name LIKE '% TURN' OR S.street_name LIKE '% TURN %' THEN 'TURN'
        WHEN S.street_name LIKE '% VIEW' OR S.street_name LIKE '% VIEW %' THEN 'VIEW'
        WHEN S.street_name LIKE '% VIEWS' OR S.street_name LIKE '% VIEWS %' THEN 'VIEWS'
        WHEN S.street_name LIKE '% WAY' OR S.street_name LIKE '% WAY %' THEN 'WAY'
        WHEN S.street_name LIKE '% WALK' OR S.street_name LIKE '% WALK %' THEN 'WALK'
        ELSE ''
    END AS "street_type",

    CASE
        WHEN S.street_name LIKE '% DEVN' THEN 'DV'
        WHEN S.street_name LIKE '% NORTH' THEN 'N'
        WHEN S.street_name LIKE '% SOUTH' THEN 'S'
        WHEN S.street_name LIKE '% EAST' THEN 'E'
        WHEN S.street_name LIKE '% WEST' THEN 'W'
        ELSE ''
    END AS "street_suffix",

    L.locality_name AS "locality",
    L.postcode AS "postcode"

FROM
    PROCLAIM_nucProperty P
    JOIN PROCLAIM_nucAddress A ON A.property_no = P.property_no
    JOIN PROCLAIM_nucStreet S ON S.street_no = A.street_no
    JOIN PROCLAIM_nucLocality L ON L.locality_ctr = S.locality_ctr

WHERE
    P.status IN ( 'C' , 'F' , 'c' , 'f' ) AND
    L.postcode <> '9999'

)
