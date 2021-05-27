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
    case
        when auprstad.pcl_unt > 100 and auprstad.pcl_unt < 2000 then 'Y'
        when length ( replace ( auprstad.flo_num , '/' , '' ) ) = 3 then 'Y'
        else ''
    end as hsa_flag,
    case
        when auprstad.pcl_unt > 100 and auprstad.pcl_unt < 2000 then cast ( auprstad.pcl_unt as varchar ) || ifnull ( auprstad.unt_alp , '' )
        when length ( replace ( auprstad.flo_num , '/' , '' ) ) = 3 then replace ( auprstad.flo_num , '/' , '' )
        else ''
    end as hsa_unit_id,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when auprstad.pcl_unt <= 100 or auprstad.pcl_unt >= 2000 then cast ( auprstad.pcl_unt as varchar )
        else ''
    end as blg_unit_id_1,
    case
        when auprstad.pcl_unt <= 100 or auprstad.pcl_unt >= 2000 then ifnull ( auprstad.unt_alp , '' )
        else ''
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    ifnull ( auprstad.unt_end , '' ) as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    '' as floor_type,
    ifnull ( auprstad.flo_pre , '' ) as floor_prefix_1,
    case
        when length ( replace ( auprstad.flo_num , '/' , '' ) ) < 3 then auprstad.flo_num
        else ''
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    ifnull ( auprstad.hou_num , '' ) as house_number_1,
    upper ( ifnull ( auprstad.hou_alp , '' ) ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when auprstad.hou_num = auprstad.hou_end and ifnull ( auprstad.end_alp , '' ) = '' then ''
        else ifnull ( auprstad.hou_end , '' )
    end as house_number_2,
    upper ( ifnull ( auprstad.end_alp , '' ) ) as house_suffix_2,
    case
        when upper ( auprstad.str_nme ) like 'AUSTIN CRES%' then 'AUSTIN'
        when upper ( auprstad.str_nme ) like 'ORDNANCE RES%' then 'ORDNANCE'
        when upper ( auprstad.str_nme ) like 'MAGNOLIA PATH%' then 'MAGNOLIA'
        when upper ( auprstad.str_nme ) like '%FARRELL%' then 'OFARRELL'
        else upper ( auprstad.str_nme )
    end as road_name,
    case
        when trim ( upper ( auprstad.str_typ ) ) in ( 'AV' , 'AVE' ) then 'AVENUE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'BLVD' , 'BVD' ) then 'BOULEVARD'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'CCT' , 'CRCT' ) then 'CIRCUIT'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'CL' ) then 'CLOSE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'CR' , 'CRES' ) then 'CRESCENT'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'CRT' , 'CT' ) then 'COURT'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'DR' , 'DVE' ) then 'DRIVE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'GR' , 'GV' , 'GVE' ) then 'GROVE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'LA' , 'LN' , 'LNE' , 'LANE' ) then 'LANE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'PATH' ) then 'PATH'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'PDE' ) then 'PARADE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'PKY' , 'PKWY' , 'PWY' ) then 'PARKWAY'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'PL' ) then 'PLACE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'RD' , 'ROAD' ) then 'ROAD'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'RES' ) then 'RESERVE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'RI' , 'RISE' ) then 'RISE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'SQ' ) then 'SQUARE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'ST' , 'SS' , 'SN' ) then 'STREET'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'TCE' ) then 'TERRACE'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'VIEW' , 'VW' ) then 'VIEW'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'WALK' , 'WK' ) then 'WALK'
        when trim ( upper ( auprstad.str_typ ) ) in ( 'WAY' , 'WY' ) then 'WAY'
        when upper ( auprstad.str_nme ) like 'AUSTIN CRES%' then 'CRESCENT'
        when upper ( auprstad.str_nme ) like 'ORDNANCE RES%' then 'RESERVE'
        when upper ( auprstad.str_nme ) like 'MAGNOLIA PATH%' then 'PATH'
        when upper ( auprstad.str_nme ) like 'THE %' then ''
		else ifnull ( auprstad.str_typ , '' )
    end as road_type,
    case
        when auprstad.str_nme like '% N' then 'N'
        when auprstad.str_nme like '% S' then 'S'
        when auprstad.str_nme like '% E' then 'E'
        when auprstad.str_nme like '% W' then 'W'
        else ''
    end as road_suffix,
    upper ( trim ( auprstad.sbr_nme ) ) as locality_name,
    ifnull ( ausrsubr.pst_cde , '' ) as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '341' as lga_code,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    '' as summary
from
    authority_auprparc auprparc inner join
    authority_auprstad auprstad ON auprparc.pcl_num = auprstad.pcl_num left outer join
    authority_ausrsubr ausrsubr ON auprstad.sbr_nme = ausrsubr.sbr_nme
where
    auprparc.pcl_flg in ( 'R' , 'U' , 'P' ) and
    auprparc.ass_num not in ( '' , '0' ) and
    auprstad.seq_num = 0
)
)
)
