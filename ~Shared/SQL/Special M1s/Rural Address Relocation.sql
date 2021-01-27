select
    vp.lga_code,
    '' as new_sub,
    vp.property_pfi as property_pfi,
    '' as parcel_pfi,
    vp.primary_address_pfi as address_pfi,
    '' as spi,
    '' as plan_number,
    '' as lot_number,
    '' as base_propnum,
    cpa.propnum,
    '' as crefno,
    hsa_flag,
    hsa_unit_id,
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
    location_descriptor,
    house_prefix_1,
    house_number_1,
    house_suffix_1,
    house_prefix_2,
    house_number_2,
    house_suffix_2,
    access_type,
    '' as new_road,
    road_name,
    road_type,
    road_suffix,
    locality_name,
    'Y' as distance_related_flag,
    'Y' as is_primary,
    '???' as easting,
    '???' as northing,
    '???' as datum_proj,
    outside_property,
    'S' as edit_code,
    'Update the address location for property ' ||
	    cpa.propnum || ' (' ||
	    cpa.ezi_address || ') ' ||
		'because council records show that the parcel ' ||
		vp.spi ||
		' on which the address is currently located is associated with property ' ||
		( select propnum from pc_council_parcel cp where cp.spi = vp.spi ) as comments,
	'=hyperlink("https://vicmap.pozi.com/?parcelpfi=' || vp.parcel_pfi || '","https://vicmap.pozi.com/?parcelpfi=' || vp.parcel_pfi || '")' as map_link
from
    pc_council_property_address cpa join
	pc_vicmap_parcel vp on vp.propnum = cpa.propnum and vp.primary_address_pfi <> ''
where
    cpa.is_primary <> 'N' and
    cpa.distance_related_flag <> 'N' and
    vp.spi not in ( select spi from pc_council_parcel cp where cp.propnum = vp.propnum ) and
    vp.spi in ( select spi from pc_council_parcel cp where cp.propnum <> vp.propnum ) and
	vp.propnum in ( select propnum from pc_vicmap_property_address vpa where vpa.distance_related_flag = 'Y' ) and
	vp.spi in ( select spi from m1 where comments like '%warning%' )
group by
    cpa.propnum
