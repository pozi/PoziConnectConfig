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

select distinct
    cast ( Assessment.Assess_Number as varchar ) ||
        case
            when substr ( Assessment.Assess_Number , -7 , 1 ) = '.' then ''
            when substr ( Assessment.Assess_Number , -6 , 1 ) = '.' then '0'
            when substr ( Assessment.Assess_Number , -5 , 1 ) = '.' then '00'
            when substr ( Assessment.Assess_Number , -4 , 1 ) = '.' then '000'
            when substr ( Assessment.Assess_Number , -3 , 1 ) = '.' then '0000'
            when substr ( Assessment.Assess_Number , -2 , 1 ) = '.' then '00000'
        end as propnum,
    '' as status,
    '' as base_propnum,
    case
        when Title.Title_Status_Id = '3' then ''
        when Address.Addr_Is_Primary_Address = '0' then 'N'
        when
            (
                Assessment.Property_Name_Address_Locality not like
                    '%' ||
                    cast ( ifnull ( Address.Addr_Building_Unit_Number_1 , '' ) as varchar ) ||
                    '%' ||
                    cast ( ifnull ( Address.Addr_House_Number_1 , '' ) as varchar ) ||
                    '%' or
                ifnull ( Address.Addr_House_Number_1 , '' ) = ''
            )
            and
                ( Assessment.Property_Name_Address_Locality like '%1%' or
                  Assessment.Property_Name_Address_Locality like '%2%' or
                  Assessment.Property_Name_Address_Locality like '%3%' or
                  Assessment.Property_Name_Address_Locality like '%4%' or
                  Assessment.Property_Name_Address_Locality like '%5%' or
                  Assessment.Property_Name_Address_Locality like '%6%' or
                  Assessment.Property_Name_Address_Locality like '%7%' or
                  Assessment.Property_Name_Address_Locality like '%8%' or
                  Assessment.Property_Name_Address_Locality like '%9%' ) then 'N'
        when
            Assessment.Property_Name_Address_Locality like '%-' || cast ( ifnull ( Address.Addr_House_Number_1 , '' ) as varchar ) || ' %' and
            Assessment.Property_Name_Address_Locality not like cast ( ifnull ( Address.Addr_House_Number_1 , '' ) as varchar ) || '-%' then 'N'
        when
            Assessment.Property_Name_Address_Locality like '%' ||
            ifnull ( Address.Addr_Building_Unit_Number_1 || ifnull ( Address.Addr_Building_Unit_Suffix_1 , '' ) || ifnull ( '-' || Address.Addr_Building_Unit_Number_2  || ifnull ( Address.Addr_Building_Unit_Suffix_2 , '' ) , '' ) || '/' , '' ) ||
            ifnull ( Address.Addr_House_Prefix_1 , '' ) || ifnull ( Address.Addr_House_Number_1 , '' ) || ifnull ( Address.Addr_House_Suffix_1 , '' ) ||
            ifnull ( '-' || ifnull ( Address.Addr_House_Prefix_2 , '' ) || Address.Addr_House_Number_2 , '' ) || ifnull ( Address.Addr_House_Suffix_2 , '' ) || ' ' ||
            ifnull ( Street.Street_Name , '' ) || '%' then 'Y'
        when
            Address.Addr_House_Number_1 is null and Assessment.Property_Name_Address_Locality like Street.Street_Name || '%' then 'Y'
        else ''
    end as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    upper ( ifnull ( Address.Building_Unit_Abbreviation , '' ) ) as blg_unit_type,
    upper ( ifnull ( Address.Addr_Building_Unit_Prefix_1 , '' ) ) as blg_unit_prefix_1,
    cast ( ifnull ( Address.Addr_Building_Unit_Number_1 , '' ) as varchar ) as blg_unit_id_1,
    upper ( ifnull ( Address.Addr_Building_Unit_Suffix_1 , '' ) ) as blg_unit_suffix_1,
    upper ( ifnull ( Address.Addr_Building_Unit_Prefix_2 , '' ) ) as blg_unit_prefix_2,
    cast ( ifnull ( Address.Addr_Building_Unit_Number_2 , '' ) as varchar ) as blg_unit_id_2,
    upper ( ifnull ( Address.Addr_Building_Unit_Suffix_2 , '' ) ) as blg_unit_suffix_2,
    upper ( ifnull ( Address.Address_Floor_Type_Abbrev , '' ) ) as floor_type,
    upper ( ifnull ( Address.Addr_Floor_Prefix_1 , '' ) ) as floor_prefix_1,
    cast ( ifnull ( Address.Addr_Floor_Number_1 , '' ) as varchar ) as floor_no_1,
    upper ( ifnull ( Address.Addr_Floor_Suffix_1 , '' ) ) as floor_suffix_1,
    upper ( ifnull ( Address.Addr_Floor_Prefix_2 , '' ) ) as floor_prefix_2,
    cast ( ifnull ( Address.Addr_Floor_Number_2 , '' ) as varchar ) as floor_no_2,
    upper ( ifnull ( Address.Addr_Floor_Suffix_2 , '' ) ) as floor_suffix_2,
    case upper ( Assessment.Assess_Property_Name )
        when 'OFF' then ''
        else upper ( ifnull ( Assessment.Assess_Property_Name , '' ) )
    end as building_name,
    '' as complex_name,
    case upper ( Assessment.Assess_Property_Name )
        when 'OFF' then 'OFF'
        else ''
    end as location_descriptor,
    upper ( ifnull ( Address.Addr_House_Prefix_1 , '' ) ) as house_prefix_1,
    cast ( ifnull ( Address.Addr_House_Number_1 , '' ) as varchar ) as house_number_1,
    upper ( ifnull ( Address.Addr_House_Suffix_1 , '' ) ) as house_suffix_1,
    upper ( ifnull ( Address.Addr_House_Prefix_2 , '' ) ) as house_prefix_2,
    cast ( ifnull ( Address.Addr_House_Number_2 , '' ) as varchar ) as house_number_2,
    upper ( ifnull ( Address.Addr_House_Suffix_2 , '' ) ) as house_suffix_2,
    upper ( ifnull ( Street.Street_Name , '' ) ) as road_name,
    upper ( ifnull ( Street_Type.Street_Type_Name , '' ) ) as road_type,
    case
        when upper ( Street.Street_Suffix ) in ( 'NORTH' , 'N' ) then 'N'
        when upper ( Street.Street_Suffix ) in ( 'SOUTH' , 'S' ) then 'S'
        when upper ( Street.Street_Suffix ) in ( 'EAST' , 'E' ) then 'E'
        when upper ( Street.Street_Suffix ) in ( 'WEST' , 'W' ) then 'W'
        when upper ( Street.Street_Suffix ) in ( 'EXTENSION' , 'EX' ) then 'EX'
        else ''
    end as road_suffix,
    upper ( ifnull ( Locality.Locality_Name , '' ) ) as locality_name,
    ifnull ( Locality.Locality_Postcode , '' ) as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '301' as lga_code,
    '' as crefno,
    Assessment.Property_Name_Address_Locality as summary
from
    propertygov_title as Title join
    propertygov_parcel_title as Parcel_Title on Title.Title_Id = Parcel_Title.Title_Id join
    propertygov_parcel as Parcel on Parcel_Title.Parcel_Id = Parcel.Parcel_Id join
    propertygov_assessment_parcel as Assessment_Parcel on Parcel.Parcel_Id = Assessment_Parcel.Parcel_Id join
    propertygov_assessment as Assessment on Assessment_Parcel.Assessment_Id = Assessment.Assessment_Id join
    propertygov_address as Address on Parcel.Address_Id = Address.Address_Id join
    propertygov_street_locality as Street_Locality on Address.Street_Locality_Id = Street_Locality.Street_Locality_Id join
    propertygov_street as Street on Street_Locality.Street_Id = Street.Street_Id join
    propertygov_locality as Locality on Street_Locality.Locality_Id = Locality.Locality_Id left join
    propertygov_street_type as Street_Type on Street.Street_Type_Abbreviation = Street_Type.Street_Type_Abbreviation
where
    Parcel.Parcel_Status = 0
)
)
)
