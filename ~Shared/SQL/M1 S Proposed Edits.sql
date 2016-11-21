select distinct
    cpa.lga_code as lga_code,
    'Y' as new_sub,
    '' as property_pfi,
    '' as parcel_pfi,
    '' as address_pfi,
    cp.spi as spi,
    '' as plan_number,
    '' as lot_number,
    '' as base_propnum,
    '' as propnum,
    '' as crefno,
    cpa.hsa_flag as hsa_flag,
    cpa.hsa_unit_id as hsa_unit_id,
    case
        when cpa.blg_unit_id_1 = '' then ''
        else cpa.blg_unit_type
    end as blg_unit_type,
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
    case
        when cpa.house_number_1 = '' then ''
        when cpa.building_name in ('ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then ''
        else cpa.building_name
    end as building_name,
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
    cpa.distance_related_flag as distance_related_flag,
    '' as is_primary,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    'S' as edit_code,
    'parcel ' || cp.spi || ' (proposed): replacing address ' || vpa.ezi_address || ' with ' || cpa.ezi_address as comments,
    centroid ( vp.geometry ) as geometry
from
    pc_council_property_address cpa,
    pc_council_parcel cp,
    pc_vicmap_parcel vp,
    pc_vicmap_property_address vpa
where
    cpa.propnum not in ( '' , 'NCPR' ) and
    cpa.propnum = cp.propnum and
    vp.spi <> '' and
    cp.spi = vp.spi and
    vp.property_pfi = vpa.property_pfi and
    vp.status = 'P' and
    cpa.num_address <> '' and
    vpa.num_address = '' and
    ( cpa.crefno = cp.crefno or cpa.crefno = '' ) and
    cpa.propnum in
        ( select propnum from
            ( select cpx.propnum,
                max ( case
                    when cpax.ezi_address not in ( select ezi_address from pc_vicmap_property_address ) then 1
                    else 0
                end )
            from
                pc_council_parcel cpx,
                pc_council_property_address cpax
            where
                cpx.propnum = cpax.propnum and
                cpx.spi = vp.spi
            )
        ) and
    cpa.propnum not in ( select propnum from m1_s_edits )
