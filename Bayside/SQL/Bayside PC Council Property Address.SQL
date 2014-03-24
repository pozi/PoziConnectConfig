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
    ifnull ( auprstad.hou_num , '' ) as house_number_1,
    upper ( ifnull ( auprstad.hou_alp , '' ) ) as house_suffix_1,
    '' as house_prefix_2,
    ifnull ( auprstad.hou_end , '' ) as house_number_2,
    upper ( ifnull ( auprstad.end_alp , '' ) ) as house_suffix_2,
    replace ( upper ( trim ( auprstad.str_nme ) ) , 'MC ' , 'MC' ) as road_name,
    case
        when trim ( auprstad.str_typ ) in ( 'APP' ) then 'APPROACH'
        when trim ( auprstad.str_typ ) in ( 'AV' , 'AVE' ) then 'AVENUE'
        when trim ( auprstad.str_typ ) in ( 'BEND' , 'BND' ) then 'BEND'
        when trim ( auprstad.str_typ ) in ( 'BWK' ) then 'BOARDWALK'
        when trim ( auprstad.str_typ ) in ( 'BWL' ) then 'BOWL'
        when trim ( auprstad.str_typ ) in ( 'BWAY' ) then 'BYWAY'
        when trim ( auprstad.str_typ ) in ( 'BLVD' , 'BVD' ) then 'BOULEVARD'
        when trim ( auprstad.str_typ ) in ( 'CCT' , 'CRCT' ) then 'CIRCUIT'
        when trim ( auprstad.str_typ ) in ( 'CH' ) then 'CHASE'
        when trim ( auprstad.str_typ ) in ( 'CIR' ) then 'CIRCLE'
        when trim ( auprstad.str_typ ) in ( 'CL' ) then 'CLOSE'
        when trim ( auprstad.str_typ ) in ( 'CNC' ) then 'CONCOURSE'
        when trim ( auprstad.str_typ ) in ( 'CNR' ) then 'CORNER'
        when trim ( auprstad.str_typ ) in ( 'COU' ) then 'COURSE'
        when trim ( auprstad.str_typ ) in ( 'COVE' , 'COV' ) then 'COVE'
        when trim ( auprstad.str_typ ) in ( 'CR' , 'CRES' ) then 'CRESCENT'
        when trim ( auprstad.str_typ ) in ( 'CRSE' ) then 'COURSE'
        when trim ( auprstad.str_typ ) in ( 'CRSS' ) then 'CROSS'
        when trim ( auprstad.str_typ ) in ( 'CRST' ) then 'CREST'
        when trim ( auprstad.str_typ ) in ( 'CRT' , 'CT' ) then 'COURT'
        when trim ( auprstad.str_typ ) in ( 'CSWY' ) then 'CAUSEWAY'
        when trim ( auprstad.str_typ ) in ( 'DR' , 'DVE' ) then 'DRIVE'
        when trim ( auprstad.str_typ ) in ( 'DOM') then 'DOMAIN'
        when trim ( auprstad.str_typ ) in ( 'ESP' ) then 'ESPLANADE'
        when trim ( auprstad.str_typ ) in ( 'FAWY' ) then 'FAIRWAY'
        when trim ( auprstad.str_typ ) in ( 'FWY' ) then 'FREEWAY'
        when trim ( auprstad.str_typ ) in ( 'GDN' ) then 'GARDEN'
        when trim ( auprstad.str_typ ) in ( 'GDNS' ) then 'GARDENS'
        when trim ( auprstad.str_typ ) in ( 'GLD' ) then 'GLADE'
        when trim ( auprstad.str_typ ) in ( 'GL' , 'GLEN' , 'GLN' ) then 'GLEN'
        when trim ( auprstad.str_typ ) in ( 'GRA' ) then 'GRANGE'
        when trim ( auprstad.str_typ ) in ( 'GRN' ) then 'GREEN'
        when trim ( auprstad.str_typ ) in ( 'GR' , 'GV' , 'GVE' ) then 'GROVE'
        when trim ( auprstad.str_typ ) in ( 'HILL' ) then 'HILL'
        when trim ( auprstad.str_typ ) in ( 'HTS' ) then 'HEIGHTS'
        when trim ( auprstad.str_typ ) in ( 'HWY' ) then 'HIGHWAY'
        when trim ( auprstad.str_typ ) in ( 'IS' ) then 'ISLAND'
        when trim ( auprstad.str_typ ) in ( 'JNC' ) then 'JUNCTION'
        when trim ( auprstad.str_typ ) in ( 'LA' , 'LN' , 'LANE' ) then 'LANE'
        when trim ( auprstad.str_typ ) in ( 'LK' , 'LNK' , 'LINK' ) then 'LINK'
        when trim ( auprstad.str_typ ) in ( 'LOOP' , 'LP' ) then 'LOOP'
        when trim ( auprstad.str_typ ) in ( 'MALL' ) then 'MALL'
        when trim ( auprstad.str_typ ) in ( 'MEWS' , 'MW' ) then 'MEWS'
        when trim ( auprstad.str_typ ) in ( 'NOOK' ) then 'NOOK'
        when trim ( auprstad.str_typ ) in ( 'OTLK' ) then 'OUTLOOK'
        when trim ( auprstad.str_typ ) in ( 'PASS' ) then 'PASS'
        when trim ( auprstad.str_typ ) in ( 'PDE' ) then 'PARADE'
        when trim ( auprstad.str_typ ) in ( 'PKY' , 'PKWY' ) then 'PARKWAY'
        when trim ( auprstad.str_typ ) in ( 'PL' ) then 'PLACE'
        when trim ( auprstad.str_typ ) in ( 'PNT' ) then 'POINT'
        when trim ( auprstad.str_typ ) in ( 'PROM' ) then 'PROMENADE'
        when trim ( auprstad.str_typ ) in ( 'PU' ) then 'PURSUIT'
        when trim ( auprstad.str_typ ) in ( 'QY' ) then 'QUAY'
        when trim ( auprstad.str_typ ) in ( 'RD' , 'ROAD' ) then 'ROAD'
        when trim ( auprstad.str_typ ) in ( 'RT' ) then 'RETREAT'
        when trim ( auprstad.str_typ ) in ( 'RDGE' ) then 'RIDGE'
        when trim ( auprstad.str_typ ) in ( 'REST' ) then 'REST'
        when trim ( auprstad.str_typ ) in ( 'RIDE' ) then 'RIDE'
        when trim ( auprstad.str_typ ) in ( 'RISE' ) then 'RISE'
        when trim ( auprstad.str_typ ) in ( 'RND' ) then 'ROUND'
        when trim ( auprstad.str_typ ) in ( 'ROW' ) then 'ROW'
        when trim ( auprstad.str_typ ) in ( 'RTT' ) then 'RETREAT'
        when trim ( auprstad.str_typ ) in ( 'RUN' ) then 'RUN'
        when trim ( auprstad.str_typ ) in ( 'SQ' ) then 'SQUARE'
        when trim ( auprstad.str_typ ) in ( 'ST' , 'SS' , 'SN' ) then 'STREET'
        when trim ( auprstad.str_typ ) in ( 'TCE' ) then 'TERRACE'
        when trim ( auprstad.str_typ ) in ( 'TR' , 'TRK' ) then 'TRACK'
        when trim ( auprstad.str_typ ) in ( 'TRL' ) then 'TRAIL'
        when trim ( auprstad.str_typ ) in ( 'TRN' , 'TURN' ) then 'TURN'
        when trim ( auprstad.str_typ ) in ( 'VIEW' , 'VW' ) then 'VIEW'
        when trim ( auprstad.str_typ ) in ( 'VWS' ) then 'VIEWS'
        when trim ( auprstad.str_typ ) in ( 'VST' , 'VSTA' ) then 'VISTA'
        when trim ( auprstad.str_typ ) in ( 'WALK' , 'WK' ) then 'WALK'
        when trim ( auprstad.str_typ ) in ( 'WAY' ) then 'WAY'
        when trim ( auprstad.str_typ ) in ( 'WKWY' ) then 'WALKWAY'
        when trim ( auprstad.str_typ ) in ( 'WA' , 'WTRS' ) then 'WATERS'
        when trim ( auprstad.str_typ ) in ( 'WYN' , 'WYND' ) then 'WYND'
        when trim ( auprstad.str_typ ) in ( '.' ) then ''        
        when upper ( substr ( trim ( auprstad.str_nme ) , -13 ) ) in  ( ' AVENUE NORTH' , ' AVENUE SOUTH' ) then 'AVENUE'
        when upper ( substr ( trim ( auprstad.str_nme ) , -12 ) ) in  ( ' AVENUE EAST' , ' AVENUE WEST' ) then 'AVENUE'
        when upper ( substr ( trim ( auprstad.str_nme ) , -11 ) ) in  ( ' LANE NORTH' , ' LANE SOUTH' )  then 'LANE'
        when upper ( substr ( trim ( auprstad.str_nme ) , -10 ) ) in  ( ' LANE EAST' , ' LANE WEST' )  then 'LANE'
        when upper ( substr ( trim ( auprstad.str_nme ) , -11 ) ) in  ( ' ROAD NORTH' , ' ROAD SOUTH' ) then 'ROAD'
        when upper ( substr ( trim ( auprstad.str_nme ) , -10 ) ) in  ( ' ROAD EAST' , ' ROAD WEST' ) then 'ROAD'
        else upper ( ifnull ( auprstad.str_typ , '' ) )
    end as road_type,
    case
		when trim ( auprstad.str_typ ) = 'SN' then 'N'
		when trim ( auprstad.str_typ ) = 'SS' then 'S'
		when trim ( auprstad.str_typ ) = 'SE' then 'E'
		when trim ( auprstad.str_typ ) = 'SW' then 'W'
        else ''
    end as road_suffix,
    upper ( trim ( auprstad.sbr_nme ) ) as locality_name,
    ifnull ( ausrsubr.pst_cde , '' ) as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '306' as lga_code,
    '' as crefno
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