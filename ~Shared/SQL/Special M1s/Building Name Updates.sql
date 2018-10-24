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
        else replace ( cpa.building_name , '&' , 'AND' )
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
        ': update building name from ' ||
        case
            when vpa.building_name = '' then '(blank)'
            else vpa.building_name
        end
        || ' to ' ||
        case
            when cpa.building_name = '' then '(blank)'
            else replace ( cpa.building_name , '&' , 'AND' )
        end as comments
from
    pc_council_property_address cpa left join
    pc_vicmap_property_address vpa on cpa.propnum = vpa.propnum and vpa.is_primary = 'Y'
where
    replace ( cpa.building_name , '&' , 'AND' ) <> vpa.building_name
group by
    cpa.propnum, vpa.property_pfi
order by
    case
        when cpa.building_name = '' then 0
        else 1
    end, cast ( cpa.propnum as integer )
