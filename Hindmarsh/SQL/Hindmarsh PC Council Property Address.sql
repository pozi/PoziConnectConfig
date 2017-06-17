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
    ifnull ( auprstad.unt_end , '' ) as blg_unit_id_2,
    ifnull ( auprstad.una_end , '' ) as blg_unit_suffix_2,
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
    case
        when auprstad.hou_num is null then ''
        when auprstad.hou_num = 0 then ''
        else cast ( auprstad.hou_num as varchar )
    end as house_number_1,
    ifnull ( upper ( auprstad.hou_alp ) , '' ) as house_suffix_1,
    '' as house_prefix_2,
    ifnull ( cast ( auprstad.hou_end as varchar ) , '' ) as house_number_2,
    ifnull ( upper ( auprstad.end_alp ) , '' ) as house_suffix_2,
    replace ( upper ( replace ( auprstad.str_nme , '''' , '' ) )  , 'BRDGE' , 'BRIDGE' ) as road_name,
    case
        when auprstad.str_nme = 'Broadway' then ''
        when auprstad.str_typ in ( 'AVEN' , 'AVES' , 'AVEE' , 'AVEW' , 'AVEX' ) THEN 'AVENUE'
        when auprstad.str_typ in ( 'RDN' , 'RDS' , 'RDE' , 'RDW' , 'RDX' ) THEN 'ROAD'
        when auprstad.str_typ in ( 'STN' , 'STS' , 'STE' , 'STW' , 'STX' ) THEN 'STREET'
        else upper ( aualrefs.dsc_no3 )
    end as road_type,
    case
        when upper ( auprstad.str_typ ) in ( 'AVEN' , 'RDN' , 'STN' ) then 'N'
        when upper ( auprstad.str_typ ) in ( 'AVES' , 'RDS' , 'STS' ) then 'S'
        when upper ( auprstad.str_typ ) in ( 'AVEE' , 'RDE' , 'STE' ) then 'E'
        when upper ( auprstad.str_typ ) in ( 'AVEW' , 'RDW' , 'STW' ) then 'W'
        when upper ( auprstad.str_typ ) in ( 'AVEX' , 'RDX' , 'STX' ) then 'EX'
        else ''
    end as road_suffix,
    upper ( auprstad.sbr_nme ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '330' as lga_code,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    '' as summary
from
    authority_auprparc auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num join
    authority_auprstad auprstad on auprparc.pcl_num = auprstad.pcl_num left join
    authority_aualrefs aualrefs on auprstad.str_typ = aualrefs.ref_val and aualrefs.ref_typ = 'str_typ'
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num is not null and
    aurtmast.rte_zne <> 'DA'
)
)
)
