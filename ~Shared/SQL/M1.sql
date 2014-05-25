select
    lga_code,
    new_sub,
    property_pfi,
    parcel_pfi,
    address_pfi,
    spi,
    plan_number,
    lot_number,
    case base_propnum when 0 then '' else cast ( base_propnum as varchar ) end as base_propnum,
    propnum,
    crefno,
    hsa_flag,
    hsa_unit_id,
    blg_unit_type,
    blg_unit_prefix_1,
    case blg_unit_id_1 when 0 then '' else cast ( blg_unit_id_1 as varchar ) end as blg_unit_id_1,
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
    location_descriptor,
    house_prefix_1,
    case house_number_1 when 0 then '' else cast ( house_number_1 as varchar ) end as house_number_1,
    house_suffix_1,
    house_prefix_2,
    house_number_2,
    house_suffix_2,
    access_type,
    new_road,
    road_name,
    road_type,
    road_suffix,
    locality_name,
    distance_related_flag,
    is_primary,
    easting,
    northing,
    datum_proj,
    outside_property,
    edit_code,
    comments
from
(
select * from m1_r_edits
union
select * from m1_c_edits
union
select * from m1_p_edits
union
select * from m1_a_edits
union
select * from m1_e_edits
union
select * from m1_s_edits
)
order by edit_code, plan_number, lot_number