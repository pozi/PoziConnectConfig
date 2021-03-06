select
    *,
    ltrim ( num_road_address ||
        rtrim ( ' ' || locality_name ) ) as ezi_address
from (

select
    *,
    ltrim ( road_name_combined ||
        rtrim ( ' ' || locality_name ) ) as road_locality,
    ltrim ( num_address ||
        rtrim ( ' ' || road_name_combined ) ) as num_road_address
from (

select
    *,
    blg_unit_prefix_1 || blg_unit_id_1 || blg_unit_suffix_1 ||
        case when ( blg_unit_id_2 <> '' or blg_unit_suffix_2 <> '' ) then '-' else '' end ||
        blg_unit_prefix_2 || blg_unit_id_2 || blg_unit_suffix_2 ||
        case when ( blg_unit_id_1 <> '' or blg_unit_suffix_1 <> '' ) then '/' else '' end ||
        case when hsa_flag = 'Y' then hsa_unit_id || '/' else '' end ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        case when ( house_number_2 <> '' or house_suffix_2 <> '' ) then '-' else '' end ||
        house_prefix_2 || house_number_2 || house_suffix_2 as num_address,
    ltrim ( road_name ||
        rtrim ( ' ' || road_type ) ||
        rtrim ( ' ' || road_suffix ) ) as road_name_combined
from (

select
    properties.assess_no as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as location_descriptor,
    case
        when properties.unit_no like 'APT. %' then 'APT'
        when properties.unit_no like 'CLUB %' then 'CLUB'
        when properties.unit_no like 'ROOM %' then 'ROOM'
        else ''
    end as blg_unit_type,
    case
        when length ( properties.unit_no ) = 1 then ''
        when substr ( properties.unit_no , 1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 2 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( upper ( properties.unit_no ) , 1 , 1 ) )
        else ''
    end as blg_unit_prefix_1,
    case
        when properties.unit_no like 'APT. %' then trim ( substr ( properties.unit_no , 6 , 99 ) )
        when properties.unit_no like 'CLUB %' then trim ( substr ( properties.unit_no , 6 , 99 ) )
        when properties.unit_no like 'ROOM %' then trim ( substr ( properties.unit_no , 6 , 99 ) )
        when length ( properties.unit_no ) = 1 and properties.unit_no not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then ''
        when substr ( properties.unit_no , 1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 2 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( properties.unit_no , 2 , 1 ) )
        when substr ( properties.unit_no , 1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 2 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( properties.unit_no , 1 , 1 ) )
        when substr ( properties.unit_no , 2 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 3 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( properties.unit_no , 1 , 2 ) )
        when substr ( properties.unit_no , 3 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 4 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( properties.unit_no , 1 , 3 ) )
        when substr ( properties.unit_no , 2 , 1 ) in ( '-' , '&' , '/' ) then trim ( substr ( properties.unit_no , 1 , 1 ) )
        when substr ( properties.unit_no , 3 , 1 ) in ( '-' , '&' , '/' ) then trim ( substr ( properties.unit_no , 1 , 2 ) )
        else ifnull ( properties.unit_no , '' )
    end as blg_unit_id_1,
    case
        when length ( properties.unit_no ) = 1 and properties.unit_no not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' , '.' ) then upper ( properties.unit_no )
        when substr ( properties.unit_no , 1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 2 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' , '-' , '&' ) then trim ( substr ( upper ( properties.unit_no ) , 2 , 1 ) )
        when substr ( properties.unit_no , 2 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 3 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' , '-' , '&' ) then trim ( substr ( upper ( properties.unit_no ) , 3 , 1 ) )
        when substr ( properties.unit_no , 3 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) and substr ( properties.unit_no , 4 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' , '-' , '&' ) then trim ( substr ( upper ( properties.unit_no ) , 4 , 1 ) )
        else ''
     end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when substr ( properties.unit_no , 2 , 1 ) in ( '-' , '&' , '/' ) then trim ( substr ( properties.unit_no , 3 , 99 ) )
        when substr ( properties.unit_no , 3 , 1 ) in ( '-' , '&' , '/' ) then trim ( substr ( properties.unit_no , 4 , 99 ) )
        else ''
    end as blg_unit_id_2,
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
    '' as house_prefix_1,
    case
        when substr ( properties.house_no , 2 , 1 ) = '-' then trim ( substr ( properties.house_no , 1 , 1 ) )
        when substr ( properties.house_no , 3 , 1 ) = '-' then trim ( substr ( properties.house_no , 1 , 2 ) )
        when substr ( properties.house_no , 4 , 1 ) = '-' then trim ( substr ( properties.house_no , 1 , 3 ) )
        when substr ( properties.house_no , 5 , 1 ) = '-' then trim ( substr ( properties.house_no , 1 , 4 ) )
        when substr ( properties.house_no , -1 , 1 ) not in ( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ) then substr ( properties.house_no , 1 , length ( properties.house_no ) -1 )
        else ifnull ( properties.house_no , '' )
    end as house_number_1,
    case
        when substr ( properties.house_no , -1 , 1 ) not in ( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ) then substr ( upper ( properties.house_no ) , -1 , 1 )
        else ''
    end as house_suffix_1,
    '' as house_prefix_2,
    case
        when substr ( properties.house_no , 2 , 1 ) = '-' then trim ( substr ( properties.house_no , 3 , 99 ) )
        when substr ( properties.house_no , 3 , 1 ) = '-' then trim ( substr ( properties.house_no , 4 , 99 ) )
        when substr ( properties.house_no , 4 , 1 ) = '-' then trim ( substr ( properties.house_no , 5 , 99 ) )
        when substr ( properties.house_no , 5 , 1 ) = '-' then trim ( substr ( properties.house_no , 6 , 99 ) )
        else ''
    end as house_number_2,
    '' as house_suffix_2,
    upper ( streets.street_name ) as road_name,
    ifnull ( upper ( streets.street_type ) , '' ) as road_type,
    '' as road_suffix,
    upper ( properties.suburb ) as locality_name,
    properties.post_code as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '382' as lga_code,
    '' as crefno,
    '' as summary
from
    synergysoft_properties as properties join
    synergysoft_streets as streets on properties.street_code = streets.street_code
where
    properties.rate_code not in ( '07' , '08' , '11' , '12' , '99' )
)
)
)
