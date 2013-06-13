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

      P.ASSESSMENT_ID  AS "propnum",
        P.Property_type AS "Property_status",

    '' AS "su_type",
    '' AS "su_prefix_1",    

CASE 
    WHEN  substr (p.HOUSE_NO_PREFIX,1,8) in ('UPSTAIRS','U/STAIRS','GR FLOOR', 'VIC ROAD','AUSTPOST','PIPELINE','GRND FL') THEN TRIM (substr (p.HOUSE_NO_PREFIX,9,(LENGTH(HOUSE_NO_PREFIX)-8)))
    WHEN  substr (p.HOUSE_NO_PREFIX,1,7) in ('CARPARK','CARAVAN','UPSTAIR','PIPELIN','GRD FLR','PT GRND','GRD/FLR') THEN TRIM (substr (p.HOUSE_NO_PREFIX,8,(LENGTH(HOUSE_NO_PREFIX)-7))) 
    WHEN  substr (p.HOUSE_NO_PREFIX,1,6) in ('GND FL','GRD FL','GRND F','PT GRN','GRD/FL','CHURCH','FROUNT') THEN TRIM (substr (p.HOUSE_NO_PREFIX,7,(LENGTH(HOUSE_NO_PREFIX)-6))) 
    WHEN  substr (p.HOUSE_NO_PREFIX,1,5) in ('SUITE','GR FL','LEVEL','GD FL','FRONT') THEN TRIM (substr (p.HOUSE_NO_PREFIX,6,(LENGTH(HOUSE_NO_PREFIX)-5))) 
    WHEN  substr (p.HOUSE_NO_PREFIX,1,4) in ('SHOP','REAR','FACT','SUTE','UPST','GD F','FRON') THEN TRIM (substr (p.HOUSE_NO_PREFIX,5,(LENGTH(HOUSE_NO_PREFIX)-4)))            
    WHEN  substr (p.HOUSE_NO_PREFIX,1,3) in ('TWR','SHP','OFF','ATM','LVL') THEN TRIM (substr (p.HOUSE_NO_PREFIX,4,(LENGTH(HOUSE_NO_PREFIX)-3)))    
    WHEN  substr (p.HOUSE_NO_PREFIX,1,2) in ('SH','LV','GN') THEN TRIM (substr (p.HOUSE_NO_PREFIX,5,(LENGTH(HOUSE_NO_PREFIX)-2)))  
    WHEN  substr (p.HOUSE_NO_PREFIX,-1,1) IN ('A','B','C','D','E','F','G','S','L','T','R') THEN substr (p.HOUSE_NO_PREFIX,1,(LENGTH(HOUSE_NO_PREFIX)-1))    
    WHEN  substr (p.HOUSE_NO_PREFIX,1,1) IN ('A','B','C','D','E','F','G','S') THEN substr (p.HOUSE_NO_PREFIX,-1,(LENGTH(HOUSE_NO_PREFIX)-1))
    WHEN  substr (p.HOUSE_NO_PREFIX,-2,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,1,(LENGTH(HOUSE_NO_PREFIX)-2))    
    WHEN  substr (p.HOUSE_NO_PREFIX,-3,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,1,(LENGTH(HOUSE_NO_PREFIX)-3))
    WHEN  substr (p.HOUSE_NO_PREFIX,-4,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,1,(LENGTH(HOUSE_NO_PREFIX)-4))
    WHEN  substr (p.HOUSE_NO_PREFIX,-5,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,1,(LENGTH(HOUSE_NO_PREFIX)-5))    
    WHEN p.HOUSE_NO_PREFIX not null THEN p.HOUSE_NO_PREFIX
 ELSE ''
END AS "su_no_1",

          
CASE
    WHEN  substr (p.HOUSE_NO_PREFIX,-1,1) IN ('A','B','C') THEN substr (p.HOUSE_NO_PREFIX,-1,(LENGTH(HOUSE_NO_PREFIX)-1))
  ELSE '' 
END  AS "su_suff_1", 
 
    '' AS "su_prefix_2",
 CASE   
    WHEN  substr (p.HOUSE_NO_PREFIX,-2,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,-1,1) 
    WHEN  substr (p.HOUSE_NO_PREFIX,-3,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,-2,2)
    WHEN  substr (p.HOUSE_NO_PREFIX,-4,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,-3,3)
    WHEN  substr (p.HOUSE_NO_PREFIX,-5,1) ='-' THEN substr (p.HOUSE_NO_PREFIX,-4,4)        
  ELSE '' 
END AS "su_no_2",
        
    
    '' AS "su_suff_2",
    '' AS "fl_type",
    '' AS "fl_prefix_1",
    '' AS "fl_no_1",
    '' AS "fl_suff_1",
    '' AS "fl_prefix_2",
    '' AS "fl_no_2",
    '' AS "fl_suff_2",

    '' AS "pr_name_1",
    '' AS "pr_name_2",
    '' AS "loc_des",

    '' AS "house_prefix_1", 
  IFNULL (CAST( P.HOUSE_NUMBER AS INTEGER),'') AS "house_number_1",
    
CASE 
    WHEN  substr (p.HOUSE_NO_SUFFIX,1) IN ('A','B','C','D','E','F','G')  THEN substr (p.HOUSE_NO_SUFFIX,1) 
 ELSE ''
END    AS "house_suffix_1",
        
'' AS "house_prefix_2",    
    
   CASE 
    WHEN  substr (p.HOUSE_NO_SUFFIX,1,1) = '-' and substr (p.HOUSE_NO_SUFFIX,-1,1) IN ('A','B','C','D','E','F','G') THEN substr (p.HOUSE_NO_SUFFIX,2,(LENGTH(HOUSE_NO_SUFFIX)-2))
    WHEN  substr (p.HOUSE_NO_SUFFIX,1,1) = '-'  THEN substr (p.HOUSE_NO_SUFFIX,2)
 ELSE '' 
END AS "house_number_2",

CASE 
    WHEN  substr (p.HOUSE_NO_SUFFIX,1,1) = '-' and substr (p.HOUSE_NO_SUFFIX,-1,1) IN ('A','B','C','D','E','F','G') THEN substr (p.HOUSE_NO_SUFFIX,-1,1)
  ELSE '' 
END AS "house_suffix_2",


    '' AS "display_prefix_1",
    '' AS "display_no_1",
    '' AS "display_suffix_1",
    '' AS "display_prefix_2",
    '' AS "display_no_2",
    '' AS "display_suffix_2",   


    CASE    
        WHEN UPPER ( SUBSTR ( S.Description , -3 ) ) IN ( ' WK' ,' PL' ,' LN' ,' LA' ,' CR' ,' DR' ,' CL' ,' ST' , ' RD' , ' GR', ' SQ', ' CT' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 3 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -4 ) ) IN ( ' AVE' ,' CCT' ,' BVD' ,' PDE' ,' RES' ,' TCE' ,' END' , ' ROW' , ' RUN', ' KEY', ' WAY' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 4 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -5 ) ) IN ( ' CRES',' PKWY',' PARK',' BEND', ' BRAE', ' COVE' , ' EDGE' , ' LANE', ' LINK', ' MEWS', ' NOOK' , ' QUAY', ' RISE', ' ROAD', ' VIEW', ' WALK', ' WYND' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 5 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -6 ) ) IN ( ' CLOSE' , ' COURT' , ' CREST' , ' DRIVE', ' GLADE', ' GROVE', ' HEATH', ' PLACE', ' PLAZA', ' POINT', ' RIDGE', ' ROUND', ' SLOPE' , ' STRIP', ' TRACK', ' VISTA' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 6 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -7 ) ) IN ( ' ACCESS', ' ARCADE', ' AVENUE', ' CIRCLE', ' CRES E', ' CRES W' , ' DIVIDE', ' GRANGE', ' PARADE', ' SQUARE', ' STREET', ' WATERS' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 7 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -8 ) ) IN ( ' CIRCUIT', ' CUTTING', ' FREEWAY', ' GARDENS', ' HIGHWAY', ' RETREAT', ' TERRACE' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 8 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -9 ) ) IN ( ' QUADRANT' , ' WATERWAY' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 9 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -10 ) ) IN ( ' ROAD EAST', ' ROAD WEST', ' WAY NORTH' , ' WAY SOUTH' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 10 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -11 ) ) IN ( ' GROVE EAST', ' DRIVE EAST', ' GROVE WEST', ' LANE NORTH' , ' LANE SOUTH' , ' ROAD NORTH' , ' ROAD SOUTH' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 11 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -12 ) ) IN ( ' DRIVE NORTH',' DRIVE SOUTH',' CLOSE NORTH' , ' CLOSE SOUTH' , ' COURT NORTH' , ' COURT SOUTH' , ' STREET EAST' , ' STREET WEST' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 12 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -13 ) ) IN ( ' AVENUE NORTH' , ' AVENUE SOUTH' , ' STREET NORTH' , ' STREET SOUTH' , ' PARADE NORTH' , ' PARADE SOUTH' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 13 ) ),'-',' ')
        WHEN UPPER ( SUBSTR ( S.Description , -14 ) ) IN ( ' HIGHWAY NORTH' , ' HIGHWAY SOUTH' ) THEN REPLACE (UPPER ( SUBSTR ( S.Description , 1 , LENGTH ( S.Description ) - 14 ) ),'-',' ')
        ELSE UPPER ( S.Description )
    END AS "street_name",

    CASE
      
        WHEN S.Description LIKE '% RD%' THEN 'ROAD'

        WHEN S.Description LIKE '% ACCESS%' THEN 'ACCESS'
        WHEN S.Description LIKE '% ARCADE%' THEN 'ARCADE'
        WHEN S.Description LIKE '% AVE%' THEN 'AVENUE'
        WHEN S.Description LIKE '% BEND%' THEN 'BEND'
        WHEN S.Description LIKE '% BVD%' THEN 'BOULEVARD'
        WHEN S.Description LIKE '% BRAE%' THEN 'BRAE'
        WHEN S.Description LIKE '% CIRCLE%' THEN 'CIRCLE'
        WHEN S.Description LIKE '% CCT%' THEN 'CIRCUIT'
        WHEN S.Description LIKE '% CL%' THEN 'CLOSE'
        WHEN S.Description LIKE '% CT%' THEN 'COURT'
        WHEN S.Description LIKE '% COVE%' THEN 'COVE'
        WHEN S.Description LIKE '% CR' THEN 'CRESCENT'        
        WHEN S.Description LIKE '% CRES' THEN 'CRESCENT'
        WHEN S.Description LIKE '% CREST%' THEN 'CREST'
        WHEN S.Description LIKE '% CUTTING%' THEN 'CUTTING'
        WHEN S.Description LIKE '% DIVIDE%' THEN 'DIVIDE'
        WHEN S.Description LIKE '% DR%' THEN 'DRIVE'        
        WHEN S.Description LIKE '% DRIVE%' THEN 'DRIVE'
        WHEN S.Description LIKE '% EDGE%' THEN 'EDGE'
        WHEN S.Description LIKE '% END%' THEN 'END'
        WHEN S.Description LIKE '% FREEWAY%' THEN 'FREEWAY'
        WHEN S.Description LIKE '% GARDENS%' THEN 'GARDENS'
        WHEN S.Description LIKE '% GLADES' THEN ''
        WHEN S.Description LIKE '% GLADE%' THEN 'GLADE'
        WHEN S.Description LIKE '% GRANGE%' THEN 'GRANGE'
        WHEN S.Description LIKE '% GR' THEN 'GROVE'
        WHEN S.Description LIKE '% HEATH' THEN 'HEATH'
        WHEN S.Description LIKE '% HIGHWAY%' THEN 'HIGHWAY'
        WHEN S.Description LIKE '% LANE%' THEN 'LANE'        
        WHEN S.Description LIKE '% LA%' THEN 'LANE'
        WHEN S.Description LIKE '% LN%' THEN 'LANE'
        WHEN S.Description LIKE '% LINK%' THEN 'LINK'
        WHEN S.Description LIKE '% MEWS%' THEN 'MEWS'
        WHEN S.Description LIKE '% NOOK%' THEN 'NOOK'
        WHEN S.Description LIKE '% PDE%' THEN 'PARADE'
        WHEN S.Description LIKE '% PL%' THEN 'PLACE'        
        WHEN S.Description LIKE '% PARK' THEN 'PARK'        
        WHEN S.Description LIKE '% PKWY%' THEN 'PARKWAY'
        WHEN S.Description LIKE '% PLAZA%' THEN 'PLAZA'
        WHEN S.Description LIKE '% POINT%' THEN 'POINT'
        WHEN S.Description LIKE '% QUADRANT%' THEN 'QUADRANT'
        WHEN S.Description LIKE '% QUAY' THEN 'QUAY'
        WHEN S.Description LIKE '% RETREAT%' THEN 'RETREAT'
        WHEN S.Description LIKE '% RES' THEN 'RESERVE'
        WHEN S.Description LIKE '% RIDGE%' THEN 'RIDGE'
        WHEN S.Description LIKE '% RISE%' THEN 'RISE'
        WHEN S.Description LIKE '% ROUND%' THEN 'ROUND'
        WHEN S.Description LIKE '% ROW%' THEN 'ROW'
        WHEN S.Description LIKE '% RUN%' THEN 'RUN'
        WHEN S.Description LIKE '% SQ%' THEN 'SQUARE'
        WHEN S.Description LIKE '% SLOPE%' THEN 'SLOPE'
        WHEN S.Description LIKE '% ST%' THEN 'STREET'
        WHEN S.Description LIKE '% STRIP%' THEN 'STRIP'
        WHEN S.Description LIKE '% TCE%' THEN 'TERRACE'
        WHEN S.Description LIKE '% TRACK%' THEN 'TRACK'
        WHEN S.Description LIKE '% VIEW' THEN 'VIEW'
        WHEN S.Description LIKE '% VISTA%' THEN 'VISTA'
        WHEN S.Description LIKE '% WALK%' THEN 'WALK'        
        WHEN S.Description LIKE '% WK%' THEN 'WALK'
        WHEN S.Description LIKE '% WATERS%' THEN 'WATERS'
        WHEN S.Description LIKE '% WATERWAY%' THEN 'WATERWAY'
        WHEN S.Description LIKE '% WAY%' THEN 'WAY'
        WHEN S.Description LIKE '% WYND%' THEN 'WYND'

        ELSE ''

    END AS "street_type",

    CASE
        WHEN S.Description LIKE '% NORTH' OR S.Description LIKE '% N' THEN 'N'
        WHEN S.Description LIKE '% SOUTH' OR S.Description LIKE '% S' THEN 'S'
        WHEN S.Description LIKE '% EAST' OR S.Description LIKE '% E' THEN 'E'
        WHEN S.Description LIKE '% WEST' OR S.Description LIKE '% W' THEN 'W'
        ELSE ''
    END AS "street_suffix",

    L.LOCALITY_DESC AS "locality",
    L.POSTCODE AS "postcode"


FROM
    FUJITSU_PR_assessment P
    JOIN FUJITSU_PR_street S ON P.Street_ID = S.Street_ID
    JOIN FUJITSU_PR_Locality L ON L.locality_ID = S.locality_ID

WHERE P.Rating_Zone in ('1','4','5','9')

)