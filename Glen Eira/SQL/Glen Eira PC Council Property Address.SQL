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

select
    cast ( cast ( lraassm.assmnumber as integer ) as varchar ) as propnum,
    case lpaprop.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when upper ( lpaaddr.unitprefix ) = 'APARTMENT' then 'APT'
        when upper ( lpaaddr.unitprefix ) = 'FLAT' then 'FLAT'
        when upper ( lpaaddr.unitprefix ) = 'SUITE' then 'SE'
        when upper ( lpaaddr.unitprefix ) = 'UNIT' then 'UNIT'
        when upper ( lpaaddr.lvlprefix ) = 'ATM' then 'ATM' 
        when upper ( lpaaddr.lvlprefix ) = 'HALL' then 'HALL'
        when upper ( lpaaddr.lvlprefix ) = 'HOUSE' then 'HSE'
        when upper ( lpaaddr.lvlprefix ) = 'KIOSK' then 'KSK'
        when upper ( lpaaddr.lvlprefix ) = 'OFFICE' then 'OFFC'
        when upper ( lpaaddr.lvlprefix ) = 'RESERVE' then 'RESV'
        when upper ( lpaaddr.lvlprefix ) = 'SHED' then 'SHED'
        when upper ( lpaaddr.lvlprefix ) = 'SHOP' then 'SHOP'
        when upper ( lpaaddr.lvlprefix ) = 'SIGN' then 'SIGN'
        when upper ( lpaaddr.lvlprefix ) = 'SUITE' then 'SE'
        when upper ( lpaaddr.lvlprefix ) = 'TOWER' then 'TWR'
        else ''
    end as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when upper ( lpaaddr.lvlprefix ) in ( 'ATM' , 'HALL' , 'HOUSE' , 'KIOSK' , 'OFFICE' , 'RESERVE' , 'SHED' , 'SHOP' , 'SIGN' , 'SUITE' , 'TOWER' ) and lpaaddr.strlvlnum <> 0 then cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar )
        when upper ( lpaaddr.unitprefix ) in ( 'FLOOR' , 'LEVEL' ) and lpaaddr.strlvlnum = 0 then ''
        when lpaaddr.strunitnum <> 0 then cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
        else ''
    end as blg_unit_id_1,
    case
        when lpaaddr.strlvlsfx is not null and upper ( lpaaddr.lvlprefix ) in ( 'ATM' , 'HALL' , 'HOUSE' , 'KIOSK' , 'OFFICE' , 'RESERVE' , 'SHED' , 'SHOP' , 'SIGN' , 'SUITE' , 'TOWER' ) then cast ( lpaaddr.strlvlsfx as varchar )
        when upper ( lpaaddr.unitprefix ) not in ( 'FLOOR' , 'LEVEL' ) and lpaaddr.strunitsfx is not null then cast ( lpaaddr.strunitsfx as varchar )
        else ''
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaaddr.endunitnum = 0 then ''
        else cast (lpaaddr.endunitnum as integer)
    end as blg_unit_id_2,
    case
        when lpaaddr.endunitsfx = '0' or lpaaddr.endunitsfx is null then ''
        else cast (lpaaddr.endunitsfx as varchar)
    end as blg_unit_suffix_2,
    case
        when lpaaddr.unitprefix = 'Floor' and (lpaaddr.strunitnum <> 0 or lpaaddr.strunitsfx is not null) then 'FL'
        when lpaaddr.unitprefix = 'Level' and (lpaaddr.strunitnum <> 0 or lpaaddr.strunitsfx is not null) then 'L'
        when lpaaddr.lvlprefix = 'Floor' and (lpaaddr.strlvlnum <> 0 or lpaaddr.strlvlsfx is not null) then 'FL'
        when lpaaddr.lvlprefix = 'Level' and (lpaaddr.strlvlnum <> 0 or lpaaddr.strlvlsfx is not null) then 'L'
        else ''
    end as floor_type,
    '' as floor_prefix_1,
    case
        when lpaaddr.lvlprefix = 'Floor' and lpaaddr.strlvlnum <> 0 then cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar)
        when lpaaddr.lvlprefix = 'Level' and lpaaddr.strlvlnum <> 0 then cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar)
        when lpaaddr.unitprefix = 'Floor' and lpaaddr.strunitnum <> 0 then cast ( cast ( lpaaddr.strunitnum as integer ) as varchar)
        when lpaaddr.unitprefix = 'Level' and lpaaddr.strunitnum <> 0 then cast ( cast ( lpaaddr.strunitnum as integer ) as varchar)
        else ''
    end as floor_no_1,
    case
        when lpaaddr.lvlprefix = 'Floor' and lpaaddr.strlvlsfx is not null then cast (lpaaddr.strlvlsfx as varchar)
        when lpaaddr.lvlprefix = 'Level' and lpaaddr.strlvlsfx is not null then cast (lpaaddr.strlvlsfx as varchar)
        when lpaaddr.unitprefix = 'Floor' and lpaaddr.strunitsfx is not null then cast (lpaaddr.strunitsfx as varchar)
        when lpaaddr.unitprefix = 'Level' and lpaaddr.strunitsfx is not null then cast (lpaaddr.strunitsfx as varchar)
        else ''
    end as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    case    
        when upper ( lpaaddr.lvlprefix ) in ( 'ATM' , 'FLOOR' , 'KIOSK' , 'LEVEL' , 'OFFICE' , 'REAR' , 'SHOP' , 'SIGN' , 'SUITE' ) then upper ( ifnull ( lpapnam.propname , '' ) )
        when upper ( lpaaddr.prefix ) in ( 'ATM' , 'FLOOR' , 'KIOSK' , 'LEVEL' , 'OFFICE' , 'REAR' , 'SHOP' , 'SIGN' , 'SUITE' ) then upper ( ifnull ( lpapnam.propname , '' ) )
        else upper ( ifnull ( lpapnam.propname , ifnull ( lpaaddr.prefix || ' ' , '' ) || ifnull ( lpaaddr.lvlprefix , '' ) ) )
    end as building_name,
    '' as complex_name,
    case    
        when upper ( lpaaddr.prefix ) = 'REAR' then upper ( lpaaddr.prefix )
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
    upper ( replace ( replace ( cnacomp.descr , ' - ' , '-' ) , '''' , '' ) ) as road_name, 
    upper ( cnaqual.descr ) as road_type,
    '' as road_suffix, 
    lpasubr.suburbname as locality_name, 
    cnacomp_1.descr as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '322' as lga_code,
    '' as crefno
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join 
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join 
    pathway_lpastrt as lpastrt on lpaaddr.tfklpastrt = lpastrt.tpklpastrt left join 
    pathway_cnacomp as cnacomp on lpastrt.tfkcnacomp = cnacomp.tpkcnacomp left join 
    pathway_cnacomp as cnacomp_1 on lpaaddr.tfkcnacomp = cnacomp_1.tpkcnacomp left join 
    pathway_cnaqual as cnaqual on cnacomp.tfkcnaqual = cnaqual.tpkcnaqual left join 
    pathway_lpaprtp as lpaprtp on lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp left join 
    pathway_lpasubr as lpasubr on lpaaddr.tfklpasubr = lpasubr.tpklpasubr left join
    pathway_lparole as lparole on lpaprop.tpklpaprop = lparole.tfklocl left join
    pathway_lraassm as lraassm on lparole.tfkappl = lraassm.tpklraassm left join
    pathway_lpapnam as lpapnam on lpaprop.tpklpaprop = lpapnam.tfklpaprop
where
    lpaprop.status in ( 'A' , 'C' ) and 
    lraassm.applicatn = 'R' and
    lpaaddr.addrtype = 'P' and 
    lpaprop.tfklpacncl = 13
)
)
)
