select
    cpa.lga_code as lga_code,
    '' as new_sub,
    case
        when ( select count(*) from pc_vicmap_property_address vpax where vpax.propnum = cpa.propnum group by vpax.propnum ) > 1 then vpa.property_pfi
        else ''
    end as property_pfi,
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
    case
        when cpa.distance_related_flag <> '' then cpa.distance_related_flag
        when vpa.distance_related_flag = 'Y' then 'Y'
        else ''
    end as distance_related_flag,
    case cpa.is_primary
        when 'Y' then 'Y'
        else ''
    end as is_primary,
    case
        when cast ( cpa.easting as varchar ) not in ( '' , '0' ) then cast ( cpa.easting as varchar )
        when vpa.distance_related_flag = 'Y' then vpa.address_x_proj
        else ''
    end as easting,
    case
        when cast ( cpa.northing as varchar ) not in ( '' , '0' ) then cast ( cpa.northing as varchar )
        when vpa.distance_related_flag = 'Y' then vpa.address_y_proj
        else ''
    end as northing,
    case
        when cpa.datum_proj <> '' then cpa.datum_proj
        when vpa.distance_related_flag = 'Y' then vpa.address_datum_proj
        else ''
    end as datum_proj,
    case
        when cpa.outside_property <> '' then cpa.outside_property
        when vpa.distance_related_flag = 'Y' then vpa.outside_property
        else ''
    end as outside_property,
    'S' as edit_code,
    'property ' || cpa.propnum ||
        case vpa.status
            when 'P' then ' (proposed)'
            else ''
        end || ': ' ||
        case
            when cpa.propnum = vpa.propnum then 'replacing address ' || vpa.ezi_address || ' with '
            else 'assigning new address '
        end ||
        cpa.ezi_address ||
        case
            when vpa.house_number_1 <> 0 and vpa.house_number_1 <> '' and cpa.house_number_1 = '' then ' (**WARNING**: house number is being removed)'
            when vpa.distance_related_flag = 'Y' and cpa.distance_related_flag <> 'Y' then ' (**NOTE**: address update will maintain the existing location of distance-based address)'
            else ''
        end ||
        case
            when vpa.locality_name <> cpa.locality_name and vpa.locality_name not like '%(%' then ' (**WARNING**: different locality)'
            else ''
        end ||
        case
            when cpa.hsa_flag = 'Y' and vpa.hsa_flag = 'N' then ' (**NOTE**: new hotel style address)'
            else ''
        end ||
        case
            when length ( cpa.building_name ) > 45 then ' (**WARNING**: building name exceeds limit of 45 characters)'
            else ''
        end ||
        case
            when replace ( cpa.road_locality , '-' , ' ' ) not in ( select replace ( road_locality , '-' , ' ' ) from pc_vicmap_property_address ) and vpa.road_locality not like '%(%' then ' (**WARNING**: new road name)'
            else ''
        end as comments,
    centroid ( vpa.geometry ) as geometry
from
    pc_council_property_address cpa left join
    pc_vicmap_property_address vpa on cpa.propnum = vpa.propnum and vpa.is_primary = 'Y'
where
    cpa.propnum not in ( '' , 'NCPR' ) and
    ( cpa.is_primary <> 'N' or ( select cpc.num_records from pc_council_property_count cpc where cpc.propnum = cpa.propnum ) = 1 ) and
    ( cpa.propnum not in ( select propnum from pc_council_property_address where num_road_address in ( select num_road_address from pc_vicmap_property_address vpax where vpax.propnum = cpa.propnum and vpax.is_primary = 'Y' ) ) or
      ( cpa.building_name <> '' and cpa.building_name not in ( ifnull ( ( select building_name from pc_vicmap_property_address vpax where vpax.propnum = cpa.propnum and vpax.is_primary = 'Y' ) , '' ) ) ) ) and
    cpa.propnum not in ( select vpax.propnum from pc_vicmap_property_address vpax, m1_r_edits r where vpax.property_pfi = r.property_pfi ) and
    ( cpa.propnum in ( select propnum from pc_vicmap_property_address ) or
      cpa.propnum in ( select propnum from m1_p_edits ) ) and
    ( not replace ( replace ( replace ( cpa.num_road_address , '-' , ' ' ) , '''' , '' ) , 'MT ' , 'MOUNT ' ) = ifnull ( replace ( replace ( replace ( vpa.num_road_address , '-' , ' ' ) , '''' , '' ) , 'MT ' , 'MOUNT ' ) , '' ) or
      ( cpa.hsa_flag = 'Y' and vpa.hsa_flag = 'N' ) ) and
    cpa.road_name <> '' and
    not ( select count(*) from ( select distinct ezi_address from pc_vicmap_property_address vpax where vpax.propnum = cpa.propnum ) ) > 1
group by cpa.propnum, vpa.property_pfi
