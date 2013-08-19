select
    lga_code as lga_code,
    '' as new_sub,
    '' as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    spi as spi,
    plan_number as plan_number,
    lot_number as lot_number,
    '' as base_propnum,
    '' as propnum,
    crefno as crefno,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    '' as blg_unit_id_1,
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
    '' as house_number_1,
    '' as house_suffix_1,
    '' as house_prefix_2,
    '' as house_number_2,
    '' as house_suffix_2,
    '' as access_type,
    '' as new_road,
    '' as road_name,
    '' as road_type,
    '' as road_suffix,
    '' as locality_name,
    '' as distance_related_flag,
    '' as is_primary,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    'C' as edit_code,
    comments as comments

from (

select
    lga_code as lga_code,
    spi,
    plan_number as plan_number,
    lot_number as lot_number,
    crefno,
	'parcel ' || spi || ': replacing crefno NULL with ' || crefno || ' (propnum ' || propnum || ')' as comments
from PC_Council_Parcel
where rowid in
    ( select min(rowid)
    from PC_Council_Parcel
    where spi in ( select spi from PC_Vicmap_Parcel where crefno = '' ) and crefno <> ''    
    group by spi )
order by plan_number, lot_number
)
