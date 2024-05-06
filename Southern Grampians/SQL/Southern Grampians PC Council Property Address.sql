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
    cast ( propertyNumber as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    ifnull ( cast ( unitNumber as varchar ) , '' ) as blg_unit_id_1,
    '' as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    '' as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    '' as floor_type,
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
    ifnull ( cast ( fromStreetNumber as varchar ) , '' ) as house_number_1,
    ifnull ( cast ( fromStreetNumberSuffix as varchar ) , '' ) as house_suffix_1,
    '' as house_prefix_2,
    ifnull ( cast ( toStreetNumber as varchar ) , '' ) as house_number_2,
    ifnull ( cast ( toStreetNumberSuffix as varchar ) , '' ) as house_suffix_2,
    ifnull ( upper ( streetNameOnly ) , '' ) as road_name,
    case
        when streetType like '% N' then replace ( upper ( streetType ) , ' N' , '' )
        when streetType like '% S' then replace ( upper ( streetType ) , ' S' , '' )
        when streetType like '% E' then replace ( upper ( streetType ) , ' E' , '' )
        when streetType like '% W' then replace ( upper ( streetType ) , ' W' , '' )
        else ifnull ( upper ( streetType ) , '' )
    end as road_type,
    case
        when streetType like '% N' then 'N'
        when streetType like '% S' then 'S'
        when streetType like '% E' then 'E'
        when streetType like '% W' then 'W'
        else ''
    end as road_suffix,
    upper ( suburb ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '362' as lga_code,
    '' as crefno,
    ifnull ( formattedAddress , '' ) as summary
from
    councilwise_properties

)
)
)
