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
    road_name,
    road_type,
    road_suffix,
    locality_name,
    '' as distance_related_flag,
    '' as is_primary,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    'E' as edit_code,
    comments as comments,
    geometry as geometry
from (

select
    lga_code as lga_code,
    case
        when ( select num_props from pc_vicmap_parcel_property_count vppc where vppc.spi = vp.spi ) > 1 then property_pfi
        when ( select num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = vp.spi ) > 1 then property_pfi
        else ''
    end as property_pfi,
    case
        when ( select num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = vp.spi ) > 1 then ''
        else vp.spi
    end as spi,
    case
        when ( select num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = vp.spi ) > 1 then ''
        else vp.plan_number
    end as plan_number,
    case
        when ( select num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = vp.spi ) > 1 then ''
        else vp.lot_number
    end as lot_number,
    '' as propnum,
    '' as base_propnum,
    ( select road_name from pc_vicmap_property_address vpa where vpa.property_pfi = vp.property_pfi limit 1 ) as road_name,
    ( select road_type from pc_vicmap_property_address vpa where vpa.property_pfi = vp.property_pfi limit 1 ) as road_type,
    ( select road_suffix from pc_vicmap_property_address vpa where vpa.property_pfi = vp.property_pfi limit 1 ) as road_suffix,
    ( select locality_name from pc_vicmap_property_address vpa where vpa.property_pfi = vp.property_pfi limit 1 ) as locality_name,
    case
        when ( select num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = vp.spi ) > 1 then 'multi-parcel property'
        else 'parcel ' || vp.spi
    end || ': removing propnum ' || vp.propnum ||
    ' (invalid)' ||
    ' (source: ' || ( select source from pc_vicmap_property_address vpa where vpa.property_pfi = vp.property_pfi limit 1 ) || ')' as comments,
    centroid ( vp.geometry ) as geometry
from
    pc_vicmap_parcel vp
where
    vp.spi <> '' and
    vp.propnum not in ( '' , 'NCPR' ) and
    vp.propnum not in ( select cpa.propnum from pc_council_property_address cpa ) and
    vp.spi not in ( select cp.spi from pc_council_parcel cp ) and
    vp.multi_assessment <> 'Y' and
    vp.property_pfi not in ( select property_pfi from pc_vicmap_property_address where source = 'SPE' )
)
group by property_pfi, spi
