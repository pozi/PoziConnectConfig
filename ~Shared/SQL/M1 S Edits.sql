select
    cpa.lga_code as lga_code,
    '' as new_sub,
    '' as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    '' as spi,
    '' as plan_number,
    '' as lot_number,
    '' as base_propnum,
    cpa.propnum as propnum,
    '' as crefno,
    cpa.hsa_flag as hsa_flag,
    cpa.hsa_unit_id as hsa_unit_id,
    cpa.blg_unit_type as blg_unit_type,
    cpa.blg_unit_prefix_1 as blg_unit_prefix_1,
    cpa.blg_unit_id_1 as blg_unit_id_1,
    cpa.blg_unit_suffix_1 as blg_unit_suffix_1,
    cpa.blg_unit_prefix_2 as blg_unit_prefix_2,
    cpa.blg_unit_id_2 as blg_unit_id_2,
    cpa.blg_unit_suffix_2 as blg_unit_suffix_2,
    cpa.floor_type as floor_type,
    cpa.floor_prefix_1 as floor_prefix_1,
    cpa.floor_no_1 as floor_no_1,
    cpa.floor_suffix_1 as floor_suffix_1,
    cpa.floor_prefix_2 as floor_prefix_2,
    cpa.floor_no_2 as floor_no_2,
    cpa.floor_suffix_2 as floor_suffix_2,
    cpa.building_name as building_name,
    cpa.complex_name as complex_name,
    cpa.location_descriptor as location_descriptor,
    cpa.house_prefix_1 as house_prefix_1,
    cpa.house_number_1 as house_number_1,
    cpa.house_suffix_1 as house_suffix_1,
    cpa.house_prefix_2 as house_prefix_2,
    cpa.house_number_2 as house_number_2,
    cpa.house_suffix_2 as house_suffix_2,
    cpa.access_type as access_type,
    '' as new_road,
    cpa.road_name as road_name,
    cpa.road_type as road_type,
    cpa.road_suffix as road_suffix,
    cpa.locality_name as locality_name,
    '' as distance_related_flag,
    cpa.is_primary as is_primary,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    'S' as edit_code,
    'property ' || propnum || ': ' ||
    case    
        when propnum in ( select vpa.propnum from PC_Vicmap_Property_Address vpa ) then 'replacing address ' || ( select vpa.ezi_address from PC_Vicmap_Property_Address vpa where cpa.propnum = vpa.propnum and vpa.is_primary <> 'N' limit 1) || ' with '
        else 'assigning new address '       
    end || cpa.ezi_address as comments
from
    PC_Council_Property_Address cpa
where
    propnum not in ( '' , 'NCPR' ) and
    is_primary <> 'N' and
    propnum not in ( select vpa.propnum from PC_Vicmap_Property_Address vpa where vpa.num_road_address = cpa.num_road_address and vpa.is_primary <> 'N' ) and    
    propnum not in ( select vpa.propnum from PC_Vicmap_Property_Address vpa, M1_R_Edits r where vpa.property_pfi = r.property_pfi ) and
    ( propnum in ( select propnum from PC_Vicmap_Property_Address ) or    
      propnum in ( select propnum from M1_P_Edits ) or
      propnum in ( select propnum from M1_A_Edits ) ) and
    not replace ( replace ( cpa.num_road_address , '-' , ' ' ) , '''' , '' ) = replace ( replace ( ( select vpa.num_road_address from PC_Vicmap_Property_Address vpa where vpa.propnum = cpa.propnum ) , '-' , ' ' ) , '''' , '' )
group by propnum

union

select
    cpa.lga_code as lga_code,
    '' as new_sub,
    '' as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    cp.spi as spi,
    cp.plan_number as plan_number,
    cp.lot_number as lot_number,
    '' as base_propnum,
    '' as propnum,
    '' as crefno,
    cpa.hsa_flag as hsa_flag,
    cpa.hsa_unit_id as hsa_unit_id,
    cpa.blg_unit_type as blg_unit_type,
    cpa.blg_unit_prefix_1 as blg_unit_prefix_1,
    cpa.blg_unit_id_1 as blg_unit_id_1,
    cpa.blg_unit_suffix_1 as blg_unit_suffix_1,
    cpa.blg_unit_prefix_2 as blg_unit_prefix_2,
    cpa.blg_unit_id_2 as blg_unit_id_2,
    cpa.blg_unit_suffix_2 as blg_unit_suffix_2,
    cpa.floor_type as floor_type,
    cpa.floor_prefix_1 as floor_prefix_1,
    cpa.floor_no_1 as floor_no_1,
    cpa.floor_suffix_1 as floor_suffix_1,
    cpa.floor_prefix_2 as floor_prefix_2,
    cpa.floor_no_2 as floor_no_2,
    cpa.floor_suffix_2 as floor_suffix_2,
    cpa.building_name as building_name,
    cpa.complex_name as complex_name,
    cpa.location_descriptor as location_descriptor,
    cpa.house_prefix_1 as house_prefix_1,
    cpa.house_number_1 as house_number_1,
    cpa.house_suffix_1 as house_suffix_1,
    cpa.house_prefix_2 as house_prefix_2,
    cpa.house_number_2 as house_number_2,
    cpa.house_suffix_2 as house_suffix_2,
    cpa.access_type as access_type,
    '' as new_road,
    cpa.road_name as road_name,
    cpa.road_type as road_type,
    cpa.road_suffix as road_suffix,
    cpa.locality_name as locality_name,
    '' as distance_related_flag,
    '' as is_primary,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    'S' as edit_code,
    'parcel ' || cp.spi || ' (proposed): replacing address ' || vpa.ezi_address || ' with ' || cpa.ezi_address as comments
from
    PC_Council_Property_Address cpa,    
    PC_Council_Parcel cp,
    PC_Vicmap_Parcel vp,
    PC_Vicmap_Property_Address vpa
where
    cpa.propnum not in ( '' , 'NCPR' ) and
    cpa.propnum = cp.propnum and
    cp.spi = vp.spi and    
    vp.property_pfi = vpa.property_pfi and
    vp.status = 'P' and
    cpa.num_address <> '' and
    vpa.num_address = '' and
    ( cpa.crefno = cp.crefno or cpa.crefno = '' )
group by cpa.propnum, vp.plan_number, vp.lot_number
