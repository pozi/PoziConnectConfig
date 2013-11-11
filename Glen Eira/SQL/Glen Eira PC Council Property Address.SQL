select
    cast ( cast ( lraassm.assmnumber as integer ) as varchar ) as propnum,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when lpaaddr.strunitnum <> 0 or lpaaddr.strunitsfx is not null then        
            case
                when lpaaddr.unitprefix = 'Apartment' then 'APT'
                when lpaaddr.unitprefix = 'Flat' then 'FLAT'
                when lpaaddr.unitprefix = 'Suite' then 'SE'
                when lpaaddr.unitprefix = 'Unit' then 'UNIT'        
                else ''        
            end
        when lpaaddr.strlvlnum <> 0 then        
            case
                when lpaaddr.lvlprefix = 'Hall' then 'HALL'
                when lpaaddr.lvlprefix = 'House' then 'HSE'
                when lpaaddr.lvlprefix = 'Office' then 'OFFC'
                when lpaaddr.lvlprefix = 'Reserve' then 'RESV'
                when lpaaddr.lvlprefix = 'Shed' then 'SHED'
                when lpaaddr.lvlprefix = 'Shop' then 'SHOP'
                when lpaaddr.lvlprefix = 'Suite' then 'SE'
                when lpaaddr.lvlprefix = 'Tower' then 'TWR'
                when lpaaddr.lvlprefix = 'ATM' then 'ATM' 
                else ''         
            end
        else ''
    end as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when lpaaddr.lvlprefix in ( 'Hall' , 'House' , 'Office' , 'Reserve' , 'Shed' , 'Suite' , 'Tower' , 'ATM' ) and lpaaddr.strlvlnum <> 0 then cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar )
        when lpaaddr.strunitnum <> 0 then cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
        else ''
    end as blg_unit_id_1,
    case
        when lpaaddr.strlvlsfx is not null and lpaaddr.lvlprefix in ( 'Hall' , 'House' , 'Office' , 'Reserve' , 'Shed' , 'Suite' , 'Tower' , 'ATM' ) then cast ( lpaaddr.strlvlsfx as varchar )
        when lpaaddr.unitprefix not in ( 'Floor' , 'Level' ) and lpaaddr.strunitsfx is not null then cast ( lpaaddr.strunitsfx as varchar )
        else ''
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaaddr.endunitnum = 0 then ''
        else cast (lpaaddr.endunitnum as integer)
    end as blg_unit_id_2,
    case
        when lpaaddr.endunitsfx = 0 then ''
        else cast (lpaaddr.endunitsfx as varchar)
    end as blg_unit_suffix_2,
    case
        when lpaaddr.unitprefix = 'Floor' and (lpaaddr.strunitnum <> 0 or lpaaddr.strunitsfx is not null) then 'FL'
        when lpaaddr.unitprefix = 'Level' and (lpaaddr.strunitnum <> 0 or lpaaddr.strunitsfx is not null) then 'L'
        when lpaaddr.lvlprefix = 'Floor' and (lpaaddr.strlvlnum <> 0 or lpaaddr.strlvlsfx is not null) then 'FL'
        when lpaaddr.lvlprefix = 'Level' and (lpaaddr.strlvlnum <> 0 or lpaaddr.strlvlsfx is not null) then 'L'
    end as floor_type,
    '' as floor_prefix_1,
    case
        when lpaaddr.lvlprefix = 'Floor' and lpaaddr.strlvlnum <> 0 then cast (lpaaddr.strlvlnum as varchar)
        when lpaaddr.lvlprefix = 'Level' and lpaaddr.strlvlnum <> 0 then cast (lpaaddr.strlvlnum as varchar)
        when lpaaddr.unitprefix = 'Floor' and lpaaddr.strunitnum <> 0 then cast (lpaaddr.strunitnum as varchar)
        when lpaaddr.unitprefix = 'Level' and lpaaddr.strunitnum <> 0 then cast (lpaaddr.strunitnum as varchar)
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
    upper ( ifnull ( lpapnam.propname , ifnull ( lpaaddr.prefix || ' ' , '' ) || ifnull ( lpaaddr.lvlprefix , '' ) ) ) as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    ifnull ( cast ( cast ( lpaaddr.strhousnum as integer ) as varchar ) , '' ) as house_number_1,
    ifnull ( lpaaddr.strhoussfx , '' ) as house_suffix_1,
    '' as house_prefix_2,
    ifnull ( cast ( cast ( lpaaddr.endhousnum as integer ) as varchar ) , '' ) as house_number_2,
    ifnull ( lpaaddr.endhoussfx , '' ) as house_suffix_2,
    upper ( cnacomp.descr ) as road_name,
    upper ( cnaqual.descr ) as road_type,
    '' as road_suffix, 
    lpasubr.suburbname as locality_name, 
    cnacomp_1.descr as postcode,
    '' as access_type,
    '322' as lga_code,
    '' as crefno
from
    PATHWAY_lpaprop as lpaprop left join
    PATHWAY_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join 
    PATHWAY_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join 
    PATHWAY_lpastrt as lpastrt on lpaaddr.tfklpastrt = lpastrt.tpklpastrt left join 
    PATHWAY_cnacomp as cnacomp on lpastrt.tfkcnacomp = cnacomp.tpkcnacomp left join 
    PATHWAY_cnacomp as cnacomp_1 on lpaaddr.tfkcnacomp = cnacomp_1.tpkcnacomp left join 
    PATHWAY_cnaqual as cnaqual on cnacomp.tfkcnaqual = cnaqual.tpkcnaqual left join 
    PATHWAY_lpaprtp as lpaprtp on lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp left join 
    PATHWAY_lpasubr as lpasubr on lpaaddr.tfklpasubr = lpasubr.tpklpasubr left join
    PATHWAY_lparole_filtered as lparole_filt on lpaprop.tpklpaprop = lparole_filt.tfklocl left join
    PATHWAY_lraassm as lraassm on lparole_filt.tfkappl = lraassm.tpklraassm left join
    PATHWAY_lpapnam as lpapnam on lpaprop.tpklpaprop = lpapnam.tfklpaprop
where
    lpaprop.status in ( 'A' , 'C' ) and 
    lraassm.applicatn = 'R' and
    lpaaddr.addrtype = 'P' and 
    lpaprop.tfklpacncl = 13

