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
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'BVD' then 'THE BOULEVARDE'
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'CRES' then 'THE CRESCENT'
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'GRA' then 'THE GRANGE'
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'PNT' then 'THE POINT'
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'TCE' then 'THE TERRACE'
        else upper ( auprstad.str_nme )
    end as road_name,
    case
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'BVD' then ''
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'CRES' then ''
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'GRA' then ''
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'PNT' then ''
        when auprstad.str_nme = 'The' and auprstad.str_typ = 'TCE' then ''
        when auprstad.str_typ = 'AVE' then 'AVENUE'
        when auprstad.str_typ = 'BRK' then 'BREAK'
        when auprstad.str_typ = 'BVD' then 'BOULEVARD'
        when auprstad.str_typ = 'BWLK' then 'BOARDWALK'
        when auprstad.str_typ = 'CCT' then 'CIRCUIT'
        when auprstad.str_typ = 'CH' then 'CHASE'
        when auprstad.str_typ = 'CIR' then 'CIRCLE'
        when auprstad.str_typ = 'CL' then 'CLOSE'
        when auprstad.str_typ = 'CNR' then 'CORNER'
        when auprstad.str_typ = 'CRES' then 'CRESCENT'
        when auprstad.str_typ = 'CRSE' then 'COURSE'
        when auprstad.str_typ = 'CRSS' then 'CROSS'
        when auprstad.str_typ = 'CT' then 'COURT'
        when auprstad.str_typ = 'DR' then 'DRIVE'
        when auprstad.str_typ = 'ENT' then 'ENTRANCE'
        when auprstad.str_typ = 'FITR' then 'FIRETRAIL'
        when auprstad.str_typ = 'FWY' then 'FREEWAY'
        when auprstad.str_typ = 'GDNS' then 'GARDENS'
        when auprstad.str_typ = 'GLD' then 'GLADE'
        when auprstad.str_typ = 'GR' then 'GROVE'
        when auprstad.str_typ = 'GRA' then 'GRANGE'
        when auprstad.str_typ = 'GRN' then 'GREEN'
        when auprstad.str_typ = 'HWY' then 'HIGHWAY'
        when auprstad.str_typ = 'HTS' then 'HEIGHTS'
        when auprstad.str_typ = 'JNC' then 'JUNCTION'
        when auprstad.str_typ = 'PDE' then 'PARADE'
        when auprstad.str_typ = 'PKWY' then 'PARKWAY'
        when auprstad.str_typ = 'PL' then 'PLACE'
        when auprstad.str_typ = 'PNT' then 'POINT'
        when auprstad.str_typ = 'PROM' then 'PROMENADE'
        when auprstad.str_typ = 'QY' then 'QUAY'
        when auprstad.str_typ = 'RD' then 'ROAD'
        when auprstad.str_typ = 'RTT' then 'RETREAT'
        when auprstad.str_typ = 'SQ' then 'SQUARE'
        when auprstad.str_typ = 'ST' then 'STREET'
        when auprstad.str_typ = 'TCE' then 'TERRACE'
        when auprstad.str_typ = 'TRK' then 'TRACK'
        when auprstad.str_typ = 'VSTA' then 'VISTA'
        when auprstad.str_typ = 'VWS' then 'VIEWS'
        when auprstad.str_typ = 'WKWY' then 'WALKWAY'
        when auprstad.str_typ = 'WTRS' then 'WATERS'
		else ifnull ( auprstad.str_typ , '' )
    end as road_type,
    '' as road_suffix,
    upper ( trim ( auprstad.sbr_nme ) ) as locality_name,
    ifnull ( ausrsubr.pst_cde , '' ) as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '319' as lga_code,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    '' as summary
from
    authority_auprparc auprparc inner join
    authority_auprstad auprstad ON auprparc.pcl_num = auprstad.pcl_num left outer join
    authority_ausrsubr ausrsubr ON auprstad.sbr_nme = ausrsubr.sbr_nme
where
    auprparc.pcl_flg in ( 'R' , 'U' , 'P' ) and
    auprstad.seq_num = 0
)
)
)
