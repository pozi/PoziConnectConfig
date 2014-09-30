select distinct
    lga_code,
    '' as new_sub,
    property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    '' as spi,
    '' as plan_number,
    '' as lot_number,
    base_propnum,
    propnum,
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
    new_road,
    road_name,
    road_type,
    road_suffix,
    locality_name,
    distance_related_flag,
    is_primary,
    easting,
    northing,
    datum_proj,
    outside_property,
    'A' as edit_code,
    comments as comments,
    geometry as geometry
from (

select
    ( select vp.property_pfi from pc_vicmap_parcel vp where vp.spi = cp.spi limit 1 ) as property_pfi,
    cpa.*,
    '' as new_road,
    case
        when ( select vpppc.num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = cp.spi ) > 1 then 'multi-parcel (' || ( select vpppc.num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = cp.spi ) || ') property'
        else 'parcel ' || cp.spi
    end ||
        ': adding propnum ' ||
        cp.propnum || ' (' || cpa.ezi_address || ')' ||
        case ( select vp.multi_assessment from pc_vicmap_parcel vp where vp.spi = cp.spi )
            when 'Y' then ' to existing multi-assessment (' || ( select vppc.num_props from pc_vicmap_parcel_property_count vppc where vppc.spi = cp.spi ) || ') property (' || ( select vpa.road_locality from pc_vicmap_property_address vpa where vpa.propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) limit 1 ) || ')'
            else ' as new multi-assessment to property ' || ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) || ' (' || ifnull ( ( select ezi_address from pc_council_property_address cpax where propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) ) , '???' ) || ')'
        end ||
        case
            when cpa.locality_name not in ( select vpa.locality_name from pc_vicmap_property_address vpa where vpa.propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) ) then ' (**WARNING**: properties have different localities)'
            else ''
        end as comments,
    centroid ( ( select vp.geometry from pc_vicmap_parcel vp where vp.spi = cp.spi limit 1 ) ) as geometry
from
    pc_council_parcel cp,
    pc_council_property_address cpa
where
    cp.propnum = cpa.propnum and
    cpa.is_primary <> 'N' and
    cp.propnum not in ( '' , 'NCPR' ) and
    cp.propnum in ( select propnum from pc_council_property_address ) and
    cp.spi <> '' and
    ( select cppc.num_props from pc_council_parcel_property_count cppc where cppc.spi = cp.spi ) > 1 and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from pc_vicmap_parcel_property_count vppc where vppc.num_props > 1 ) ) ) and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where vp.propnum in ( select propnum from pc_council_parcel ) ) and
    cp.propnum not in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) and
    cp.plan_number <> '' and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where vp.spi in ( select cpy.spi from pc_council_parcel cpy where cpy.spi = vp.spi and cpy.propnum = vp.propnum ) )
) as cpx
