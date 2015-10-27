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
        case when hsa_flag = 'Y' then hsa_unit_id || '/' else '' end ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        case when ( house_number_2 <> '' or house_suffix_2 <> '' ) then '-' else '' end ||
        house_prefix_2 || house_number_2 || house_suffix_2 as num_address,
    ltrim ( road_name ||
        rtrim ( ' ' || road_type ) ||
        rtrim ( ' ' || road_suffix ) ) as road_name_combined
from (

select
    cast ( P.property_no as varchar ) as propnum,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when a.formatted_address like 'ABOVE %' then 'ABOVE'
        when a.formatted_address like 'BELOW %' then 'BELOW'
        when a.formatted_address like 'REAR %' then 'REAR'
        else ''
    end as location_descriptor,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when A.unit_no = '0' then ''
        else ifnull ( A.unit_no , '' )
    end as blg_unit_id_1,
    upper ( ifnull ( A.unit_no_suffix , '' ) ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when A.unit_no_to = '0' then ''
        else ifnull ( A.unit_no_to , '' )
    end as blg_unit_id_2,
    upper ( ifnull ( A.unit_no_to_suffix , '' ) ) as blg_unit_suffix_2,
    '' as floor_type,
    '' as floor_prefix_1,
    case
        when A.floor_no = '0' then ''
        else ifnull ( A.floor_no , '' )
    end as floor_no_1,
    upper ( ifnull ( A.floor_suffix , '' ) ) as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when A.floor_no_to = '0' then ''
        else ifnull ( A.floor_no_to , '' )
    end as floor_no_2,
    upper ( ifnull ( A.floor_suffix_to , '' ) ) as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as house_prefix_1,
    case
        when A.house_no = '0' then ''
        else ifnull ( A.house_no , '' )
    end as house_number_1,
    upper ( ifnull ( A.house_no_suffix , '' ) ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when A.house_no_to = '0' then ''
        else ifnull ( A.house_no_to , '' )
    end as house_number_2,
    upper ( ifnull ( A.house_no_to_suffix , '' ) ) as house_suffix_2,
    replace ( (
        case
            when upper ( S.street_name ) in ( 'THE HEIGHTS' , 'THE DENE' , 'THE PARADE' , 'THE AVENUE' , 'THE ESPLANADE' , 'THE OUTLOOK' , 'VILLA CORA' ) then upper ( S.street_name )
            when upper ( substr ( S.street_name , -4 ) ) in ( ' END' , ' ROW' , ' RUN', ' KEY', ' WAY' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 4 ) )
            when upper ( substr ( S.street_name , -5 ) ) in ( ' BEND', ' BRAE', ' COVE' , ' EDGE' , ' LANE', ' LINK', ' MEWS', ' NOOK' , ' QUAY', ' RISE', ' ROAD', ' VIEW', ' WALK', ' WYND', ' RIALTO WEST' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 5 ) )
            when upper ( substr ( S.street_name , -6 ) ) in ( ' CLOSE' , ' COURT' , ' CREST' , ' DRIVE', ' GLADE', ' GREEN', ' GROVE', ' HEATH', ' PLACE', ' PLAZA', ' POINT', ' RIDGE', ' ROUND', ' SLOPE' , ' STRIP', ' TRACK', ' VISTA' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 6 ) )
            when upper ( substr ( S.street_name , -7 ) ) in ( ' ACCESS', ' ARCADE', ' AVENUE', ' CIRCLE', ' COURSE', ' DIVIDE', ' GRANGE', ' PARADE', ' SQUARE', ' STREET', ' WATERS' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 7 ) )
            when upper ( substr ( S.street_name , -8 ) ) in ( ' CIRCUIT', ' CUTTING', ' FREEWAY', ' GARDENS', ' HIGHWAY', ' RETREAT', ' TERRACE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 8 ) )
            when upper ( substr ( S.street_name , -9 ) ) in ( ' CRESCENT', ' CROSSING', ' QUADRANT' , ' WATERWAY' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 9 ) )
            when upper ( substr ( S.street_name , -10 ) ) in ( ' BOULEVARD', ' ESPLANADE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 10 ) )
            when upper ( substr ( S.street_name , -11 ) ) in ( ' BOULEVARDE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 11 ) )
            when upper ( substr ( S.street_name , -10 ) ) in ( ' ROAD EAST', ' ROAD WEST', ' WAY NORTH' , ' WAY SOUTH' , ' LANE EAST' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 10 ) )
            when upper ( substr ( S.street_name , -11 ) ) in ( ' GROVE EAST' , ' GROVE WEST', ' LANE NORTH' , ' LANE SOUTH' , ' ROAD NORTH' , ' ROAD SOUTH' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 11 ) )
            when upper ( substr ( S.street_name , -12 ) ) in ( ' CLOSE NORTH' , ' CLOSE SOUTH' , ' COURT NORTH' , ' COURT SOUTH' , ' DRIVE NORTH' , ' DRIVE SOUTH' , ' STREET EAST' , ' STREET WEST' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 12 ) )
            when upper ( substr ( S.street_name , -13 ) ) in ( ' AVENUE NORTH' , ' AVENUE SOUTH' , ' STREET NORTH' , ' STREET SOUTH' , ' PARADE NORTH' , ' PARADE SOUTH' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 13 ) )
            when upper ( substr ( S.street_name , -14 ) ) in ( ' HIGHWAY NORTH' , ' HIGHWAY SOUTH' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 14 ) )
            else upper ( S.street_name )
        end ) , '&' , 'AND' ) as road_name,
    case
        when upper ( S.street_name ) in ( 'THE HEIGHTS' , 'THE DENE' , 'THE PARADE' , 'THE AVENUE' , 'THE ESPLANADE' , 'THE OUTLOOK' , 'VILLA CORA' ) then ''
        when S.street_name like '% ARCADE%' then 'ARCADE'
        when S.street_name like '% AVENUE%' then 'AVENUE'
        when S.street_name like '% BEND%' then 'BEND'
        when S.street_name like '% BOULEVARD%' then 'BOULEVARD'
        when S.street_name like '% CIRCLE%' then 'CIRCLE'
        when S.street_name like '% CIRCUIT%' then 'CIRCUIT'
        when S.street_name like '% CLOSE%' then 'CLOSE'
        when S.street_name like '% COURT%' then 'COURT'
        when S.street_name like '% CRESCENT%' then 'CRESCENT'
        when S.street_name like '% CROSSING%' then 'CROSSING'
        when S.street_name like '% CUTTING%' then 'CUTTING'
        when S.street_name like '% DRIVE%' then 'DRIVE'
        when S.street_name like '% FREEWAY%' then 'FREEWAY'
        when S.street_name like '% GREEN%' then 'GREEN'
        when S.street_name like '% GRANGE%' then 'GRANGE'
        when S.street_name like '% GROVE%' then 'GROVE'
        when S.street_name like '% HIGHWAY%' then 'HIGHWAY'
        when S.street_name like '% LANE%' then 'LANE'
        when S.street_name like '% MEWS%' then 'MEWS'
        when S.street_name like '% PARADE%' then 'PARADE'
        when S.street_name like '% PLACE%' then 'PLACE'
        when S.street_name like '% PLAZA%' then 'PLAZA'
        when S.street_name like '% QUAY%' then 'QUAY'
        when S.street_name like '% RIDGE%' then 'RIDGE'
        when S.street_name like '% ROAD%' then 'ROAD'
        when S.street_name like '% RD%' then 'ROAD'
        when S.street_name like '% ROUND%' then 'ROUND'
        when S.street_name like '% RUN%' then 'RUN'
        when S.street_name like '% SQUARE%' then 'SQUARE'
        when S.street_name like '% STREET%' then 'STREET'
        when S.street_name like '% ST' then 'STREET'
        when S.street_name like '% ST %' then 'STREET'
        when S.street_name like '% TERRACE%' then 'TERRACE'
        when S.street_name like '% TRACK%' then 'TRACK'
        when S.street_name like '% VISTA%' then 'VISTA'
        when S.street_name like '% WALK%' then 'WALK'
        when S.street_name like '% WAY%' then 'WAY'
        when S.street_name like '% ACCESS%' then 'ACCESS'
        when S.street_name like '% RISE%' then 'RISE'
        else ''
    end as road_type,
    case
        when S.street_name like '% NORTH' then 'N'
        when S.street_name like '% SOUTH' then 'S'
        when S.street_name like '% EAST' then 'E'
        when S.street_name like '% WEST' then 'W'
        else ''
    end as road_suffix,
    L.locality_name as locality_name,
    L.postcode as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '352' as lga_code,
    '' as crefno,
    a.formatted_address as summary
from
    techone_nucproperty P
    join techone_nucaddress A on A.property_no = P.property_no
    join techone_nucstreet S on S.street_no = A.street_no
    join techone_nuclocality L on L.locality_ctr = S.locality_ctr
where
    P.status <> 'P' and
    P.property_type_desc not in ( 'LUR' , 'RoadReserv' , 'CornerSpla' , 'InactRecor' , 'Laneway' , 'PermOcc' , 'Pms Blocks' ) and
    P.rate_analysis_desc not in ( 'R FarmHous' )
)
)
)
