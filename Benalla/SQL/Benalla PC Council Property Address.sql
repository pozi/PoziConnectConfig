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
    assess as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when substr ( address__1 , 2 , 1 ) = '/' then substr ( address__1 , 1 , 1 )
        when substr ( address__1 , 3 , 1 ) = '/' then substr ( address__1 , 1 , 2 )
        when substr ( address__1 , 4 , 1 ) = '/' then substr ( address__1 , 1 , 3 )
        else ''
    end as blg_unit_id_1,
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
    '' as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    case
        when [house_no.] = '' then ''
        when substr ( trim ( [house_no.] ) , -1 , 1 ) not in ( '0' , '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' ) then substr ( trim ( [house_no.] ) , 1 , length ( trim ( [house_no.] ) - 1 ) )
        when cast ( cast ( [house_no.] as integer ) as varchar ) = [house_no.] then [house_no.]
        when substr ( trim ( [house_no.] ) , 2 , 1 ) = '-' then substr ( trim ( [house_no.] ) , 1 , 1 )
        when substr ( trim ( [house_no.] ) , 3 , 1 ) = '-' then substr ( trim ( [house_no.] ) , 1 , 2 )
        when substr ( trim ( [house_no.] ) , 4 , 1 ) = '-' then substr ( trim ( [house_no.] ) , 1 , 3 )
    end as house_number_1,
    case    
        when [house_no.] like '%-%' then ''
        when substr ( trim ( [house_no.] ) , -1 , 1 ) not in ( '0' , '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' ) then substr ( trim ( [house_no.] ) , -1 , 1 )
        else ''        
    end as house_suffix_1,
    '' as house_prefix_2,
    case
        when substr ( trim ( [house_no.] ) , 2 , 1 ) = '-' then cast ( cast ( substr ( trim ( [house_no.] ) , 3 , 99 ) as integer ) as varchar )
        when substr ( trim ( [house_no.] ) , 3 , 1 ) = '-' then cast ( cast ( substr ( trim ( [house_no.] ) , 4 , 99 ) as integer ) as varchar )
        when substr ( trim ( [house_no.] ) , 4 , 1 ) = '-' then cast ( cast ( substr ( trim ( [house_no.] ) , 5 , 99 ) as integer ) as varchar )
        else ''
    end as house_number_2,
    case    
        when [house_no.] like '%-%' and substr ( trim ( [house_no.] ) , -1 , 1 ) not in ( '0' , '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' ) then substr ( trim ( [house_no.] ) , -1 , 1 )
        else ''        
    end as house_suffix_2,    
    case
        when street_name like '% Road North' then upper ( replace ( street_name , ' Road North' , '' ) )
        when street_name like '% Street East' then upper ( replace ( street_name , ' Street East' , '' ) )
        when street_name like '% Street North' then upper ( replace ( street_name , ' Street North' , '' ) )
        when street_name like '% Street South' then upper ( replace ( street_name , ' Street South' , '' ) )
        when street_name like '% Street West' then upper ( replace ( street_name , ' Street West' , '' ) )
        when street_name like '% Avenue%' then upper ( replace ( street_name , ' Avenue' , '' ) )
        when street_name like '% Close%' then upper ( replace ( street_name , ' Close' , '' ) )
        when street_name like '% Court%' then upper ( replace ( street_name , ' Court' , '' ) )
        when street_name like '% Crescent%' then upper ( replace ( street_name , ' Crescent' , '' ) )
        when street_name like '% Drive%' then upper ( replace ( street_name , ' Drive' , '' ) )
        when street_name like '% Grove%' then upper ( replace ( street_name , ' Grove' , '' ) )
        when street_name like '% Highway%' then upper ( replace ( street_name , ' Highway' , '' ) )
        when street_name like '% Lane%' then upper ( replace ( street_name , ' Lane' , '' ) )
        when street_name like '% Parade%' then upper ( replace ( street_name , ' Parade' , '' ) )
        when street_name like '% Place%' then upper ( replace ( street_name , ' Place' , '' ) )
        when street_name like '% Rise%' then upper ( replace ( street_name , ' Rise' , '' ) )
        when street_name like '% Road%' then upper ( replace ( street_name , ' Road' , '' ) )
        when street_name like '% Street%' then upper ( replace ( street_name , ' Street' , '' ) )
        when street_name like '% Track%' then upper ( replace ( street_name , ' Track' , '' ) )
        else upper ( street_name )
    end as road_name, 
    case
        when street_name like '% Avenue%' then 'AVENUE'
        when street_name like '% Close%' then 'COLOSE'
        when street_name like '% Court%' then 'COURT'
        when street_name like '% Crescent%' then 'CRESCENT'
        when street_name like '% Drive%' then 'DRIVE'
        when street_name like '% Grove%' then 'GROVE'
        when street_name like '% Highway%' then 'HIGHWAY'
        when street_name like '% Lane%' then 'LANE'
        when street_name like '% Parade%' then 'PARADE' 
        when street_name like '% Place%' then 'PLACE' 
        when street_name like '% Rise%' then 'RISE' 
        when street_name like '% Road%' then 'ROAD'
        when street_name like '% Street%' then 'STREET' 
        when street_name like '% Track%' then 'TRACK' 
        else ''
    end as road_type,
    case
        when street_name like '% East' then 'E'
        when street_name like '% North' then 'N'
        when street_name like '% South' then 'S'
        when street_name like '% West' then 'W'
        else ''
    end as road_suffix,
    upper ( suburb ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '381' as lga_code,
    '' as crefno,
    upper ( trim ( replace ( substr ( address__1 || ' ' || address__2 , 1 , length ( address__1 || ' ' || address__2 ) - 5 ) , ' VIC' , '' ) ) ) as summary
from
    synergysoft
where
    curr_assess <> 'X' and
    type not in ( 'D' , 'Z' )
)
)
)