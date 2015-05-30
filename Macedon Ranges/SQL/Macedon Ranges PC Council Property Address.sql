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
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    case lpaprop.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as base_propnum,
    '' as is_primary,
    case
        when lpaprop.tpklpaprop in ( select tfklpaprop from pathway_lpaprgp where tfklpapgrp = 1751 ) then 'Y'
        else ''
    end as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when lpaaddr.prefix is null then upper ( ifnull ( lpaaddr.unitprefix , '' ) )
        else upper ( ifnull ( lpaaddr.unitprefix , '' ) )
    end as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when lpaaddr.strunitnum = 0 or lpaaddr.strunitnum is null then ''
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as blg_unit_id_1,
    ifnull ( lpaaddr.strunitsfx , '' ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaaddr.endunitnum = 0 or lpaaddr.endunitnum is null then ''
        else cast ( cast ( lpaaddr.endunitnum as integer ) as varchar )
    end as blg_unit_id_2,
    case
       when trim ( lpaaddr.endunitsfx ) = '0' or lpaaddr.endunitsfx is null then ''
       else trim ( lpaaddr.endunitsfx )
    end as blg_unit_suffix_2,
    '' as floor_type,
    '' as floor_prefix_1,
    case
        when upper ( lpaaddr.lvlprefix ) in ( 'FLOOR' , 'LEVEL' ) then trim ( lpaaddr.strlvlnum )
        else ''
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when upper ( lpaaddr.lvlprefix ) in ( 'FLOOR' , 'LEVEL' ) and trim ( lpaaddr.endlvlnum ) <> '0' then trim ( lpaaddr.endlvlnum )
        else ''
    end as floor_no_2,
    '' as floor_suffix_2,
    ifnull ( upper ( lpapnam.propname ) , '' ) as building_name,
    '' as complex_name,
    case
        when cnacomp.descr like '% OFF' then 'OFF'
        else ''
    end as location_descriptor,
    '' as house_prefix_1,
    case
        when lpaaddr.strhousnum = 0 or lpaaddr.strhousnum is null then ''
        else cast ( cast ( lpaaddr.strhousnum as integer ) as varchar )
    end as house_number_1,
    ifnull ( lpaaddr.strhoussfx , '' ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when lpaaddr.endhousnum = 0 or lpaaddr.endhousnum is null then ''
        else cast ( cast ( lpaaddr.endhousnum as integer ) as varchar )
    end as house_number_2,
    ifnull ( lpaaddr.endhoussfx , '' ) as house_suffix_2,
    case
        when cnacomp.descr like '% AVE OFF' then replace ( upper ( cnacomp.descr ) , ' AVE OFF' , '' )
        when cnacomp.descr like '% CRES OFF' then replace ( upper ( cnacomp.descr ) , ' CRES OFF' , '' )
        when cnacomp.descr like '% CT WEST OFF' then replace ( upper ( cnacomp.descr ) , ' CT WEST OFF' , '' )
        when cnacomp.descr like '% CT OFF' then replace ( upper ( cnacomp.descr ) , ' CT OFF' , '' )
        when cnacomp.descr like '% DR OFF' then replace ( upper ( cnacomp.descr ) , ' DR OFF' , '' )
        when cnacomp.descr like '% LANE OFF' then replace ( upper ( cnacomp.descr ) , ' LANE OFF' , '' )
        when cnacomp.descr like '% PL OFF' then replace ( upper ( cnacomp.descr ) , ' PL OFF' , '' )
        when cnacomp.descr like '% RD OFF' then replace ( upper ( cnacomp.descr ) , ' RD OFF' , '' )
        when cnacomp.descr like '% STREET OFF' then replace ( upper ( cnacomp.descr ) , ' STREET OFF' , '' )
        when cnacomp.descr like '% ST OFF' then replace ( upper ( cnacomp.descr ) , ' ST OFF' , '' )
        when cnacomp.descr like '% TRK OFF' then replace ( upper ( cnacomp.descr ) , ' TRK OFF' , '' )
        else upper ( replace ( replace ( cnacomp.descr , '&' , 'AND' ) , '''' , '' ) )
    end as road_name,
    case
        when cnacomp.descr like '% AVE OFF' then 'AVENUE'
        when cnacomp.descr like '% CRES OFF' then 'CRESCENT'
        when cnacomp.descr like '% CT WEST OFF' then 'COURT'
        when cnacomp.descr like '% CT OFF' then 'COURT'
        when cnacomp.descr like '% DR OFF' then 'DRIVE'
        when cnacomp.descr like '% LANE OFF' then 'LANE'
        when cnacomp.descr like '% PL OFF' then 'PLACE'
        when cnacomp.descr like '% RD OFF' then 'ROAD'
        when cnacomp.descr like '% STREET OFF' then 'STREET'
        when cnacomp.descr like '% ST OFF' then 'STREET'
        when cnacomp.descr like '% TRK OFF' then 'TRACK'
        when
            cnaqual.descr like '% NORTH' or
            cnaqual.descr like '% SOUTH' or
            cnaqual.descr like '% EAST' or
            cnaqual.descr like '% WEST' then upper ( trim ( substr ( cnaqual.descr , 1 , length ( cnaqual.descr ) - 5 ) ) )
        else upper ( ifnull ( cnaqual.descr , '' ) )
    end as road_type,
    case
        when cnacomp.descr like '% NORTH OFF' then 'N'
        when cnacomp.descr like '% SOUTH OFF' then 'S'
        when cnacomp.descr like '% EAST OFF' then 'E'
        when cnacomp.descr like '% WEST OFF' then 'W'
        when cnaqual.descr like '% NORTH' then 'N'
        when cnaqual.descr like '% SOUTH' then 'S'
        when cnaqual.descr like '% EAST' then 'E'
        when cnaqual.descr like '% WEST' then 'W'
        else ''
    end as road_suffix,
    upper ( lpasubr.suburbname ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '339' as lga_code,
    '' as crefno,
    '' as summary
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    pathway_lpastrt as lpastrt on lpaaddr.tfklpastrt = lpastrt.tpklpastrt left join
    pathway_cnacomp as cnacomp on lpastrt.tfkcnacomp = cnacomp.tpkcnacomp left join
    pathway_cnaqual as cnaqual on cnacomp.tfkcnaqual = cnaqual.tpkcnaqual left join
    pathway_lpaprtp as lpaprtp on lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp left join
    pathway_lpasubr as lpasubr on lpaaddr.tfklpasubr = lpasubr.tpklpasubr left join
    pathway_lpapnam as lpapnam on lpaprop.tpklpaprop = lpapnam.tfklpaprop
where
    lpaprop.status in ('A', 'C') and
    lpaaddr.addrtype = 'P' and
    lpaprtp.abbrev <> 'BASE' and
    lpaprop.tfklpacncl = 12
)
)
)