select
    lga_code as lga_code,
    '' as new_sub,
    property_pfi as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    '' as spi,
    '' as plan_number,
    '' as lot_number,
    '' as base_propnum,
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
    'A' as edit_code,
    comments as comments
from (

select distinct
    cp.lga_code as lga_code,    
    ( select vp.property_pfi from PC_Vicmap_Parcel vp where vp.spi = cp.spi limit 1 ) as property_pfi,
    cp.propnum as propnum,
    case    
        when ( select vpppc.num_parcels_in_prop from PC_Vicmap_Parcel_Property_Parcel_Count vpppc where vpppc.spi = cp.spi ) > 1 then 'multi-parcel property'        
        else 'parcel ' || cp.spi     
    end ||': adding propnum ' || cp.propnum || ' as multi-assessment' as comments
from
    PC_Council_Parcel cp
where
    cp.propnum not in ( '' , 'NCPR' ) and
    cp.spi <> '' and
    ( select cppc.num_props from PC_Council_Parcel_Property_Count cppc where cppc.spi = cp.spi ) > 1 and
    cp.spi in ( select vp.spi from PC_Vicmap_Parcel vp where not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from PC_Vicmap_Parcel_Property_Count vppc where vppc.num_props > 1 ) ) ) and
    cp.spi in ( select vp.spi from PC_Vicmap_Parcel vp where vp.propnum in ( select propnum from PC_Council_Parcel ) ) and
    cp.propnum not in ( select vp.propnum from PC_Vicmap_Parcel vp where vp.spi = cp.spi )
)