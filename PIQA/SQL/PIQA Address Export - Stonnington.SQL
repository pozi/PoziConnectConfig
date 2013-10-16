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
        CASE WHEN ( su_prefix_1 || su_no_1 || su_suff_1 ) <> '' AND ( su_prefix_2 || su_no_2 || su_suff_2 )  <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_prefix_1 || su_no_1 || su_suff_1 || su_prefix_2 || su_no_2 || su_suff_2 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN ( house_prefix_2 || house_number_2 || house_suffix_2 ) <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ) AS "address_pr",
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN ( su_prefix_1 || su_no_1 || su_suff_1 ) <> '' AND ( su_prefix_2 || su_no_2 || su_suff_2 )  <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_prefix_1 || su_no_1 || su_suff_1 || su_prefix_2 || su_no_2 || su_suff_2 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN ( house_prefix_2 || house_number_2 || house_suffix_2 ) <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ||
        RTRIM ( ' ' || propnum ) ) AS "address_propnum_pr"
FROM (
SELECT
    CAST ( P.property_no AS varchar(20) ) AS "propnum",
    CASE
	    WHEN UPPER ( A.unit_desc ) = 'ATM' THEN 'ATM'
	    WHEN UPPER ( A.unit_desc ) = 'CP' THEN 'CARP'
	    WHEN UPPER ( A.unit_desc ) = 'FACTORY' THEN 'FCTY'
	    WHEN UPPER ( A.unit_desc ) = 'KIOSK' THEN 'KSK'
	    WHEN UPPER ( A.unit_desc ) = 'OFFICE' THEN 'OFFC'
	    WHEN UPPER ( A.unit_desc ) = 'RESERVE' THEN 'RESV'
	    WHEN UPPER ( A.unit_desc ) = 'ROOM' THEN 'ROOM'
	    WHEN UPPER ( A.unit_desc ) = 'SHOP' THEN 'SHOP'
	    WHEN UPPER ( A.unit_desc ) = 'SHOPS' THEN 'SHOP'
	    WHEN UPPER ( A.unit_desc ) = 'SITE' THEN 'SITE'
	    WHEN UPPER ( A.unit_desc ) = 'STALL' THEN 'STLL'
	    WHEN UPPER ( A.unit_desc ) = 'SUITE' THEN 'SE'
	    WHEN UPPER ( A.unit_desc ) = 'UNIT' THEN 'UNIT'
        ELSE ''
	END AS "su_type",
    '' AS "su_prefix_1",
    CASE WHEN A.unit_no IS NULL OR A.unit_no = '0' THEN '' ELSE A.unit_no END AS "su_no_1",
    UPPER ( IFNULL ( A.unit_no_suffix , '' ) ) AS "su_suff_1",
    '' AS "su_prefix_2",
    CASE WHEN A.unit_no_to IS NULL OR A.unit_no_to = '0' THEN '' ELSE A.unit_no_to END AS "su_no_2",
    UPPER ( IFNULL ( A.unit_no_to_suffix , '' ) ) AS "su_suff_2",
    CASE    
        WHEN UPPER ( A.floor_desc ) = 'FLOOR' THEN 'FL'        
        WHEN UPPER ( A.floor_desc ) = 'GROUND' THEN 'G'        
        WHEN UPPER ( A.floor_desc ) = 'LEVEL' THEN 'L'        
        WHEN UPPER ( A.floor_desc ) = 'MEZANINE' THEN 'M'        
        WHEN UPPER ( A.floor_desc ) = 'ROOF' THEN 'RT'        
        WHEN UPPER ( A.unit_desc ) = 'B' THEN 'B'
        WHEN UPPER ( A.unit_desc ) = 'G' THEN 'G'
        WHEN UPPER ( A.unit_desc ) = 'LG' THEN 'LG'
        WHEN UPPER ( A.unit_desc ) = 'UL' THEN 'UL'
        ELSE ''
    END AS "fl_type",
    '' AS "fl_prefix_1",
    CASE WHEN A.floor_no IS NULL OR A.floor_no = '0' THEN '' ELSE A.floor_no END AS "fl_no_1",
    UPPER ( IFNULL ( A.floor_suffix , '' ) ) AS "fl_suff_1",
    '' AS "fl_prefix_2",
    CASE WHEN A.floor_no_to IS NULL OR A.floor_no_to = '0' THEN '' ELSE A.floor_no_to END AS "fl_no_2",
    UPPER ( IFNULL ( A.floor_suffix_to , '' ) ) AS "fl_suff_2",
    '' AS "pr_name_1",
    '' AS "pr_name_2",
    CASE
	    WHEN UPPER ( A.unit_desc ) = 'FRONT' THEN 'FRONT'
	    WHEN UPPER ( A.unit_desc ) = 'REAR' THEN 'REAR'
	    WHEN UPPER ( A.floor_desc ) = 'REAR' THEN 'REAR'
        ELSE ''
	END AS "loc_des",
    '' AS "house_prefix_1",
    CASE WHEN A.house_no IS NULL OR A.house_no = '0' THEN '' ELSE A.house_no END AS "house_number_1",
    UPPER ( IFNULL ( A.house_no_suffix , '' ) ) AS "house_suffix_1",
    '' AS "house_prefix_2",
    CASE WHEN A.house_no_to IS NULL OR A.house_no_to = '0' THEN '' ELSE A.house_no_to END AS "house_number_2",
    UPPER ( IFNULL ( A.house_no_to_suffix , '' ) ) AS "house_suffix_2",
    '' AS "display_prefix_1",
    '' AS "display_no_1",
    '' AS "display_suffix_1",
    '' AS "display_prefix_2",
    '' AS "display_no_2",
    '' AS "display_suffix_2",
    CASE
        WHEN S.street_name LIKE 'THE %' THEN UPPER ( S.street_name )
        WHEN UPPER ( SUBSTR ( S.street_name , -4 ) ) IN ( ' END' , ' ROW' , ' RUN', ' KEY', ' WAY' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 4 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -5 ) ) IN ( ' BEND', ' BRAE', ' COVE' , ' EDGE' , ' GLEN', ' HILL', ' LANE', ' LINK', ' LOOP', ' MEWS', ' NOOK' , ' PASS', ' QUAY', ' RISE', ' ROAD', ' VIEW', ' WALK', ' WYND' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 5 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -6 ) ) IN ( ' AMBLE', ' CHASE', ' CLOSE' , ' COURT' , ' CREST' , ' DRIVE', ' GLADE', ' GREEN', ' GROVE', ' HEATH', ' PLACE', ' PLAZA', ' POINT', ' RIDGE', ' ROUND', ' SLOPE' , ' STRIP', ' TRACK', ' VISTA' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 6 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -7 ) ) IN ( ' ACCESS', ' ARCADE', ' AVENUE', ' BYPASS', ' CIRCLE', ' DIVIDE', ' GLADES', ' GRANGE', ' PARADE', ' SQUARE', ' STREET', ' WATERS' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 7 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -8 ) ) IN ( ' CIRCUIT', ' CUTTING', ' FREEWAY', ' GARDENS', ' GATEWAY', ' HIGHWAY', ' OUTLOOK', ' PARKWAY', ' RETREAT', ' TERRACE' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 8 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -9 ) ) IN ( ' CRESCENT', ' QUADRANT' , ' WATERWAY' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 9 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -10 ) ) IN ( ' BOULEVARD', ' CONCOURSE', ' ESPLANADE', ' PROMENADE' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 10 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -11 ) ) IN ( ' BOULEVARDE' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 11 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -9 ) ) IN ( ' ROAD EXT' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 9 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -10 ) ) IN ( ' ROAD EAST', ' ROAD WEST', ' WAY NORTH' , ' WAY SOUTH' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 10 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -11 ) ) IN ( ' DRIVE EAST' , ' DRIVE WEST', ' GROVE EAST' , ' GROVE WEST', ' LANE NORTH' , ' LANE SOUTH' , ' ROAD NORTH' , ' ROAD SOUTH', ' WALK NORTH' , ' WALK SOUTH' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 11 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -12 ) ) IN ( ' CLOSE NORTH' , ' CLOSE SOUTH' , ' COURT NORTH' , ' COURT SOUTH' , ' DRIVE NORTH' , ' DRIVE SOUTH' , ' STREET EAST' , ' STREET WEST' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 12 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -13 ) ) IN ( ' AVENUE NORTH' , ' AVENUE SOUTH' , ' STREET NORTH' , ' STREET SOUTH' , ' PARADE NORTH' , ' PARADE SOUTH' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 13 ) )
        WHEN UPPER ( SUBSTR ( S.street_name , -14 ) ) IN ( ' HIGHWAY NORTH' , ' HIGHWAY SOUTH' ) THEN UPPER ( SUBSTR ( S.street_name , 1 , LENGTH ( S.street_name ) - 14 ) )
        ELSE UPPER ( S.street_name )
    END AS "street_name",
    CASE
        WHEN S.street_name LIKE 'THE % LANE' THEN 'LANE'
        WHEN S.street_name LIKE 'THE %' THEN ''
        WHEN S.street_name LIKE '% ACCESS' THEN 'ACCESS'
        WHEN S.street_name LIKE '% AMBLE' THEN 'AMBLE'
        WHEN S.street_name LIKE '% ARCADE' THEN 'ARCADE'
        WHEN S.street_name LIKE '% AVENUE' OR S.street_name LIKE '% AVENUE %' THEN 'AVENUE'
        WHEN S.street_name LIKE '% BEND' THEN 'BEND'
        WHEN S.street_name LIKE '% BOULEVARDE' THEN 'BOULEVARDE'
        WHEN S.street_name LIKE '% BOULEVARD' THEN 'BOULEVARD'
        WHEN S.street_name LIKE '% BRAE' THEN 'BRAE'
        WHEN S.street_name LIKE '% BYPASS' THEN 'BYPASS'
        WHEN S.street_name LIKE '% CHASE' THEN 'CHASE'
        WHEN S.street_name LIKE '% CIRCLE' THEN 'CIRCLE'
        WHEN S.street_name LIKE '% CIRCUIT' THEN 'CIRCUIT'
        WHEN S.street_name LIKE '% CLOSE' THEN 'CLOSE'
        WHEN S.street_name LIKE '% CONCOURSE' THEN 'CONCOURSE'
        WHEN S.street_name LIKE '% COURT' THEN 'COURT'
        WHEN S.street_name LIKE '% CRESCENT' THEN 'CRESCENT'
        WHEN S.street_name LIKE '% CREST' THEN 'CREST'
        WHEN S.street_name LIKE '% CUTTING' THEN 'CUTTING'
        WHEN S.street_name LIKE '% DIVIDE' THEN 'DIVIDE'
        WHEN S.street_name LIKE '% DRIVE' THEN 'DRIVE'
        WHEN S.street_name LIKE '% EDGE' THEN 'EDGE'
        WHEN S.street_name LIKE '% ESPLANADE' THEN 'ESPLANADE'
        WHEN S.street_name LIKE '% FREEWAY' THEN 'FREEWAY'
        WHEN S.street_name LIKE '% GATEWAY' THEN 'GATEWAY'
        WHEN S.street_name LIKE '% GLADES' THEN 'GLADES'
        WHEN S.street_name LIKE '% GLADE' THEN 'GLADE'
        WHEN S.street_name LIKE '% GLEN' THEN 'GLEN'
        WHEN S.street_name LIKE '% GRANGE' THEN 'GRANGE'
        WHEN S.street_name LIKE '% GROVE' THEN 'GROVE'
        WHEN S.street_name LIKE '% HEATH' THEN 'HEATH'
        WHEN S.street_name LIKE '% HILL' THEN 'HILL'
        WHEN S.street_name LIKE '% HIGHWAY' THEN 'HIGHWAY'
        WHEN S.street_name LIKE '% LANE' THEN 'LANE'
        WHEN S.street_name LIKE '% LINK' THEN 'LINK'
        WHEN S.street_name LIKE '% LOOP' THEN 'LOOP'
        WHEN S.street_name LIKE '% MEWS' THEN 'MEWS'
        WHEN S.street_name LIKE '% NOOK' THEN 'NOOK'
        WHEN S.street_name LIKE '% OUTLOOK' THEN 'OUTLOOK'
        WHEN S.street_name LIKE '% PARADE' THEN 'PARADE'
        WHEN S.street_name LIKE '% PARKWAY' THEN 'PARKWAY'
        WHEN S.street_name LIKE '% PASS' THEN 'PASS'
        WHEN S.street_name LIKE '% PLACE' THEN 'PLACE'
        WHEN S.street_name LIKE '% PLAZA' THEN 'PLAZA'
        WHEN S.street_name LIKE '% PROMENADE' THEN 'PROMENADE'
        WHEN S.street_name LIKE '% QUADRANT' THEN 'QUADRANT'
        WHEN S.street_name LIKE '% QUAY' THEN 'QUAY'
        WHEN S.street_name LIKE '% RETREAT' THEN 'RETREAT'
        WHEN S.street_name LIKE '% RIDGE' THEN 'RIDGE'
        WHEN S.street_name LIKE '% RISE' THEN 'RISE'
        WHEN S.street_name LIKE '% ROUND' THEN 'ROUND'
        WHEN S.street_name LIKE '% ROAD' OR S.street_name LIKE '% ROAD %' THEN 'ROAD'
        WHEN S.street_name LIKE '% ROW' THEN 'ROW'
        WHEN S.street_name LIKE '% RUN' THEN 'RUN'
        WHEN S.street_name LIKE '% SQUARE' THEN 'SQUARE'
        WHEN S.street_name LIKE '% SLOPE' THEN 'SLOPE'
        WHEN S.street_name LIKE '% STREET' OR S.street_name LIKE '% STREET %' THEN 'STREET'
        WHEN S.street_name LIKE '% STRIP' THEN 'STRIP'
        WHEN S.street_name LIKE '% TERRACE' THEN 'TERRACE'
        WHEN S.street_name LIKE '% TRACK' THEN 'TRACK'
        WHEN S.street_name LIKE '% VIEW' THEN 'VIEW'
        WHEN S.street_name LIKE '% VISTA' THEN 'VISTA'
        WHEN S.street_name LIKE '% WALK' THEN 'WALK'
        WHEN S.street_name LIKE '% WATERS' THEN 'WATERS'
        WHEN S.street_name LIKE '% WATERWAY' THEN 'WATERWAY'
        WHEN S.street_name LIKE '% WAY' THEN 'WAY'
        WHEN S.street_name LIKE '% WYND' THEN 'WYND'
        ELSE ''
    END AS "street_type",
    CASE
        WHEN S.street_name LIKE 'THE %' THEN ''
        WHEN S.street_name LIKE '% NORTH' THEN 'N'
        WHEN S.street_name LIKE '% SOUTH' THEN 'S'
        WHEN S.street_name LIKE '% EAST' THEN 'E'
        WHEN S.street_name LIKE '% WEST' THEN 'W'
        WHEN S.street_name LIKE '% EXT' THEN 'EX'
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