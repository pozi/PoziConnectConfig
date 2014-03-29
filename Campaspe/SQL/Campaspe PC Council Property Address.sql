select
    cast ( cast ( a.ASS_INTERNAL_ID as integer ) as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,    
    case
        when ASS_HOUSE_NO_PREFIX like 'FACTORY%' then 'FACT'
        when ASS_HOUSE_NO_PREFIX like 'FLAT%' then 'FLAT'
        when ASS_HOUSE_NO_PREFIX like 'HALL%' then 'HALL'
        when ASS_HOUSE_NO_PREFIX like 'OFFICE%' then 'OFFC'
        when ASS_HOUSE_NO_PREFIX like 'SHED%' then 'SHED'
        when ASS_HOUSE_NO_PREFIX like 'SHOP%' then 'SHOP'
        when ASS_HOUSE_NO_PREFIX like 'SILO%' then 'SILO'
        when ASS_HOUSE_NO_PREFIX like 'SUITE%' then 'SE'
        when ASS_HOUSE_NO_PREFIX like 'UNIT%' then 'UNIT'
        else ''
    end as blg_unit_type,
    '' as blg_unit_prefix_1,    
    case
        when ASS_HOUSE_NO_PREFIX in ( 'ABOVE' , 'OFF' , '(OFF)' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then ''
        when ASS_HOUSE_NO_PREFIX like 'FACTORY%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 8))
        when ASS_HOUSE_NO_PREFIX like 'FLAT%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 5))
        when ASS_HOUSE_NO_PREFIX like 'HALL%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 5))
        when ASS_HOUSE_NO_PREFIX like 'OFFICE%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 7))
        when ASS_HOUSE_NO_PREFIX like 'SHED%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 5))
        when ASS_HOUSE_NO_PREFIX like 'SHOP%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 5))
        when ASS_HOUSE_NO_PREFIX like 'SILO%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 5))
        when ASS_HOUSE_NO_PREFIX like 'SUITE%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 6))
        when ASS_HOUSE_NO_PREFIX like 'UNIT%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 5))
        when upper(substr(ASS_HOUSE_NO_PREFIX, -1)) between 'A' and 'Z' then substr(ASS_HOUSE_NO_PREFIX,1,length(ASS_HOUSE_NO_PREFIX)-1)
        when ASS_HOUSE_NO_PREFIX like '%-%' then 'XXXX'
        when ASS_HOUSE_NO_PREFIX like '%&%' then 'XXXX'
        else ifnull ( ASS_HOUSE_NO_PREFIX , '' )
    end as blg_unit_id_1,
    case
        when ASS_HOUSE_NO_PREFIX in ( 'ABOVE' , 'OFF' , '(OFF)' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then ''
        when upper(substr(ASS_HOUSE_NO_PREFIX, -1)) between 'A' and 'Z' then upper(substr(ASS_HOUSE_NO_PREFIX, -1))
        else ''
    end as blg_unit_suffix_1,
     '' as blg_unit_prefix_2,
    case
        when ASS_HOUSE_NO_PREFIX like '%-%' then 'XXXX'
        when ASS_HOUSE_NO_PREFIX like '%&%' then 'XXXX'
        else ''
    end as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    case
        when ASS_HOUSE_NO_PREFIX like 'GROUND%' then 'GND'
        else ''
    end as floor_type,
    '' as floor_prefix_1, 
    case
        when ASS_HOUSE_NO_PREFIX like 'LEVEL%' then ltrim(substr(ASS_HOUSE_NO_PREFIX, 6))
        else ''
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    case
        when ASS_HOUSE_NO_PREFIX in ( 'OFF' , '(OFF)' ) then 'OFF'
        when ASS_HOUSE_NO_PREFIX in ( 'ABOVE' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then ASS_HOUSE_NO_PREFIX
        when ASS_HOUSE_NO_SUFFIX in ( 'OFF' , '(OFF)' ) then 'OFF'
        when ASS_HOUSE_NO_SUFFIX in ( 'ABOVE' , 'REAR' , 'UPPER' , 'UPSTAIRS' ) then ASS_HOUSE_NO_PREFIX
        else ''
    end as location_descriptor,
    '' as house_prefix_1,
    cast ( cast ( ASS_HOUSE_NUMBER as integer ) as varchar ) as house_number_1,
    case
        when ASS_HOUSE_NO_SUFFIX like '-%' then ''
        else ifnull ( ASS_HOUSE_NO_SUFFIX , '' )
    end as house_suffix_1,
    '' as house_prefix_2,    
    case
        when ASS_HOUSE_NO_SUFFIX like '-%' then substr ( ASS_HOUSE_NO_SUFFIX , 2 , 99 )
        when ASS_HOUSE_NO_SUFFIX like '&%' then substr ( ASS_HOUSE_NO_SUFFIX , 2 , 99 )
        else ''
    end as house_number_2,
    '' as house_suffix_2,
    case
        when s.DESCRIPTION like '% ALLEY%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' ALLEY', 1, 1) - 1 )
        when s.DESCRIPTION like '% AVENUE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' AVENUE', 1, 1) - 1 )
        when s.DESCRIPTION like '% CIRCUIT%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' CIRCUIT', 1, 1) - 1 )
        when s.DESCRIPTION like '% CLOSE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' CLOSE', 1, 1) - 1 )
        when s.DESCRIPTION like '% CRESCENT%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' CRESCENT', 1, 1) - 1 )
        when s.DESCRIPTION like '% COURT%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' COURT', 1, 1) - 1 )
        when s.DESCRIPTION like '% DRIVE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' DRIVE', 1, 1) - 1 )
        when s.DESCRIPTION like '% ESPLANADE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' ESPLANADE', 1, 1) - 1 )
        when s.DESCRIPTION like '% GROVE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' GROVE', 1, 1) - 1 )
        when s.DESCRIPTION like '% HWY%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' HWY', 1, 1) - 1 )
        when s.DESCRIPTION like '% HIGHWAY%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' HIGHWAY', 1, 1) - 1 )
        when s.DESCRIPTION like '% LANE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' LANE', 1, 1) - 1 )
        when s.DESCRIPTION like '% PARADE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' PARADE', 1, 1) - 1 )
        when s.DESCRIPTION like '% PLACE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' PLACE', 1, 1) - 1 )
        when s.DESCRIPTION like '% ROAD%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' ROAD', 1, 1) - 1 )
        when s.DESCRIPTION like '% STREET%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' STREET', 1, 1) - 1 )
        when s.DESCRIPTION like '% TRACK%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' TRACK', 1, 1) - 1 )
        when s.DESCRIPTION like '% TERRACE%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' TERRACE', 1, 1) - 1 )
        when s.DESCRIPTION like '% WALK%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' WALK', 1, 1) - 1 )
        when s.DESCRIPTION like '% WAY%' then substr ( s.DESCRIPTION , 1 , INSTR(s.DESCRIPTION,' WAY', 1, 1) - 1 )
        else s.DESCRIPTION
    end as road_name,
    case
        when s.DESCRIPTION like '% AVENUE%' then 'AVENUE'
        when s.DESCRIPTION like '% CIRCUIT%' then 'CIRCUIT'
        when s.DESCRIPTION like '% CLOSE%' then 'CLOSE'
        when s.DESCRIPTION like '% CRESCENT%' then 'CRESCENT'
        when s.DESCRIPTION like '% COURT%' then 'COURT'
        when s.DESCRIPTION like '% DRIVE%' then 'DRIVE'
        when s.DESCRIPTION like '% ESPLANADE%' then 'ESPLANADE'
        when s.DESCRIPTION like '% GROVE%' then 'GROVE'
        when s.DESCRIPTION like '% HWY%' then 'HIGHWAY'
        when s.DESCRIPTION like '% HIGHWAY%' then 'HIGHWAY'
        when s.DESCRIPTION like '% LANE%' then 'LANE'
        when s.DESCRIPTION like '% PARADE%' then 'PARADE'
        when s.DESCRIPTION like '% PLACE%' then 'PLACE'
        when s.DESCRIPTION like '% ROAD%' then 'ROAD'
        when s.DESCRIPTION like '% STREET%' then 'STREET'
        when s.DESCRIPTION like '% PARADE%' then 'PARADE'
        when s.DESCRIPTION like '% TERRACE%' then 'TERRACE'
        when s.DESCRIPTION like '% TRACK%' then 'TRACE'
        when s.DESCRIPTION like '% WALK%' then 'WALK'
        when s.DESCRIPTION like '% WAY%' then 'WAY'
        else ''
    end as road_type,
    case
        when s.DESCRIPTION like '% NORTH' then 'N'
        when s.DESCRIPTION like '% SOUTH' then 'S'
        when s.DESCRIPTION like '% EAST' then 'E'
        when s.DESCRIPTION like '% WEST' then 'W'
        else ''
    end as road_suffix,
    '' as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '310' as lga_code,
    '' as crefno,
    ASS_ADDRESS2 as summary
from
    fujitsu_pr_assessadd_view a,
    fujitsu_pr_street s,
    fujitsu_pr_assessment p
where
    a.ASS_STREET_ID = s.STREET_ID and
    p.ASS_INTERNAL_ID = a.ASS_INTERNAL_ID and
    p.DELETE_FLAG is null
