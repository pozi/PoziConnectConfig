select distinct
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
    case
        when replace ( replace ( cpa.road_locality , '''' , '' ) , '-' , ' ' ) not in ( select replace ( road_locality , '-' , ' ' ) from pc_vicmap_property_address ) then 'Y'
        else ''
    end as new_road,
    cpa.road_name as road_name,
    cpa.road_type as road_type,
    cpa.road_suffix as road_suffix,
    cpa.locality_name as locality_name,
    cpa.distance_related_flag as distance_related_flag,
    case cpa.is_primary
        when 'Y' then 'Y'
        else ''
    end as is_primary,
    cast ( cpa.easting as varchar ) as easting,
    cast ( cpa.northing as varchar ) as northing,
    cpa.datum_proj as datum_proj,
    cpa.outside_property as outside_property,
    'S' as edit_code,
    'property ' || propnum || ': ' ||
        case
            when propnum in ( select vpa.propnum from pc_vicmap_property_address vpa ) then 'replacing address ' || ( select vpa.ezi_address from pc_vicmap_property_address vpa where cpa.propnum = vpa.propnum and vpa.is_primary <> 'N' limit 1 ) || ' with '
            else 'assigning new address '
        end ||
        cpa.ezi_address ||
        case
            when ( select locality_name from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum ) <> cpa.locality_name then ' (**WARNING**: different locality)'
            else ''
        end ||
        case
            when replace ( cpa.road_locality , '-' , ' ' ) not in ( select replace ( road_locality , '-' , ' ' ) from pc_vicmap_property_address ) then ' (**WARNING**: new road name)'
            else ''
        end as comments,
    centroid ( ( select vpa.geometry from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum and cpa.is_primary <> 'N' limit 1 ) ) as geometry
from
    pc_council_property_address cpa
where
    propnum not in ( '' , 'NCPR' ) and
    ( is_primary <> 'N' or ( select cpc.num_records from pc_council_property_count cpc where cpc.propnum = cpa.propnum ) = 1 ) and
    ( propnum not in ( select propnum from pc_council_property_address where num_road_address in ( select num_road_address from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum and vpa.is_primary = 'Y' ) ) or
      ( building_name <> '' and building_name not in ( ifnull ( ( select building_name from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum and vpa.is_primary = 'Y' ) , '' ) ) ) ) and
    propnum not in ( select vpa.propnum from pc_vicmap_property_address vpa, m1_r_edits r where vpa.property_pfi = r.property_pfi ) and
    ( propnum in ( select propnum from pc_vicmap_property_address ) or
      propnum in ( select propnum from m1_p_edits ) ) and
    not replace ( replace ( cpa.num_road_address , '-' , ' ' ) , '''' , '' ) = ifnull ( replace ( replace ( ( select vpa.num_road_address from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum and vpa.is_primary = 'Y' ) , '-' , ' ' ) , '''' , '' ) , '' )
