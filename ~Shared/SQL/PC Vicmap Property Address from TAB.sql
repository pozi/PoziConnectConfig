select
    property.prop_pfi as property_pfi,
    property.prop_lga_code as lga_code,
    ifnull ( property.prop_propnum , '' ) as propnum,
    property.prop_property_type as property_type,
    property.prop_multi_assessment as multi_assessment,
    property.prop_status as status,
    property.propv_pfi as property_view_pfi,
    property.propv_graphic_type as property_view_graphic_type,
    replace ( property.prop_pfi_created_char , '/' , '-' ) as property_pfi_created,
    address.pfi as address_pfi,
    substr ( address.ezi_address , 1 , length ( address.ezi_address ) - 5 ) as ezi_address,
    address.source as source,
    ifnull ( address.source_verified , '' ) as src_verified,
    address.is_primary as is_primary,
    address.distance_related_flag as distance_related_flag,
    ifnull ( address.location_descriptor , '' ) as location_descriptor,
    ifnull ( address.blg_unit_type , '' ) as blg_unit_type,
    ifnull ( address.hsa_flag , '' ) as hsa_flag,
    ifnull ( address.hsa_unit_id , '' ) as hsa_unit_id,
    ifnull ( address.blg_unit_prefix_1 , '' ) as blg_unit_prefix_1,
    case
        when address.blg_unit_id_1 = -9999 then 0
        else address.blg_unit_id_1
    end as blg_unit_id_1,
    ifnull ( address.blg_unit_suffix_1 , '' ) as blg_unit_suffix_1,
    ifnull ( address.blg_unit_prefix_2 , '' ) as blg_unit_prefix_2,
    case
        when address.blg_unit_id_2 = -9999 then 0
        else address.blg_unit_id_2
    end as blg_unit_id_2,
    ifnull ( address.blg_unit_suffix_2 , '' ) as blg_unit_suffix_2,
    ifnull ( address.floor_type , '' ) as floor_type,
    ifnull ( address.floor_prefix_1 , '' ) as floor_prefix_1,
    case
        when address.floor_no_1 = -9999 then 0
        else address.floor_no_1
    end as floor_no_1,
    ifnull ( address.floor_suffix_1 , '' ) as floor_suffix_1,
    ifnull ( address.floor_prefix_2 , '' ) as floor_prefix_2,
    case
        when address.floor_no_2 = -9999 then 0
        else address.floor_no_2
    end as floor_no_2,
    ifnull ( address.floor_suffix_2 , '' ) as floor_suffix_2,
    ifnull ( address.building_name , '' ) as building_name,
    ifnull ( address.complex_name , '' ) as complex_name,
    ifnull ( address.house_prefix_1 , '' ) as house_prefix_1,
    case
        when address.house_number_1 = -9999 then 0
        else address.house_number_1
    end as house_number_1,
    ifnull ( address.house_suffix_1 , '' ) as house_suffix_1,
    ifnull ( address.house_prefix_2 , '' ) as house_prefix_2,
    case
        when address.house_number_2 = -9999 then 0
        else address.house_number_2
    end as house_number_2,
    ifnull ( address.house_suffix_2 , '' ) as house_suffix_2,
    ifnull ( address.road_name , '' ) as road_name,
    ifnull ( address.road_type , '' ) as road_type,
    ifnull ( address.road_suffix , '' ) as road_suffix,
    address.locality_name as locality_name,
    address.num_road_address as num_road_address,
    ifnull ( address.num_address , '' ) as num_address,
    address.address_class as address_class,
    address.add_access_type as access_type,
    address.outside_property as outside_property,
    address.complex_site as complex_site,
    road_name || rtrim ( ' ' || road_type ) || rtrim ( ' ' || road_suffix ) as road_name_combined,
    road_name || rtrim ( ' ' || road_type ) || rtrim ( ' ' || road_suffix ) || rtrim ( ' ' || locality_name ) as road_locality,
    replace ( pfi_created_char , '/' , '-' ) as address_pfi_created,
    st_x ( address.geometry ) as address_x,
    st_y ( address.geometry ) as address_y,
    round ( st_x ( st_transform ( address.geometry, 3111 ) ) , 0 ) as address_x_proj,
    round ( st_y ( st_transform ( address.geometry, 3111 ) ) , 0 ) as address_y_proj,
    'EPSG:3111' as address_datum_proj,
    area ( st_transform ( property.geometry , 3111 ) ) as property_area,
    area ( envelope ( st_transform ( property.geometry , 3111 ) ) ) property_mbr_area,
    property.geometry as geometry
from
    vmprop_property_mp property,
    vmadd_address address
where
    property.prop_pfi = address.property_pfi and
    property.prop_property_type = 'O'
