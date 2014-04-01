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
    cast ( cast ( a.ASS_INTERNAL_ID as integer ) as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when a.ASS_HOUSE_NO_PREFIX like 'FACTORY%' then 'FACT'
        when a.ASS_HOUSE_NO_PREFIX like 'FLAT%' then 'FLAT'
        when a.ASS_HOUSE_NO_PREFIX like 'HALL%' then 'HALL'
        when a.ASS_HOUSE_NO_PREFIX like 'OFFICE%' then 'OFFC'
        when a.ASS_HOUSE_NO_PREFIX like 'SHED%' then 'SHED'
        when a.ASS_HOUSE_NO_PREFIX like 'SHOP%' then 'SHOP'
        when a.ASS_HOUSE_NO_PREFIX like 'SILO%' then 'SILO'
        when a.ASS_HOUSE_NO_PREFIX like 'SUITE%' then 'SE'
        when a.ASS_HOUSE_NO_PREFIX like 'UNIT%' then 'UNIT'
        else ''
    end as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when a.ASS_HOUSE_NO_PREFIX in ( 'ABOVE' , 'OFF' , '(OFF)' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then ''
        when a.ASS_HOUSE_NO_PREFIX like 'FACTORY%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 8))
        when a.ASS_HOUSE_NO_PREFIX like 'FLAT%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 5))
        when a.ASS_HOUSE_NO_PREFIX like 'HALL%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 5))
        when a.ASS_HOUSE_NO_PREFIX like 'OFFICE%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 7))
        when a.ASS_HOUSE_NO_PREFIX like 'SHED%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 5))
        when a.ASS_HOUSE_NO_PREFIX like 'SHOP%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 5))
        when a.ASS_HOUSE_NO_PREFIX like 'SILO%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 5))
        when a.ASS_HOUSE_NO_PREFIX like 'SUITE%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 6))
        when a.ASS_HOUSE_NO_PREFIX like 'UNIT%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 5))
        when upper(substr(a.ASS_HOUSE_NO_PREFIX, -1)) between 'A' and 'Z' then substr(a.ASS_HOUSE_NO_PREFIX,1,length(a.ASS_HOUSE_NO_PREFIX)-1)
        when a.ASS_HOUSE_NO_PREFIX like '%-%' then 'XXXX'
        when a.ASS_HOUSE_NO_PREFIX like '%&%' then 'XXXX'
        else ifnull ( a.ASS_HOUSE_NO_PREFIX , '' )
    end as blg_unit_id_1,
    case
        when a.ASS_HOUSE_NO_PREFIX in ( 'ABOVE' , 'OFF' , '(OFF)' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then ''
        when upper(substr(a.ASS_HOUSE_NO_PREFIX, -1)) between 'A' and 'Z' then upper(substr(a.ASS_HOUSE_NO_PREFIX, -1))
        else ''
    end as blg_unit_suffix_1,
     '' as blg_unit_prefix_2,
    case
        when a.ASS_HOUSE_NO_PREFIX like '%-%' then 'XXXX'
        when a.ASS_HOUSE_NO_PREFIX like '%&%' then 'XXXX'
        else ''
    end as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    case
        when a.ASS_HOUSE_NO_PREFIX like 'GROUND%' then 'GND'
        else ''
    end as floor_type,
    '' as floor_prefix_1,
    case
        when a.ASS_HOUSE_NO_PREFIX like 'LEVEL%' then ltrim(substr(a.ASS_HOUSE_NO_PREFIX, 6))
        else ''
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    case
        when a.ASS_HOUSE_NO_PREFIX in ( 'OFF' , '(OFF)' ) then 'OFF'
        when a.ASS_HOUSE_NO_PREFIX in ( 'ABOVE' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then a.ASS_HOUSE_NO_PREFIX
        when a.ASS_HOUSE_NO_SUFFIX in ( 'OFF' , '(OFF)' ) then 'OFF'
        when a.ASS_HOUSE_NO_SUFFIX in ( 'ABOVE' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then a.ASS_HOUSE_NO_SUFFIX
        else ''
    end as location_descriptor,
    '' as house_prefix_1,
    ifnull ( cast ( cast ( a.ASS_HOUSE_NUMBER as integer ) as varchar ) , '' ) as house_number_1,
    case
        when a.ASS_HOUSE_NO_SUFFIX like '-%' then ''
        else ifnull ( a.ASS_HOUSE_NO_SUFFIX , '' )
    end as house_suffix_1,
    '' as house_prefix_2,
    case
        when a.ASS_HOUSE_NO_SUFFIX like '-%' then substr ( a.ASS_HOUSE_NO_SUFFIX , 2 , 99 )
        when a.ASS_HOUSE_NO_SUFFIX like '&%' then substr ( a.ASS_HOUSE_NO_SUFFIX , 2 , 99 )
        else ''
    end as house_number_2,
    '' as house_suffix_2,
    replace ( trim ( case
        when s.DESCRIPTION like '% GROVE ROAD' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 5 )
        when s.DESCRIPTION like '% ROAD NORTH' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 11 )
        when s.DESCRIPTION like '% ROAD SOUTH' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 11 )
        when s.DESCRIPTION like '% ROAD EAST' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 10 )
        when s.DESCRIPTION like '% ROAD WEST' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 10 )
        when s.DESCRIPTION like '% ALLEY%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 6 )
        when s.DESCRIPTION like '% AVENUE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 7 )
        when s.DESCRIPTION like '% BOULEVARD%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 10 )
        when s.DESCRIPTION like '% CIRCUIT%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 8 )
        when s.DESCRIPTION like '% CLOSE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 6 )
        when s.DESCRIPTION like '% CRESCENT%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 9 )
        when s.DESCRIPTION like '% COURT%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 6 )
        when s.DESCRIPTION like '% DRIVE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 6 )
        when s.DESCRIPTION like '% ESPLANADE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 10 )
        when s.DESCRIPTION like '% GROVE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 6 )
        when s.DESCRIPTION like '% HWY%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 4 )
        when s.DESCRIPTION like '% HIGHWAY%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 8 )
        when s.DESCRIPTION like '% LANE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 5 )
        when s.DESCRIPTION like '% PARADE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 7 )
        when s.DESCRIPTION like '% PLACE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 6 )
        when s.DESCRIPTION like '% RD%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 3 )
        when s.DESCRIPTION like '% ROAD%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 5 )
        when s.DESCRIPTION like '% STREET%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 7 )
        when s.DESCRIPTION like '% TERRACE%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 8 )
        when s.DESCRIPTION like '% TRACK%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 6 )
        when s.DESCRIPTION like '% WALK%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 5 )
        when s.DESCRIPTION like '% WAY%' then substr ( s.DESCRIPTION , 1 , length ( s.DESCRIPTION ) - 4 )
        else s.DESCRIPTION
    end ) , '''' , '' ) as road_name,
    case
        when s.DESCRIPTION like '% ALLEY' then 'ALLEY'
        when s.DESCRIPTION like '% AVENUE' then 'AVENUE'
        when s.DESCRIPTION like '% BOULEVARD' then 'BOULEVARD'
        when s.DESCRIPTION like '% CIRCUIT' then 'CIRCUIT'
        when s.DESCRIPTION like '% CLOSE' then 'CLOSE'
        when s.DESCRIPTION like '% CRESCENT' then 'CRESCENT'
        when s.DESCRIPTION like '% COURT' then 'COURT'
        when s.DESCRIPTION like '% DRIVE' then 'DRIVE'
        when s.DESCRIPTION like '% ESPLANADE' then 'ESPLANADE'
        when s.DESCRIPTION like '% GROVE' then 'GROVE'
        when s.DESCRIPTION like '% HWY' then 'HIGHWAY'
        when s.DESCRIPTION like '% HIGHWAY' then 'HIGHWAY'
        when s.DESCRIPTION like '% LANE' then 'LANE'
        when s.DESCRIPTION like '% PARADE' then 'PARADE'
        when s.DESCRIPTION like '% PLACE' then 'PLACE'
        when s.DESCRIPTION like '% RD%' then 'ROAD'
        when s.DESCRIPTION like '% ROAD%' then 'ROAD'
        when s.DESCRIPTION like '% STREET' then 'STREET'
        when s.DESCRIPTION like '% TERRACE' then 'TERRACE'
        when s.DESCRIPTION like '% TRACK' then 'TRACK'
        when s.DESCRIPTION like '% WALK' then 'WALK'
        when s.DESCRIPTION like '% WAY' then 'WAY'
        else ''
    end as road_type,
    case
        when s.DESCRIPTION like '% NORTH' then 'N'
        when s.DESCRIPTION like '% SOUTH' then 'S'
        when s.DESCRIPTION like '% EAST' then 'E'
        when s.DESCRIPTION like '% WEST' then 'W'
        else ''
    end as road_suffix,
    a.ASS_CITY as locality_name,
    a.ASS_PCODE as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '310' as lga_code,
    '' as crefno,
    a.ASS_ADDRESS2 as summary
from
    fujitsu_pr_assessadd_view a,
    fujitsu_pr_street s,
    fujitsu_pr_assessment p
where
    a.ASS_STREET_ID = s.STREET_ID and
    p.ASS_INTERNAL_ID = a.ASS_INTERNAL_ID and
    p.DELETE_FLAG is null
)
)
)
