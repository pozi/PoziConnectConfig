select
    propnum as council_propnum,
    status as council_status,
    num_road_address as council_address,
    locality_name as council_locality,
    summary as council_summary,
    case
        when status not in ('','A','P') then 'Invalid: status (' || status || ')'
        when is_primary not in ('','Y','N') then 'Invalid: is_primary (' || is_primary || ')'
        when distance_related_flag not in ('','Y','N') then 'Invalid: distance_related_flag (' || distance_related_flag || ')'    
        when blg_unit_type not in ('','ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then 'Invalid: blg_unit_type (' || blg_unit_type || ')'       
        when blg_unit_id_1 not in ( '' , cast ( cast ( blg_unit_id_1 as integer ) as varchar ) ) then 'Invalid: blg_unit_id_1 (' || blg_unit_id_1 || ')'
        when blg_unit_id_2 not in ( '' , cast ( cast ( blg_unit_id_2 as integer ) as varchar ) ) then 'Invalid: blg_unit_id_2 (' || blg_unit_id_2 || ')'
        when floor_no_1 not in ( '' , cast ( cast ( floor_no_1 as integer ) as varchar ) ) then 'Invalid: floor_no_1 (' || floor_no_1 || ')'
        when floor_no_2 not in ( '' , cast ( cast ( floor_no_2 as integer ) as varchar ) ) then 'Invalid: floor_no_2 (' || floor_no_2 || ')'
        when house_number_1 not in ( '' , cast ( cast ( house_number_1 as integer ) as varchar ) ) then 'Invalid: house_number_1 (' || house_number_1 || ')'
        when house_number_2 not in ( '' , cast ( cast ( house_number_2 as integer ) as varchar ) ) then 'Invalid: house_number_2 (' || house_number_2 || ')'
        when access_type not in ('','L','W','I') then 'Invalid: access_type (' || access_type || ')'
        else ''
    end as address_validity,
    ifnull ( ( select cppc.num_parcels from pc_council_property_parcel_count cppc where cppc.propnum = cpa.propnum ) , 0 ) as num_parcels_in_council,
    ifnull ( ( select vppc.num_parcels from pc_vicmap_property_parcel_count vppc where vppc.propnum = cpa.propnum ) , 0 ) as num_parcels_in_vicmap,
    ifnull ( ( select vpa.num_road_address from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) , '' ) as vicmap_address,
    ifnull ( ( select vpa.locality_name from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) , '' ) as vicmap_locality,
    case
        when propnum not in ( select vpa.propnum from pc_vicmap_property_address vpa ) then ''
        when num_road_address = ( select vpa.num_road_address from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) then 'Y'
        else 'N'
    end as address_match_in_vicmap,
    case
        when road_name in ( select distinct road_name from pc_vicmap_property_address ) then 'Y'
        else 'N'
    end as road_name_in_vicmap,
    case
        when road_type = '' then ''
        when road_type in ( select distinct road_type from pc_vicmap_property_address ) then 'Y'
        else 'N'
    end as road_type_in_vicmap,
    case
        when propnum not in ( select vpa.propnum from pc_vicmap_property_address vpa ) then ''
        when locality_name = ( select vpa.locality_name from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) then 'Y'
        else 'N'
    end as locality_match_in_vicmap,
    ifnull ( ( select edit_code from m1 where m1.propnum = cpa.propnum limit 1 ) , '' ) as current_m1_edit_code,
    ifnull ( ( select comments from m1 where m1.propnum = cpa.propnum limit 1 ) , '' ) as current_m1_comments
from pc_council_property_address cpa
order by address_validity desc
