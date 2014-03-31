select
    propnum as council_propnum,
    status as council_status,
    num_road_address as council_address,
    locality_name as council_locality,
    summary as council_summary,
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
order by propnum
