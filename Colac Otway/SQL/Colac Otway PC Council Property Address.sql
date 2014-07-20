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
    case upper ( auprstad.str_nme )
        when 'BEECH FOREST L/HILL' then 'BEECH FOREST-LAVERS HILL'
        when 'GRAHAM & MCDONALDS' then 'GRAHAM AND MCDONALDS'
        when 'PENNYROYAL W/LIEL' then 'PENNYROYAL-WYMBOOLIEL'
        when 'WALL/SKINNERS' then 'WALL-SKINNERS'
        else upper ( auprstad.str_nme )
    end as road_name,
    case
        when upper ( auprstad.str_typ ) = 'ACC' then 'ACCESS'
        when upper ( auprstad.str_typ ) = 'AVE' then 'AVENUE'
        when upper ( auprstad.str_typ ) = 'CL' then 'CLOSE'
        when upper ( auprstad.str_typ ) = 'CR' then 'CRESCENT'
        when upper ( auprstad.str_typ ) = 'CRES' then 'CRESCENT'
        when upper ( auprstad.str_typ ) = 'CT' then 'COURT'
        when upper ( auprstad.str_typ ) = 'CUT' then 'CUTTING'
        when upper ( auprstad.str_typ ) = 'DR' then 'DRIVE'
        when upper ( auprstad.str_typ ) = 'GR' then 'GROVE'
        when upper ( auprstad.str_typ ) = 'HWY' then 'HIGHWAY'
        when upper ( auprstad.str_typ ) = 'LA' then 'LANE'
        when upper ( auprstad.str_typ ) = 'PDE' then 'PARADE'
        when upper ( auprstad.str_typ ) = 'PK' then 'PARK'
        when upper ( auprstad.str_typ ) = 'PL' then 'PLACE'
        when upper ( auprstad.str_typ ) = 'QY' then 'QUAY'
        when upper ( auprstad.str_typ ) in ( 'RD' , 'RD E' , 'RD N' , 'RD S' , 'RD W' , 'RD X' ) then 'ROAD'
        when upper ( auprstad.str_typ ) = 'SQ' then 'SQUARE'
        when upper ( auprstad.str_typ ) in ( 'ST' , 'ST E' , 'ST N' , 'ST S' , 'ST W' , 'ST X' ) then 'STREET'
        when upper ( auprstad.str_typ ) = 'TCE' then 'TERRACE'
        when upper ( auprstad.str_typ ) = 'TR' then 'TRACK'
        when upper ( auprstad.str_typ ) = 'WK' then 'WALK'
        when upper ( auprstad.str_typ ) = 'WY' then 'WAY'
        else ''
    end as road_type,
    case
        when upper ( auprstad.str_typ ) in ( 'RD N' , 'ST N' ) then 'N'
        when upper ( auprstad.str_typ ) in ( 'RD S' , 'ST S' ) then 'S'
        when upper ( auprstad.str_typ ) in ( 'RD E' , 'ST E' ) then 'E'
        when upper ( auprstad.str_typ ) in ( 'RD W' , 'ST W' ) then 'W'
        when upper ( auprstad.str_typ ) in ( 'RD X' , 'ST X' ) then 'EX'
        else ''
    end as road_suffix,
    upper ( auprstad.sbr_nme ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '314' as lga_code,
    '' as crefno,
    '' as summary
from
    authority_auprparc auprparc,
    authority_auprstad auprstad
where
    ( auprparc.pcl_num = auprstad.pcl_num ) and
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num <> 0 and
    auprstad.seq_num = 0
)
)
)
