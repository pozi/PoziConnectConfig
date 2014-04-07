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
    ( select road_name from pc_vicmap_property_address vpa where vpa.property_pfi = cpx.property_pfi limit 1 ) as road_name,
    ( select road_type from pc_vicmap_property_address vpa where vpa.property_pfi = cpx.property_pfi limit 1 ) as road_type,
    ( select road_suffix from pc_vicmap_property_address vpa where vpa.property_pfi = cpx.property_pfi limit 1 ) as road_suffix,
    ( select locality_name from pc_vicmap_property_address vpa where vpa.property_pfi = cpx.property_pfi limit 1 ) as locality_name,
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
    ( select vp.property_pfi from pc_vicmap_parcel vp where vp.spi = cp.spi limit 1 ) as property_pfi,
    cp.propnum as propnum,
    case
        when ( select vpppc.num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = cp.spi ) > 1 then 'multi-parcel (' || ( select vpppc.num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = cp.spi ) || ') property'
        else 'parcel ' || cp.spi
    end ||
        ': adding propnum ' ||
        cp.propnum ||
        case ( select vp.multi_assessment from pc_vicmap_parcel vp where vp.spi = cp.spi )
            when 'Y' then ' to existing multi-assessment (' || ( select vppc.num_props from pc_vicmap_parcel_property_count vppc where vppc.spi = cp.spi ) || ') property'
            else ' as new multi-assessment to property ' || ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi )
        end as comments
from
    pc_council_parcel cp
where
    cp.propnum not in ( '' , 'NCPR' ) and
    cp.propnum in ( select propnum from pc_council_property_address ) and
    cp.spi <> '' and
    ( select cppc.num_props from pc_council_parcel_property_count cppc where cppc.spi = cp.spi ) > 1 and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from pc_vicmap_parcel_property_count vppc where vppc.num_props > 1 ) ) ) and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where vp.propnum in ( select propnum from pc_council_parcel ) ) and
    cp.propnum not in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) and
    cp.plan_number <> ''
) as cpx