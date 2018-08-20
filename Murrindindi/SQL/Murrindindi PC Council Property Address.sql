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
    cast ( auprparc.ass_num as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    case
        when auprparc.pcl_num = ( select t.pcl_num from authority_auprparc t where t.ass_num = auprparc.ass_num and t.pcl_flg in ( 'R' , 'P' ) order by ifnull ( t.str_seq , 1 ), t.pcl_num limit 1 ) then 'Y'
        else 'N'
    end as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    ifnull ( cast ( auprstad.pcl_unt as varchar ) , '' ) as blg_unit_id_1,
    ifnull ( auprstad.unt_alp , '' ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    '' as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    '' as floor_type,
    ifnull ( auprstad.flo_pre , '' ) as floor_prefix_1,
    ifnull ( auprstad.flo_num , '' ) as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    ifnull ( cast ( auprstad.hou_num as varchar ) , '' ) as house_number_1,
    ifnull ( auprstad.hou_alp , '' ) as house_suffix_1,
    '' as house_prefix_2,
    ifnull ( cast ( auprstad.hou_end as varchar ) , '' ) as house_number_2,
    ifnull ( auprstad.end_alp , '' ) as house_suffix_2,
    case
        when upper ( auprstad.str_nme ) = 'PARK AVENUE NORTH' then 'PARK'
        when upper ( auprstad.str_nme ) = 'HILLSIDE (SOUTH)' then 'HILLSIDE'
        when upper ( auprstad.str_nme ) = 'GHIN GHIN (SEYMOUR)' then 'GHIN GHIN'
        when upper ( auprstad.str_nme ) like '%&%' then replace ( upper ( auprstad.str_nme ) , '&' , 'AND' )
        else replace ( upper ( auprstad.str_nme ) , '''' , '' )
    end as road_name,
    case
        when upper ( auprstad.str_nme ) like '% AVENUE NORTH' then 'AVENUE'
        else case upper ( auprstad.str_typ )
            when 'AV' then 'AVENUE'
            when 'CH' then 'CHASE'
            when 'CL' then 'CLOSE'
            when 'CR' then 'CRESCENT'
            when 'CT' then 'COURT'
            when 'DR' then 'DRIVE'
            when 'GR' then 'GROVE'
            when 'HTS' then 'HEIGHTS'
            when 'HWY' then 'HIGHWAY'
            when 'HILL' then 'HILL'
            when 'LA' then 'LANE'
            when 'NUL' then ''
            when 'PDE' then 'PARADE'
            when 'PL' then 'PLACE'
            when 'RD' then 'ROAD'
            when 'RL' then 'RISE'
            when 'RND' then 'ROUND'
            when 'ST' then 'STREET'
            when 'TCE' then 'TERRACE'
            when 'TR' then 'TRACK'
            when 'WY' then 'WAY'
            when 'WYND' then 'WYND'
            else ifnull ( upper ( auprstad.str_typ ) , '' )
        end
    end as road_type,
    case
        when upper ( auprstad.str_nme ) like '% AVENUE NORTH' then 'N'
        when upper ( auprstad.str_nme ) like '% (SOUTH)' then 'S'
        else ''
    end as road_suffix,
    upper ( auprstad.sbr_nme ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '355' as lga_code,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    '' as summary
from
    authority_auprparc as auprparc ,
    authority_auprstad as auprstad
where
    auprparc.pcl_num = auprstad.pcl_num and
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num <> 0 and
    auprstad.seq_num = 0
order by auprparc.ass_num, auprparc.pcl_num
)
)
)
