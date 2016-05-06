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
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
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
    upper ( ifnull ( auprstad.unt_alp , '' ) ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    ifnull ( auprstad.unt_end , '' ) as blg_unit_id_2,
    upper ( ifnull ( auprstad.una_end , '' ) ) as blg_unit_suffix_2,
    upper ( ifnull ( auprstad.flo_pre , '' ) ) as floor_type,
    '' as floor_prefix_1,
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
    case
        when auprstad.str_nme like '% Road Ext' then upper ( replace ( auprstad.str_nme , ' Road Ext' , '' ) )
        when auprstad.str_nme like '% Road Extension' then upper ( replace ( auprstad.str_nme , ' Road Extension' , '' ) )
        when auprstad.str_nme like '% Central' then upper ( replace ( auprstad.str_nme , ' Central' , '' ) )
        when auprstad.str_nme = 'Billy Creek-Tap Tap Conne' then 'BILLY CREEK-TAP TAP CONNECTION'
        when auprstad.str_nme = 'Old Port Albert-Tarravill' then 'OLD PORT ALBERT-TARRAVILLE'
        when auprstad.str_nme = 'Sixth Avenue North' then 'SIXTH'
        else upper ( replace ( replace ( auprstad.str_nme , '''' , '' ) , '&' , 'AND' ) )
    end as road_name,
    case
        when auprstad.str_typ in ( 'AVE' , 'AVEN' , 'AVES' , 'AVEE' , 'AVEW' , 'AVEX' ) then 'AVENUE'
        when auprstad.str_typ in ( 'BLVD' ) then 'BOULEVARD'
        when auprstad.str_typ in ( 'CL' ) then 'CLOSE'
        when auprstad.str_typ in ( 'CRES' ) then 'CRESCENT'
        when auprstad.str_typ in ( 'CRT' ) then 'COURT'
        when auprstad.str_typ in ( 'CSWY' ) then 'CAUSEWAY'
        when auprstad.str_typ in ( 'DVE' ) then 'DRIVE'
        when auprstad.str_typ in ( 'GVE' ) then 'GROVE'
        when auprstad.str_typ in ( 'HWY' ) then 'HIGHWAY'
        when auprstad.str_typ in ( 'IS' ) then 'ISLAND'
        when auprstad.str_typ in ( 'LA' ) then 'LANE'
        when auprstad.str_typ in ( 'LNST' , 'LNW' ) then 'LANE'
        when auprstad.str_typ in ( 'PASS' ) then 'PASS'
        when auprstad.str_typ in ( 'PDE' ) then 'PARADE'
        when auprstad.str_typ in ( 'PL' ) then 'PLACE'
        when auprstad.str_typ in ( 'RD' , 'RDNT' , 'RDST' , 'RDE' , 'RDW' , 'RDEX' ) then 'ROAD'
        when auprstad.str_typ in ( 'RISE' ) then 'RISE'
        when auprstad.str_typ in ( 'SQ' ) then 'SQUARE'
        when auprstad.str_typ in ( 'ST' , 'STNT' , 'STST' , 'STE' , 'STW' , 'STEX' ) then 'STREET'
        when auprstad.str_typ in ( 'TCE' ) then 'TERRACE'
        when auprstad.str_typ in ( 'TRK' ) then 'TRACK'
        when auprstad.str_typ in ( 'WAY' ) then 'WAY'
        when auprstad.str_nme like '% Road Ext' then 'ROAD'
        when auprstad.str_nme like '% Road Extension' then 'ROAD'
        when auprstad.str_nme = 'Sixth Avenue North' then 'AVENUE'
        else upper ( ifnull ( aualrefs.dsc_no3 , '' ) )
    end as road_type,
    case
        when upper ( auprstad.str_typ ) in ( 'AVEN' , 'LNNT' , 'RDNT' , 'STNT' ) then 'N'
        when upper ( auprstad.str_typ ) in ( 'AVES' , 'LNST' , 'RDST' , 'STST' ) then 'S'
        when upper ( auprstad.str_typ ) in ( 'AVEE' , 'LNE' , 'RDE' , 'STE' ) then 'E'
        when upper ( auprstad.str_typ ) in ( 'AVEW' , 'LNW' , 'RDW' , 'STW' ) then 'W'
        when upper ( auprstad.str_typ ) in ( 'AVEX' , 'RDEX' , 'STEX' ) then 'EX'
        when auprstad.str_nme like '% Road Ext' then 'EX'
        when auprstad.str_nme like '% Road Extension' then 'EX'
        when auprstad.str_nme like '% Central' then 'CN'
        when auprstad.str_nme = 'Sixth Avenue North' then 'N'
        else ''
    end as road_suffix,
    upper ( auprstad.sbr_nme ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '370' as lga_code,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    '' as summary
from
    authority_auprparc auprparc join
    authority_auprstad auprstad on auprparc.pcl_num = auprstad.pcl_num left join
    authority_aualrefs aualrefs on auprstad.str_typ = aualrefs.ref_val and aualrefs.ref_typ = 'str_typ'
where
    auprparc.pcl_flg in ( 'R' , 'P' , 'U' ) and
    auprparc.ass_num is not null and
    auprstad.seq_num = 0
)
)
)
