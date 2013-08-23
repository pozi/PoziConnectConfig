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
    lga_code as lga_code,
    property_pfi,
    case
        when ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count t where t.spi = vicmap_parcel.spi ) > 1 then  'multi-parcel (' || ( select num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count t where t.spi = vicmap_parcel.spi ) || ') property '
        else 'parcel ' || spi
    end || ': removing multi-assessment propnum ' || propnum as comments
from
    PC_Vicmap_Parcel vicmap_parcel
where
    multi_assessment = 'Y' and    
    spi <> '' and
    vicmap_parcel.propnum not in ( '' , 'NCPR' ) and
    vicmap_parcel.propnum not in ( select PC_Council_Parcel.propnum from PC_Council_Parcel where PC_Council_Parcel.spi = vicmap_parcel.spi )
)