select
    lga_code as lga_code,
    '' as new_sub,
    property_pfi as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    spi as spi,
    plan_number as plan_number,
    lot_number as lot_number,
    base_propnum as base_propnum,
    propnum as propnum,
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
    'P' as edit_code,
    comments as comments
from (

select
    vicmap_parcel.lga_code as lga_code,
    '' as property_pfi,
    vicmap_parcel.spi as spi,
    vicmap_parcel.plan_number as plan_number,
    vicmap_parcel.lot_number as lot_number,
    council_parcel.propnum as propnum,
    '' as base_propnum,
    'parcel ' || vicmap_parcel.spi || ': ' ||
        case
            when vicmap_parcel.propnum = '' then 'assigning new propnum '
            else 'replacing propnum ' || vicmap_parcel.propnum || ' with '
        end ||
        council_parcel.propnum  as comments
from
    PC_Vicmap_Parcel vicmap_parcel,
    PC_Council_Parcel council_parcel
where
    vicmap_parcel.spi <> '' and
    council_parcel.propnum <> '' and
    vicmap_parcel.spi = council_parcel.spi and
    ( vicmap_parcel.propnum is null or vicmap_parcel.propnum not in ( select PC_Council_Parcel.propnum from PC_Council_Parcel ) )
)
