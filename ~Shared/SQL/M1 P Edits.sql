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
    comments as comments,
    geometry as geometry
from (

select
    vp.lga_code as lga_code,
    case
        when vp.spi in ( select spi from ( select vpx.spi, count(*) num_parcels from ( select distinct spi, property_pfi from pc_vicmap_parcel where property_status = status ) vpx group by vpx.spi ) where num_parcels > 1 ) then vp.property_pfi
        else ''
    end as property_pfi,
    vp.spi as spi,
    vp.plan_number as plan_number,
    vp.lot_number as lot_number,
    cp.propnum as propnum,
    ifnull ( ( select cpa.base_propnum from pc_council_property_address cpa where cpa.propnum = cp.propnum limit 1 ) , '' ) as base_propnum,
    'parcel ' || vp.spi ||
        case vp.status
            when 'P' then ' (proposed): '
            else ': '
        end ||
        'replacing propnum ' ||
        case vp.propnum
            when '' then '(blank)'
            else vp.propnum  ||
                case when vp.propnum not in ( select propnum from pc_council_property_address ) and vp.propnum <> 'NCPR' then ' (doesn''t exist in council)' else '' end
        end ||
        ifnull ( ' (' || ( select ezi_address from pc_vicmap_property_address where property_pfi = vp.property_pfi and is_primary <> 'N' limit 1 ) || ')'  , '' ) || ' with ' ||
        cp.propnum ||
        ifnull ( ' (' || ( select cpa.ezi_address from pc_council_property_address cpa where cpa.propnum = cp.propnum and is_primary <> 'N' limit 1 ) , '' ) || ')' ||
    case
        when ( select locality_name from pc_vicmap_property_address where property_pfi = vp.property_pfi ) <> ( select locality_name from pc_council_property_address where propnum = cp.propnum ) then ' (**WARNING**: conflicting localities)'
        else ''
    end as comments,
    centroid ( vp.geometry ) as geometry
from
    pc_vicmap_parcel vp,
    pc_council_parcel cp
where
    vp.spi <> '' and
    vp.multi_assessment <> 'Y' and
    ( vp.status = vp.property_status or vp.property_status = '' ) and
    cp.propnum <> '' and
    cp.propnum in ( select propnum from pc_council_property_address ) and
    vp.spi = cp.spi and
    vp.spi not in ( select spi from pc_council_parcel where propnum = vp.propnum ) and
    vp.propnum <> cp.propnum and
    ( vp.propnum in ( '' , 'NCPR' ) or
      vp.propnum not in ( select pc_council_property_address.propnum from pc_council_property_address ) or
      ( select num_parcels from pc_vicmap_property_parcel_count where propnum = vp.propnum ) > 1 ) and
    not ( vp.status = 'P' and ( select cppc.num_parcels from pc_council_property_parcel_count cppc where cppc.propnum = cp.propnum ) > 1 )
group by vp.spi
)
order by plan_number, lot_number
