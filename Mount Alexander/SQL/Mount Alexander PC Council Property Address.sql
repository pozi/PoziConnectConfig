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

select distinct
    cast ( propid as varchar ) as propnum,
    case status
        when 'A' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case proplayouttype
        when 'APARTMENT' then 'APT'
        else ''
    end as blg_unit_type,
    '' as blg_unit_prefix_1,
    unit_no as blg_unit_id_1,
    unit_no_suffix as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    unit_no_to as blg_unit_id_2,
    unit_no_to_suffix as blg_unit_suffix_2,
    floor_desc as floor_type,
    '' as floor_prefix_1,
    floor_no as floor_no_1,
    floor_suffix as floor_suffix_1,
    '' as floor_prefix_2,
    floor_no_to as floor_no_2,
    floor_suffix_to as floor_suffix_2,
    property_name as building_name,
    '' as complex_name,
    case
        when street like 'OFF %' then 'OFF'
        else ''
    end as location_descriptor,
    '' as house_prefix_1,
    house_no as house_number_1,
    house_no_suffix as house_suffix_1,
    '' as house_prefix_2,
    house_no_to as house_number_2,
    house_no_to_suffix as house_suffix_2,
    replace ( replace ( case
        when street in ( 'THE TERRACE' ) then street
        when substr ( street , -4 ) in ( ' END' , ' ROW' , ' RUN', ' KEY', ' WAY' ) then substr ( street , 1 , length ( street ) - 4 )
        when substr ( street , -5 ) in ( ' BEND', ' BRAE', ' COVE' , ' EDGE' , ' LANE', ' LINK', ' MEWS', ' NOOK' , ' QUAY', ' RISE', ' ROAD', ' VIEW', ' WALK', ' WYND' ) then substr ( street , 1 , length ( street ) - 5 )
        when substr ( street , -6 ) in ( ' CLOSE' , ' COURT' , ' CREST' , ' DRIVE', ' GLADE', ' GREEN', ' GROVE', ' HEATH', ' PLACE', ' PLAZA', ' POINT', ' ROUND', ' SLOPE' , ' STRIP', ' TRACK', ' VISTA' ) then substr ( street , 1 , length ( street ) - 6 )
        when substr ( street , -7 ) in ( ' ACCESS', ' ARCADE', ' AVENUE', ' CIRCLE', ' COURSE', ' DIVIDE', ' PARADE', ' SQUARE', ' STREET', ' WATERS' ) then substr ( street , 1 , length ( street ) - 7 )
        when substr ( street , -8 ) in ( ' CIRCUIT', ' CUTTING', ' FREEWAY', ' GARDENS', ' HIGHWAY', ' RETREAT', ' TERRACE' ) then substr ( street , 1 , length ( street ) - 8 )
        when substr ( street , -9 ) in ( ' CRESCENT', ' CROSSING', ' QUADRANT' , ' WATERWAY' ) then substr ( street , 1 , length ( street ) - 9 )
        when substr ( street , -10 ) in ( ' BOULEVARD', ' ESPLANADE' ) then substr ( street , 1 , length ( street ) - 10 )
        when substr ( street , -11 ) in ( ' BOULEVARDE' ) then substr ( street , 1 , length ( street ) - 11 )
        when substr ( street , -10 ) in ( ' ROAD EAST', ' ROAD WEST', ' WAY NORTH' , ' WAY SOUTH' , ' LANE EAST' , ' LANE WEST' ) then substr ( street , 1 , length ( street ) - 10 )
        when substr ( street , -11 ) in ( ' GROVE EAST' , ' GROVE WEST', ' LANE NORTH' , ' LANE SOUTH' , ' ROAD NORTH' , ' ROAD SOUTH' ) then substr ( street , 1 , length ( street ) - 11 )
        when substr ( street , -12 ) in ( ' CLOSE NORTH' , ' CLOSE SOUTH' , ' COURT NORTH' , ' COURT SOUTH' , ' DRIVE NORTH' , ' DRIVE SOUTH' , ' STREET EAST' , ' STREET WEST' ) then substr ( street , 1 , length ( street ) - 12 )
        when substr ( street , -13 ) in ( ' AVENUE NORTH' , ' AVENUE SOUTH' , ' STREET NORTH' , ' STREET SOUTH' , ' PARADE NORTH' , ' PARADE SOUTH' ) then substr ( street , 1 , length ( street ) - 13 )
        when substr ( street , -14 ) in ( ' HIGHWAY NORTH' , ' HIGHWAY SOUTH' ) then substr ( street , 1 , length ( street ) - 14 )
        else street
    end , 'OFF ' , '' ) , '''' , '' ) as road_name,
    case
        when street = 'THE TERRACE' then ''
        when street = 'BELL LANE TRACK' then 'TRACK'
        when street like '% ROAD%' then 'ROAD'
        when street like '% ACCESS%' then 'ACCESS'
        when street like '% ARCADE%' then 'ARCADE'
        when street like '% AVENUE%' then 'AVENUE'
        when street like '% BEND%' then 'BEND'
        when street like '% BOULEVARD%' then 'BOULEVARD'
        when street like '% CIRCLE%' then 'CIRCLE'
        when street like '% CIRCUIT%' then 'CIRCUIT'
        when street like '% CLOSE%' then 'CLOSE'
        when street like '% COURT%' then 'COURT'
        when street like '% CRESCENT%' then 'CRESCENT'
        when street like '% CROSSING%' then 'CROSSING'
        when street like '% CUTTING%' then 'CUTTING'
        when street like '% DRIVE%' then 'DRIVE'
        when street like '% ESPLANADE%' then 'ESPLANADE'
        when street like '% FREEWAY%' then 'FREEWAY'
        when street like '% GREEN%' then 'GREEN'
        when street like '% GROVE%' then 'GROVE'
        when street like '% HIGHWAY%' then 'HIGHWAY'
        when street like '% LANE%' then 'LANE'
        when street like '% MEWS%' then 'MEWS'
        when street like '% PARADE%' then 'PARADE'
        when street like '% PLACE%' then 'PLACE'
        when street like '% PLAZA%' then 'PLAZA'
        when street like '% QUAY%' then 'QUAY'
        when street like '% RISE%' then 'RISE'
        when street like '% ROUND%' then 'ROUND'
        when street like '% RUN%' then 'RUN'
        when street like '% SQUARE%' then 'SQUARE'
        when street like '% STREET%' then 'STREET'
        when street like '% TERRACE%' then 'TERRACE'
        when street like '% TRACK%' then 'TRACK'
        when street like '% VISTA%' then 'VISTA'
        when street like '% WALK%' then 'WALK'
        when street like '% WAY%' then 'WAY'
        else ''
    end as road_type,
    case
        when street like '% NORTH' then 'N'
        when street like '% SOUTH' then 'S'
        when street like '% EAST' then 'E'
        when street like '% WEST' then 'W'
        else ''
    end as road_suffix,
    '' as road_suffix,
    locality as locality_name,
    postcode as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '353' as lga_code,
    '' as crefno,
    formattedaddress as summary
from
    techone_property_address
)
)
)