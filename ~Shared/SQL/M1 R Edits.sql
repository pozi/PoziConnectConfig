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
    comments as comments,
    geometry as geometry
from (

select
    lga_code,
    property_pfi,
    case
        when ( select num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = vp.spi and vp.propnum <> 'NCPR') > 1 then 'multi-parcel (' || ( select num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = vp.spi ) || ') property'
        else 'parcel ' || spi
    end ||
        ': removing propnum ' ||
        case propnum when '' then '(blank)' else propnum end ||
        case when propnum not in ( select propnum from pc_council_property_address ) and propnum <> 'NCPR' then ' (invalid)' else '' end ||
        ' from multi-assessment (' ||
        ( select vppc.num_props from pc_vicmap_parcel_property_count vppc where vppc.spi = vp.spi ) ||
        ') property' ||
        case
            when propnum in ( select propnum from pc_council_property_address ) then
            ' so it can be later matched to ' ||
            ( select spi from pc_vicmap_parcel vpx where vpx.spi in ( select spi from pc_council_parcel pc where pc.propnum = vp.propnum ) limit 1 )
            else ''
        end as comments,
    centroid ( vp.geometry ) as geometry
from
    pc_vicmap_parcel vp
where
    multi_assessment = 'Y' and
    propnum <> 'NCPR' and
    (
        (
            vp.spi not in ( select spi from pc_vicmap_parcel vpx where vpx.propnum in ( select propnum from pc_council_parcel cpx where cpx.spi = vp.spi ) ) and
            property_pfi not in ( select max ( t.property_pfi ) from pc_vicmap_parcel t group by t.parcel_pfi ) and
            ( propnum not in ( select cpa.propnum from pc_council_property_address cpa ) or
              ( vp.spi in ( select cp.spi from pc_council_parcel cp ) and ( select count(*) from pc_council_parcel cp where cp.propnum = vp.propnum ) > 0 )
            ) and
            propnum not in ( select propnum from pc_council_parcel cp where spi not in ( select x.spi from pc_vicmap_parcel x where spi <> '' ) ) and
            vp.spi <> ''
        ) or
        vp.propnum not in ( select propnum from pc_council_property_address )
    )
group by property_pfi
)
