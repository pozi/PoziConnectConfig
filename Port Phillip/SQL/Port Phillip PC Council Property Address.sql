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
    cast ( P.prop_id as varchar ) as propnum,
    case P.prop_status_ind
        when 'F' then 'P'
        else ''
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when a.fmt_address like 'ABOVE %' then 'ABOVE'
        when a.fmt_address like 'BELOW %' then 'BELOW'
        when a.fmt_address like 'REAR %' then 'REAR'
        else ''
    end as location_descriptor,
    case
        when upper ( a.unit_desc ) in ('','ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then upper ( a.unit_desc )
        else ''
    end as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when A.unit_no = '0' then ''
        else ifnull ( A.unit_no , '' )
    end as blg_unit_id_1,
    case
        when A.unit_no = '0' then ''
        when A.property_text_1 like '-%' then ''
		else upper ( ifnull ( A.property_text_1 , '' ) )
	end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when A.property_text_1 like '-%' then replace ( A.property_text_1 , '-' , '' )
        else ''
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
    ifnull ( A.property_text_3 , '' ) as house_prefix_1,
    case
        when A.house_no = '0' then ''
        else ifnull ( A.house_no , '' )
    end as house_number_1,
    upper ( ifnull ( A.property_text_4 , '' ) ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when A.house_no_to = '0' then ''
        else ifnull ( A.house_no_to , '' )
    end as house_number_2,
    upper ( ifnull ( A.property_text_6 , '' ) ) as house_suffix_2,
    street_comp_desc_1 as road_name,
    street_comp_desc_2 as road_type,
    street_comp_desc_3 as road_suffix,
    street_comp_desc_4 as locality_name,
    street_comp_desc_5 as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '358' as lga_code,
    '' as crefno,
    a.fmt_address as summary
from
    techone_nucproperty P
    join techone_nucaddress A on A.prop_id = P.prop_id
    join techone_nucstreet S on S.street_id = A.street_id
where
    P.prop_status_ind in ( 'C' , 'F' )
)
)
)
