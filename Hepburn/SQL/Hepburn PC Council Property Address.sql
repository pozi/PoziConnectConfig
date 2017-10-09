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
    cast ( P.property_no as varchar ) as propnum,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when a.formatted_address like 'ABOVE %' then 'ABOVE'
        when a.formatted_address like 'BELOW %' then 'BELOW'
        when a.formatted_address like 'REAR %' then 'REAR'
        else ''
    end as location_descriptor,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when A.unit_no = '0' then ''
        else ifnull ( A.unit_no , '' )
    end as blg_unit_id_1,
    upper ( ifnull ( A.unit_no_suffix , '' ) ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when A.unit_no_to = '0' then ''
        else ifnull ( A.unit_no_to , '' )
    end as blg_unit_id_2,
    upper ( ifnull ( A.unit_no_to_suffix , '' ) ) as blg_unit_suffix_2,
    '' as floor_type,
    '' as floor_prefix_1,
    case
        when A.floor_no = '0' then ''
        else ifnull ( A.floor_no , '' )
    end as floor_no_1,
    upper ( ifnull ( A.floor_suffix , '' ) ) as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when A.floor_no_to = '0' then ''
        else ifnull ( A.floor_no_to , '' )
    end as floor_no_2,
    upper ( ifnull ( A.floor_suffix_to , '' ) ) as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as house_prefix_1,
    case
        when A.house_no = '0' then ''
        else ifnull ( A.house_no , '' )
    end as house_number_1,
    upper ( ifnull ( A.house_no_suffix , '' ) ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when A.house_no_to = '0' then ''
        else ifnull ( A.house_no_to , '' )
    end as house_number_2,
    upper ( ifnull ( A.house_no_to_suffix , '' ) ) as house_suffix_2,
    case
        when upper ( S.street_name ) like 'THE %' then upper ( S.street_name )
        when upper ( substr ( S.street_name , -5 ) ) in ( ' LANE' , ' RISE' , ' ROAD' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 5 ) )
        when upper ( substr ( S.street_name , -6 ) ) in ( ' CLOSE' , ' COURT' , ' DRIVE' , ' GROVE' , ' PLACE' , ' TRACK' , ' TRAIL' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 6 ) )
        when upper ( substr ( S.street_name , -7 ) ) in ( ' AVENUE' , ' PARADE' , ' SQUARE' , ' STREET' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 7 ) )
        when upper ( substr ( S.street_name , -8 ) ) in ( ' HIGHWAY' , ' TERRACE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 8 ) )
        when upper ( substr ( S.street_name , -9 ) ) in ( ' CRESCENT' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 9 ) )
        when upper ( substr ( S.street_name , -12 ) ) in ( ' STREET EAST' , ' STREET WEST' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 12 ) )
        when upper ( substr ( S.street_name , -13 ) ) in ( ' STREET NORTH' , ' STREET SOUTH' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 13 ) )
        else upper ( S.street_name )
    end as road_name,
    case
        when S.street_name like 'THE %' then ''
        when S.street_name like '% AVENUE' then 'AVENUE'
        when S.street_name like '% CLOSE' then 'CLOSE'
        when S.street_name like '% CRESCENT' then 'CRESCENT'
        when S.street_name like '% COURT' then 'COURT'
        when S.street_name like '% DRIVE' then 'DRIVE'
        when S.street_name like '% GROVE' then 'GROVE'
        when S.street_name like '% HIGHWAY' then 'HIGHWAY'
        when S.street_name like '% LANE' then 'LANE'
        when S.street_name like '% PARADE' then 'PARADE'
        when S.street_name like '% PLACE' then 'PLACE'
        when S.street_name like '% RISE' then 'RISE'
        when S.street_name like '% ROAD' then 'ROAD'
        when S.street_name like '% SQUARE' then 'SQUARE'
        when S.street_name like '% STREET' then 'STREET'
        when S.street_name like '% STREET NORTH' then 'STREET'
        when S.street_name like '% STREET SOUTH' then 'STREET'
        when S.street_name like '% STREET EAST' then 'STREET'
        when S.street_name like '% STREET WEST' then 'STREET'
        when S.street_name like '% TERRACE' then 'TERRACE'
        when S.street_name like '% TRACK' then 'TRACK'
        when S.street_name like '% TRAIL' then 'TRAIL'
        else ''
    end as road_type,
    case
        when S.street_name like '% NORTH' then 'N'
        when S.street_name like '% SOUTH' then 'S'
        when S.street_name like '% EAST' then 'E'
        when S.street_name like '% WEST' then 'W'
        else ''
    end as road_suffix,
    L.locality_name as locality_name,
    L.postcode as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '329' as lga_code,
    '' as crefno,
    a.formatted_address as summary
from
    techone_nucproperty P
    join techone_nucaddress A on A.property_no = P.property_no
    join techone_nucstreet S on S.street_no = A.street_no
    join techone_nuclocality L on L.locality_ctr = S.locality_ctr
where
    P.status in ( 'C' , 'F' ) and
    P.property_no <> 1
)
)
)
