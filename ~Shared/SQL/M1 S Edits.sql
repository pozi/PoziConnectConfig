select
    council_address.lga_code as lga_code,
    '' as new_sub,
    '' as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    '' as spi,
    '' as plan_number,
    '' as lot_number,
    '' as base_propnum,
    council_address.propnum as propnum,
    '' as crefno,
    council_address.hsa_flag as hsa_flag,
    council_address.hsa_unit_id as hsa_unit_id,
    council_address.blg_unit_type as blg_unit_type,
    council_address.blg_unit_prefix_1 as blg_unit_prefix_1,
    council_address.blg_unit_id_1 as blg_unit_id_1,
    council_address.blg_unit_suffix_1 as blg_unit_suffix_1,
    council_address.blg_unit_prefix_2 as blg_unit_prefix_2,
    council_address.blg_unit_id_2 as blg_unit_id_2,
    council_address.blg_unit_suffix_2 as blg_unit_suffix_2,
    council_address.floor_type as floor_type,
    council_address.floor_prefix_1 as floor_prefix_1,
    council_address.floor_no_1 as floor_no_1,
    council_address.floor_suffix_1 as floor_suffix_1,
    council_address.floor_prefix_2 as floor_prefix_2,
    council_address.floor_no_2 as floor_no_2,
    council_address.floor_suffix_2 as floor_suffix_2,
    council_address.building_name as building_name,
    council_address.complex_name as complex_name,
    council_address.location_descriptor as location_descriptor,
    council_address.house_prefix_1 as house_prefix_1,
    council_address.house_number_1 as house_number_1,
    council_address.house_suffix_1 as house_suffix_1,
    council_address.house_prefix_2 as house_prefix_2,
    council_address.house_number_2 as house_number_2,
    council_address.house_suffix_2 as house_suffix_2,
    council_address.access_type as access_type,
    '' as new_road,
    council_address.road_name as road_name,
    council_address.road_type as road_type,
    council_address.road_suffix as road_suffix,
    council_address.locality_name as locality_name,
    '' as distance_related_flag,
    council_address.is_primary as is_primary,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    'S' as edit_code,
    'property ' || propnum || ': ' ||
    case    
        when propnum in ( select t.propnum from PC_Vicmap_Property_Address t ) then 'replacing address ' || ( select t.num_road_address from PC_Vicmap_Property_Address t where council_address.propnum = t.propnum and t.is_primary <> 'N' limit 1) || ' with '
        else 'assigning new address '       
    end || council_address.num_road_address as comments
from
    PC_Council_Property_Address council_address
where
    propnum not in ( '' , 'NCPR' ) and
    is_primary <> 'N' and    
    propnum not in ( select t.propnum from PC_Vicmap_Property_Address t where council_address.num_road_address = t.num_road_address and t.is_primary <> 'N' ) and    
    propnum not in ( select propnum from M1_R_Edits ) and
    ( propnum in ( select propnum from PC_Vicmap_Property_Address ) or    
      propnum in ( select propnum from M1_P_Edits ) or
      propnum in ( select propnum from M1_A_Edits ) )