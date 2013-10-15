select
    *,    
    ltrim ( num_road_address ||
        rtrim ( ' ' || locality_name ) ) as ezi_address
from (

select
    *,    
    ltrim ( road_name_combined ||
        rtrim ( ' ' || locality_name ) ) as road_locality,
    ltrim ( num_address ||
        rtrim ( ' ' || road_name_combined ) ) as num_road_address
from (

select
    *,
    blg_unit_prefix_1 || blg_unit_id_1 || blg_unit_suffix_1 ||
        case when ( blg_unit_id_2 <> '' or blg_unit_suffix_2 <> '' ) then '-' else '' end ||
        blg_unit_prefix_2 || blg_unit_id_2 || blg_unit_suffix_2 ||
        case when ( blg_unit_id_1 <> '' or blg_unit_suffix_1 <> '' ) then '/' else '' end ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        case when ( house_number_2 <> '' or house_suffix_2 <> '' ) then '-' else '' end ||
        house_prefix_2 || house_number_2 || house_suffix_2 as num_address,
    ltrim ( road_name ||
        rtrim ( ' ' || road_type ) ||
        rtrim ( ' ' || road_suffix ) ) as road_name_combined
from (

select
    P.ASSESSMENT_ID  as propnum,
    P.PROPERTY_TYPE as status,
	'' as base_propnum,
	'' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,    
    case 
        when substr (P.HOUSE_NO_PREFIX,1,8) in ('UPSTAIRS','U/STAIRS','GR FLOOR', 'VIC ROAD','AUSTPOST','PIPELINE','GRND FL') then TRIM (substr (P.HOUSE_NO_PREFIX,9,(length(HOUSE_NO_PREFIX)-8)))
        when substr (P.HOUSE_NO_PREFIX,1,7) in ('CARPARK','CARAVAN','UPSTAIR','PIPELIN','GRD FLR','PT GRND','GRD/FLR') then TRIM (substr (P.HOUSE_NO_PREFIX,8,(length(HOUSE_NO_PREFIX)-7))) 
        when substr (P.HOUSE_NO_PREFIX,1,6) in ('GND FL','GRD FL','GRND F','PT GRN','GRD/FL','CHURCH','FROUNT') then TRIM (substr (P.HOUSE_NO_PREFIX,7,(length(HOUSE_NO_PREFIX)-6))) 
        when substr (P.HOUSE_NO_PREFIX,1,5) in ('SUITE','GR FL','LEVEL','GD FL','FRONT') then TRIM (substr (P.HOUSE_NO_PREFIX,6,(length(HOUSE_NO_PREFIX)-5))) 
        when substr (P.HOUSE_NO_PREFIX,1,4) in ('SHOP','REAR','FACT','SUTE','UPST','GD F','FRON') then TRIM (substr (P.HOUSE_NO_PREFIX,5,(length(HOUSE_NO_PREFIX)-4)))            
        when substr (P.HOUSE_NO_PREFIX,1,3) in ('TWR','SHP','OFF','ATM','LVL') then TRIM (substr (P.HOUSE_NO_PREFIX,4,(length(HOUSE_NO_PREFIX)-3)))    
        when substr (P.HOUSE_NO_PREFIX,1,2) in ('SH','LV','GN') then TRIM (substr (P.HOUSE_NO_PREFIX,5,(length(HOUSE_NO_PREFIX)-2)))  
        when substr (P.HOUSE_NO_PREFIX,-1,1) in ('A','B','C','D','E','F','G','S','L','T','R') then substr (P.HOUSE_NO_PREFIX,1,(length(HOUSE_NO_PREFIX)-1))    
        when substr (P.HOUSE_NO_PREFIX,1,1) in ('A','B','C','D','E','F','G','S') then substr (P.HOUSE_NO_PREFIX,-1,(length(HOUSE_NO_PREFIX)-1))
        when substr (P.HOUSE_NO_PREFIX,-2,1) ='-' then substr (P.HOUSE_NO_PREFIX,1,(length(HOUSE_NO_PREFIX)-2))    
        when substr (P.HOUSE_NO_PREFIX,-3,1) ='-' then substr (P.HOUSE_NO_PREFIX,1,(length(HOUSE_NO_PREFIX)-3))
        when substr (P.HOUSE_NO_PREFIX,-4,1) ='-' then substr (P.HOUSE_NO_PREFIX,1,(length(HOUSE_NO_PREFIX)-4))
        when substr (P.HOUSE_NO_PREFIX,-5,1) ='-' then substr (P.HOUSE_NO_PREFIX,1,(length(HOUSE_NO_PREFIX)-5))    
        when P.HOUSE_NO_PREFIX not null then P.HOUSE_NO_PREFIX
     else ''
    end as blg_unit_id_1,
    case
        when substr (P.HOUSE_NO_PREFIX,-1,1) in ('A','B','C') then substr (P.HOUSE_NO_PREFIX,-1,(length(HOUSE_NO_PREFIX)-1))
      else '' 
    end  as blg_unit_suffix_1, 
     '' as blg_unit_prefix_2,
     case
        when substr (P.HOUSE_NO_PREFIX,-2,1) ='-' then substr (P.HOUSE_NO_PREFIX,-1,1) 
        when substr (P.HOUSE_NO_PREFIX,-3,1) ='-' then substr (P.HOUSE_NO_PREFIX,-2,2)
        when substr (P.HOUSE_NO_PREFIX,-4,1) ='-' then substr (P.HOUSE_NO_PREFIX,-3,3)
        when substr (P.HOUSE_NO_PREFIX,-5,1) ='-' then substr (P.HOUSE_NO_PREFIX,-4,4)        
      else ''
    end as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    case
	  when upper ( P.HOUSE_NO_PREFIX ) in ( 'GD FL' , 'GFL' , 'GND' , 'GND FL' , 'GR FL' , 'GR FLR' , 'GR FLOOR' , 'GRD FL' , 'GRD FLR' , 'GRND FL' ) THEN 'G'
	  else ''
    end as floor_type,
    '' as floor_prefix_1,
    '' as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    ifnull ( cast ( cast ( P.HOUSE_NUMBER as integer ) as varchar ) , '' ) as house_number_1,
    case 
        when substr (P.HOUSE_NO_SUFFIX,1) in ('A','B','C','D','E','F','G','H','I','J')  then substr (P.HOUSE_NO_SUFFIX,1) 
        else ''
    end as house_suffix_1,
    '' as house_prefix_2,    
    case 
        when substr (P.HOUSE_NO_SUFFIX,1,1) = '-' and substr (P.HOUSE_NO_SUFFIX,-1,1) in ('A','B','C','D','E','F','G') then substr (P.HOUSE_NO_SUFFIX,2,(length(HOUSE_NO_SUFFIX)-2))
        when substr (P.HOUSE_NO_SUFFIX,1,1) = '-'  then substr (P.HOUSE_NO_SUFFIX,2)
        else '' 
    end as house_number_2,
    case
        when substr (P.HOUSE_NO_SUFFIX,1,1) = '-' and substr (P.HOUSE_NO_SUFFIX,-1,1) in ('A','B','C','D','E','F','G') then substr (P.HOUSE_NO_SUFFIX,-1,1)
        else ''
    end as house_suffix_2,
    case    
        when upper ( substr ( S.Description , -3 ) ) in ( ' WK' ,' PL' ,' LN' ,' LA' ,' CR' ,' DR' ,' CL' ,' ST' , ' RD' , ' GR', ' SQ', ' CT' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 3 ) ),'-',' ')
        when upper ( substr ( S.Description , -4 ) ) in ( ' AVE' ,' CCT' ,' BVD' ,' PDE' ,' RES' ,' TCE' ,' end' , ' ROW' , ' RUN', ' KEY', ' WAY' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 4 ) ),'-',' ')
        when upper ( substr ( S.Description , -5 ) ) in ( ' CRES',' PKWY',' PARK',' Bend', ' BRAE', ' COVE' , ' EDGE' , ' LANE', ' LINK', ' MEWS', ' NOOK' , ' QUAY', ' RISE', ' ROAD', ' VIEW', ' WALK', ' WYND' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 5 ) ),'-',' ')
        when upper ( substr ( S.Description , -6 ) ) in ( ' CLOSE' , ' COURT' , ' CREST' , ' DRIVE', ' GLADE', ' GROVE', ' HEATH', ' PLACE', ' PLAZA', ' POINT', ' RIDGE', ' ROUND', ' SLOPE' , ' STRIP', ' TRACK', ' VISTA' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 6 ) ),'-',' ')
        when upper ( substr ( S.Description , -7 ) ) in ( ' ACCESS', ' ARCADE', ' AVENUE', ' CIRCLE', ' CRES E', ' CRES W' , ' DIVIDE', ' GRANGE', ' PARADE', ' SQUARE', ' STREET', ' WATERS' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 7 ) ),'-',' ')
        when upper ( substr ( S.Description , -8 ) ) in ( ' CIRCUIT', ' CUTTING', ' FREEWAY', ' GARDENS', ' HIGHWAY', ' RETREAT', ' TERRACE' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 8 ) ),'-',' ')
        when upper ( substr ( S.Description , -9 ) ) in ( ' QUADRANT' , ' WATERWAY' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 9 ) ),'-',' ')
        when upper ( substr ( S.Description , -10 ) ) in ( ' ROAD EAST', ' ROAD WEST', ' WAY NORTH' , ' WAY SOUTH' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 10 ) ),'-',' ')
        when upper ( substr ( S.Description , -11 ) ) in ( ' GROVE EAST', ' DRIVE EAST', ' GROVE WEST', ' LANE NORTH' , ' LANE SOUTH' , ' ROAD NORTH' , ' ROAD SOUTH' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 11 ) ),'-',' ')
        when upper ( substr ( S.Description , -12 ) ) in ( ' DRIVE NORTH',' DRIVE SOUTH',' CLOSE NORTH' , ' CLOSE SOUTH' , ' COURT NORTH' , ' COURT SOUTH' , ' STREET EAST' , ' STREET WEST' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 12 ) ),'-',' ')
        when upper ( substr ( S.Description , -13 ) ) in ( ' AVENUE NORTH' , ' AVENUE SOUTH' , ' STREET NORTH' , ' STREET SOUTH' , ' PARADE NORTH' , ' PARADE SOUTH' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 13 ) ),'-',' ')
        when upper ( substr ( S.Description , -14 ) ) in ( ' HIGHWAY NORTH' , ' HIGHWAY SOUTH' ) then replace ( upper ( substr ( S.Description , 1 , length ( S.Description ) - 14 ) ),'-',' ')
        else upper ( S.Description )
    end as road_name,
    case
        when S.Description like '% RD%' then 'ROAD'
        when S.Description like '% ACCESS%' then 'ACCESS'
        when S.Description like '% ARCADE%' then 'ARCADE'
        when S.Description like '% AVE%' then 'AVENUE'
        when S.Description like '% Bend%' then 'Bend'
        when S.Description like '% BVD%' then 'BOULEVARD'
        when S.Description like '% BRAE%' then 'BRAE'
        when S.Description like '% CIRCLE%' then 'CIRCLE'
        when S.Description like '% CCT%' then 'CIRCUIT'
        when S.Description like '% CL%' then 'CLOSE'
        when S.Description like '% CT%' then 'COURT'
        when S.Description like '% COVE%' then 'COVE'
        when S.Description like '% CR' then 'CRESCENT'        
        when S.Description like '% CRES' then 'CRESCENT'
        when S.Description like '% CREST%' then 'CREST'
        when S.Description like '% CUTTING%' then 'CUTTING'
        when S.Description like '% DIVIDE%' then 'DIVIDE'
        when S.Description like '% DR%' then 'DRIVE'        
        when S.Description like '% DRIVE%' then 'DRIVE'
        when S.Description like '% EDGE%' then 'EDGE'
        when S.Description like '% end%' then 'end'
        when S.Description like '% FREEWAY%' then 'FREEWAY'
        when S.Description like '% GARDENS%' then 'GARDENS'
        when S.Description like '% GLADES' then ''
        when S.Description like '% GLADE%' then 'GLADE'
        when S.Description like '% GRANGE%' then 'GRANGE'
        when S.Description like '% GR' then 'GROVE'
        when S.Description like '% HEATH' then 'HEATH'
        when S.Description like '% HIGHWAY%' then 'HIGHWAY'
        when S.Description like '% LANE%' then 'LANE'        
        when S.Description like '% LA%' then 'LANE'
        when S.Description like '% LN%' then 'LANE'
        when S.Description like '% LINK%' then 'LINK'
        when S.Description like '% MEWS%' then 'MEWS'
        when S.Description like '% NOOK%' then 'NOOK'
        when S.Description like '% PDE%' then 'PARADE'
        when S.Description like '% PL%' then 'PLACE'        
        when S.Description like '% PARK' then 'PARK'        
        when S.Description like '% PKWY%' then 'PARKWAY'
        when S.Description like '% PLAZA%' then 'PLAZA'
        when S.Description like '% POINT%' then 'POINT'
        when S.Description like '% QUADRANT%' then 'QUADRANT'
        when S.Description like '% QUAY' then 'QUAY'
        when S.Description like '% RETREAT%' then 'RETREAT'
        when S.Description like '% RES' then 'RESERVE'
        when S.Description like '% RIDGE%' then 'RIDGE'
        when S.Description like '% RISE%' then 'RISE'
        when S.Description like '% ROUND%' then 'ROUND'
        when S.Description like '% ROW%' then 'ROW'
        when S.Description like '% RUN%' then 'RUN'
        when S.Description like '% SQ%' then 'SQUARE'
        when S.Description like '% SLOPE%' then 'SLOPE'
        when S.Description like '% ST%' then 'STREET'
        when S.Description like '% STRIP%' then 'STRIP'
        when S.Description like '% TCE%' then 'TERRACE'
        when S.Description like '% TRACK%' then 'TRACK'
        when S.Description like '% VIEW' then 'VIEW'
        when S.Description like '% VISTA%' then 'VISTA'
        when S.Description like '% WALK%' then 'WALK'        
        when S.Description like '% WK%' then 'WALK'
        when S.Description like '% WATERS%' then 'WATERS'
        when S.Description like '% WATERWAY%' then 'WATERWAY'
        when S.Description like '% WAY%' then 'WAY'
        when S.Description like '% WYND%' then 'WYND'
        else ''
    end as road_type,
    case
        when S.Description like '% NORTH' OR S.Description like '% N' then 'N'
        when S.Description like '% SOUTH' OR S.Description like '% S' then 'S'
        when S.Description like '% EAST' OR S.Description like '% E' then 'E'
        when S.Description like '% WEST' OR S.Description like '% W' then 'W'
        else ''
    end as road_suffix,
    L.LOCALITY_DESC as locality_name,
    L.POSTCODE as postcode,
    '' as access_type,
    '341' as lga_code,
    '' as crefno,
    '' as summary
from
    FUJITSU_PR_assessment P
    join FUJITSU_PR_street S on P.Street_ID = S.Street_ID
    join FUJITSU_PR_Locality L on L.locality_ID = S.locality_ID
where
    P.Rating_Zone in ('1','4','5','9') and
    P.DELETE_FLAG is null
)
)
)
