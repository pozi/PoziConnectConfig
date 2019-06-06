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
    ifnull ( upper ( auprparc.ttl_nme ) , '' ) as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    ifnull ( cast ( auprstad.hou_num as varchar ) , '' ) as house_number_1,
    ifnull ( upper ( auprstad.hou_alp ) , '' ) as house_suffix_1,
    '' as house_prefix_2,
    ifnull ( cast ( auprstad.hou_end as varchar ) , '' ) as house_number_2,
    ifnull ( upper ( auprstad.end_alp ) , '' ) as house_suffix_2,
    case upper ( ausrmast.str_nme )
        when 'BEECH FOREST L/HILL' then 'BEECH FOREST-LAVERS HILL'
        when 'FOREST STREET SOUTH' then 'FOREST'
        when 'GRAHAM & MCDONALDS' then 'GRAHAM AND MCDONALDS'
        when 'IRREWILLIPE-PIRRON YALLOC' then 'IRREWILLIPE-PIRRON YALLOCK'
        when 'PENNYROYAL W/LIEL' then 'PENNYROYAL-WYMBOOLIEL'
        when 'WALL/SKINNERS' then 'WALL-SKINNERS'
        else upper ( ausrmast.str_nme )
    end as road_name,
    case upper ( ausrmast.str_typ )
        when 'ACC' then 'ACCESS'
        when 'AVE' then 'AVENUE'
        when 'CL' then 'CLOSE'
        when 'CR' then 'CRESCENT'
        when 'CRES' then 'CRESCENT'
        when 'CT' then 'COURT'
        when 'CUT' then 'CUTTING'
        when 'DR' then 'DRIVE'
        when 'GR' then 'GROVE'
        when 'HWY' then 'HIGHWAY'
        when 'LA' then 'LANE'
        when 'PDE' then 'PARADE'
        when 'PK' then 'PARK'
        when 'PL' then 'PLACE'
        when 'QY' then 'QUAY'
        when 'RD' then 'ROAD'
        when 'RD X' then 'ROAD'
        when 'SQ' then 'SQUARE'
        when 'ST' then 'STREET'
        when 'TCE' then 'TERRACE'
        when 'TR' then 'TRACK'
        when 'WK' then 'WALK'
        when 'WY' then 'WAY'
        else ''
    end as road_type,
    case
        when upper ( ausrmast.str_typ ) = 'RD X' then 'EX'
        else ifnull ( ausrmast.str_suf , '' )
    end as road_suffix,
    upper ( auprstad.sbr_nme ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '314' as lga_code,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    '' as summary
from
    authority_auprparc auprparc join
    authority_auprstad auprstad on auprparc.pcl_num = auprstad.pcl_num join
    authority_ausrmast ausrmast on auprstad.str_num = ausrmast.str_num left join
    authority_ausrsuft ausrsuft on ausrmast.str_suf = ausrsuft.str_suf
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num <> 0 and
    auprstad.seq_num = 0
)
)
)