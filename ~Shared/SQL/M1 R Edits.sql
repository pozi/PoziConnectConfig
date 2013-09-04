select distinct
    lga_code as lga_code,
    '' as new_sub,
    property_pfi as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    '' as spi,
    '' as plan_number,
    '' as lot_number,
    '' as base_propnum,
    '' as propnum,
    '' as crefno,
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
    'R' as edit_code,
    comments as comments
from (

select
    lga_code,
    property_pfi,
    case
        when ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count vpppc where vpppc.spi = vp.spi ) > 1 then  'multi-parcel (' || ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count vpppc where vpppc.spi = vp.spi ) || ') property'
        else 'parcel ' || spi
    end ||
        ': removing propnum ' ||
        propnum ||
        ' from multi-assessment (' ||
        ( select vppc.num_props from PC_Vicmap_Parcel_Property_Count vppc where vppc.spi = vp.spi ) ||
        ') property' as comments
from
    PC_Vicmap_Parcel vp
where
    multi_assessment = 'Y' and
    property_pfi not in ( select max ( t.property_pfi ) from PC_Vicmap_Parcel t group by t.parcel_pfi ) and
    propnum not in ( select cpa.propnum from PC_Council_Property_Address cpa )
group by property_pfi
)