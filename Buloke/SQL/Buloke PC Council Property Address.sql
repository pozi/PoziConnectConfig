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
    cast ( Property.Property as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as location_descriptor,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    ifnull ( Property.UnitNo , '' ) as blg_unit_id_1,
    '' as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    '' as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    '' as floor_type,
    '' as floor_prefix_1,
    '' as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    ifnull ( upper ( Property.Name ) , '' ) as building_name,
    '' as complex_name,
    '' as house_prefix_1,
    case
        when substr ( Property.StreetNoFrom , 1 , 1 ) not in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then ''
        when substr ( Property.StreetNoFrom , -1 , 1 ) in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then Property.StreetNoFrom
        else ifnull ( substr ( Property.StreetNoFrom , 1 , length ( Property.StreetNoFrom ) - 1 ) , '' )
    end as house_number_1,
    case
        when substr ( Property.StreetNoFrom , 1 , 1 ) not in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then ''
        when substr ( Property.StreetNoFrom , -1 , 1 ) in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then ''
        else ifnull ( upper ( substr ( Property.StreetNoFrom , -1 , 1 ) ) , '' )
    end as house_suffix_1,
    '' as house_prefix_2,
    case
        when substr ( Property.StreetNoTo , 1 , 1 ) not in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then ''
        when substr ( Property.StreetNoTo , -1 , 1 ) in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then Property.StreetNoTo
        else ifnull ( substr ( Property.StreetNoTo , 1 , length ( Property.StreetNoTo ) - 1 ) , '' )
    end as house_number_2,
    case
        when substr ( Property.StreetNoTo , 1 , 1 ) not in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then ''
        when substr ( Property.StreetNoTo , -1 , 1 ) in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') then ''
        else ifnull ( upper ( substr ( Property.StreetNoTo , -1 , 1 ) ) , '' )
    end as house_suffix_2,
    case
        when Street.Name = 'Jeffcott South School Bus' then 'JEFFCOTT SOUTH SCHOOL BUS ROUTE'
        else replace ( upper ( Street.Name ) , ' - ' , '-' )
    end as road_name,
    case
        when StreetType.Type = 'Route Road' then 'ROAD'
        when StreetType.Type like 'Road %' then 'ROAD'
        when StreetType.Type like 'Street %' then 'STREET'
        else upper ( ifnull ( StreetType.Type , '' ) )
    end as road_type,
    case
        when StreetType.Type like '% North' then 'N'
        when StreetType.Type like '% South' then 'S'
        when StreetType.Type like '% East' then 'E'
        when StreetType.Type like '% West' then 'W'
        else ''
    end as road_suffix,
    upper ( Locality.Locality ) as locality_name,
    Locality.Postcode as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '309' as lga_code,
    '' as crefno,
    '' as summary
from
    lynx_vwpropertyclassification Classification,
    lynx_propertys Property,
    lynx_streets Street,
    lynx_streettype StreetType,
    lynx_localities Locality
where
    Classification.PropertyNumber = Property.Property and
    Property.StreetID = Street.ID and
    Street.Type = StreetType.ID and
    Street.Locality = Locality.ID and
    Property.Type not in ( 672 , 700 ) and
    Classification.LandClassificationCode <> '010'
)
)
)