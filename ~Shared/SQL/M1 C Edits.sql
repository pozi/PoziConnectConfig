select
    lga_code as lga_code,
    '' as new_sub,
    '' as property_pfi,
    parcel_pfi as parcel_pfi,
    '' as address_pfi,
    spi as spi,
    plan_number as plan_number,
    lot_number as lot_number,
    '' as base_propnum,
    '' as propnum,
    crefno as crefno,
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
    'C' as edit_code,
    comments as comments
from (

select
    vp.lga_code as lga_code,
    case    
        when vp.plan_number = '' then vp.parcel_pfi        
        else ''        
    end as parcel_pfi,
    vp.spi as spi,
    vp.plan_number as plan_number,
    vp.lot_number as lot_number,
    cp.crefno as crefno,
    'parcel ' || vp.spi || ': replacing crefno ' ||
        case vp.crefno
            when '' then '(blank)'
            else vp.crefno
        end ||
        ' with ' || cp.crefno as comments
from
    PC_Vicmap_Parcel vp,
    PC_Council_Parcel cp
where
    vp.spi <> '' and
    vp.spi = cp.spi and
    vp.crefno <> cp.crefno and
    cp.crefno <> '' and
    ( vp.crefno = '' or
      cp.crefno <> '' and vp.crefno not in ( select cpx.crefno from PC_Council_Parcel cpx where cpx.simple_spi = vp.simple_spi ) ) and 
    ( vp.plan_number <> '' or    
      vp.propnum = cp.propnum )
group by vp.spi
order by vp.plan_number, vp.lot_number
)
