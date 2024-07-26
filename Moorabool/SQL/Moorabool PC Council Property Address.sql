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
    cast ( propnum as varchar ) as propnum,
    status,
    base_propnum,
    is_primary,
    distance_related_flag,
    hsa_flag,
    hsa_unit_id,
    location_descriptor,
    blg_unit_type,
    blg_unit_prefix_1,
    blg_unit_id_1,
    blg_unit_suffix_1,
    blg_unit_prefix_2,
    blg_unit_id_2,
    blg_unit_suffix_2,
    floor_type,
    floor_prefix_1,
    floor_no_1,
    floor_suffix_1,
    floor_prefix_2,
    floor_no_2,
    floor_suffix_2,
    building_name,
    complex_name,
    house_prefix_1,
    house_number_1,
    house_suffix_1,
    house_prefix_2,
    house_number_2,
    house_suffix_2,
    road_name,
    road_type,
    road_suffix,
    locality_name,
    postcode,
    access_type,
    easting,
    northing,
    datum_proj,
    outside_property,
    '350' as lga_code,
    '' as crefno,
    formatted_address as summary
from
    datascape_properties
)
)
)
