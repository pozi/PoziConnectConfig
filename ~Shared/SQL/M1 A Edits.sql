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
    case
        when blg_unit_id_1 = '' then ''
        else blg_unit_type
    end as blg_unit_type,
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
    case
        when house_number_1 = '' then ''
        when building_name in ('ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then ''
        else building_name
    end as building_name,
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
    case is_primary
        when 'Y' then 'Y'
        else ''
    end as is_primary,
    easting,
    northing,
    datum_proj,
    outside_property,
    'A' as edit_code,
    comments as comments,
    geometry as geometry
from (

select
    cp.lga_code,
    ( select vp.property_pfi
        from pc_vicmap_parcel vp
        where vp.spi = cp.spi and vp.property_pfi <> ''
        order by cast ( vp.property_pfi as integer )
        limit 1
    ) as property_pfi,
    cp.propnum,
    cpa.*,
    '' as new_road,
    case
        when ( select vpppc.num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = cp.spi ) > 1 then 'multi-parcel (' || ( select vpppc.num_parcels_in_prop from pc_vicmap_parcel_property_parcel_count vpppc where vpppc.spi = cp.spi ) || ') property'
        else 'parcel ' || cp.spi
    end ||
        case ( select vp.status from pc_vicmap_parcel vp where vp.spi = cp.spi )
            when 'P' then ' (proposed)'
            else ''
        end ||
        ': adding propnum ' ||
        cp.propnum ||
        case
            when cp.propnum not in ( select propnum from pc_vicmap_parcel ) then ' (new)'
            else ''
        end ||
        ' (' || ifnull ( cpa.ezi_address , '' ) || ')' ||
        case ( select vp.multi_assessment from pc_vicmap_parcel vp where vp.spi = cp.spi )
            when 'Y' then ' to existing multi-assessment (' || ( select vppc.num_props from pc_vicmap_parcel_property_count vppc where vppc.spi = cp.spi ) || ') property (' || ( select vpa.road_locality from pc_vicmap_property_address vpa where vpa.propnum <> '' and vpa.propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) limit 1 ) || ')'
            else ' as new multi-assessment to property ' || ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi and vp.property_pfi <> '' order by cast ( vp.property_pfi as integer ) limit 1 ) || ' (' || ifnull ( ( select ezi_address from pc_council_property_address cpax where propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) ) , '???' ) || ')'
        end ||
        case
		    when ( select vpa.propnum from pc_vicmap_property_address vpa where vpa.propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) ) is null then ''
            when cpa.locality_name not in ( select vpa.locality_name from pc_vicmap_property_address vpa where vpa.propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) ) then ' (**WARNING**: properties have different localities)'
            when cpa.road_name not in ( select vpa.road_name from pc_vicmap_property_address vpa where vpa.propnum in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) ) then ' (**WARNING**: properties have different road names)'
            else ''
        end as comments,
    centroid ( ( select vp.geometry from pc_vicmap_parcel vp where vp.spi = cp.spi limit 1 ) ) as geometry
from
    pc_council_parcel cp left join
    ( select * , min ( case is_primary when 'Y' then 1 when '' then 2 when 'N' then 3 end ) from pc_council_property_address group by propnum ) cpa on cp.propnum = cpa.propnum
where
    cp.propnum not in ( '' , 'NCPR' ) and
    cp.propnum in ( select propnum from pc_council_property_address ) and
    cp.spi <> '' and
    ( select cppc.num_props from pc_council_parcel_property_count cppc where cppc.spi = cp.spi ) > 1 and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from pc_vicmap_parcel_property_count vppc where vppc.num_props > 1 ) ) ) and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where vp.propnum in ( select propnum from pc_council_parcel ) ) and
    cp.propnum not in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi ) and
    cp.propnum not in ( select vp.propnum from pc_vicmap_parcel vp where property_view_pfi in ( select vp.property_view_pfi from pc_vicmap_parcel vp where vp.spi = cp.spi ) ) and
    cp.spi not like '%PP2%' and cp.spi not like '%PP3%' and
    cp.spi in ( select vp.spi from pc_vicmap_parcel vp where vp.spi in ( select cpy.spi from pc_council_parcel cpy where cpy.spi = vp.spi and cpy.propnum = vp.propnum ) ) and
    ( select vp.property_view_pfi from pc_vicmap_parcel vp where vp.spi = cp.spi ) not in ( select property_view_pfi from pc_vicmap_property_address vpa where property_pfi in ( select property_pfi from m1_r_edits ) ) and
    not ( cp.propnum in ( select base_propnum from pc_council_property_address ) ) and
    not ( cpa.base_propnum in ( select propnum from pc_vicmap_property_address where propnum <> '' ) ) and
    not ( cp.spi in ( select spi from pc_vicmap_parcel where status = 'A' ) and cp.propnum in ( select propnum from pc_vicmap_parcel where status = 'P' ) ) and
    not ( cp.status = 'P' and cp.propnum in ( select propnum from pc_vicmap_parcel where status = 'A' ) ) and
    not ( cp.propnum in ( select propnum from pc_vicmap_property_address ) and not ( cp.propnum in ( select propnum from pc_council_parcel where status = 'P' ) and cp.propnum in ( select propnum from pc_council_parcel where status <> 'P' ) ) )
) as cpx
group by property_pfi, propnum
order by cast ( property_pfi as integer ) desc