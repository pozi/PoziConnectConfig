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
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    case lpaprop.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as base_propnum,
    case lpaaddr.addrtype
        when 'P' then 'Y'
        when 'A' then 'N'
    end as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when rtrim ( lpaaddr.prefix ) = 'ATM' then 'ATM'
        when rtrim ( lpaaddr.prefix ) = 'CAR PARK' then 'CP'
        when rtrim ( lpaaddr.prefix ) = 'FACTORY' then 'FY'
        when rtrim ( lpaaddr.prefix ) = 'KIOSK' then 'KSK'
        when rtrim ( lpaaddr.prefix ) = 'OFFICE' then 'OFF'
        when rtrim ( lpaaddr.prefix ) = 'SHOP' then 'SHOP'
        when rtrim ( lpaaddr.prefix ) = 'SUITE' then 'SE'
        when rtrim ( lpaaddr.prefix ) = 'UNIT' then 'U'
        when rtrim ( lpaaddr.prefix ) = 'L' then 'LOT'
        when rtrim ( lpaaddr.prefix ) = 'ROOM' then 'ROOM'
        else ''
    end as blg_unit_type,   
    '' as blg_unit_prefix_1,
    case
        when lpaaddr.strunitnum = 0 or lpaaddr.strunitnum is null then ''
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as blg_unit_id_1,
    case
        when lpaaddr.strunitsfx = '0' or lpaaddr.strunitsfx is null then ''
        else cast ( lpaaddr.strunitsfx as varchar )
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaaddr.endunitnum = 0 or lpaaddr.endunitnum is null then ''
        else cast ( cast ( lpaaddr.endunitnum as integer ) as varchar )
    end as blg_unit_id_2,
    case
        when lpaaddr.endunitsfx = '0' or lpaaddr.endunitsfx is null then ''
        else cast ( lpaaddr.endunitsfx as varchar )
    end as blg_unit_suffix_2,
    case
        when lpaaddr.lvlprefix = 'LEVEL' then 'L'
        when lpaaddr.lvlprefix = 'FLOOR' then 'FL'
        else ''
    end as floor_type,
    '' as floor_prefix_1,
    case
        when lpaaddr.strlvlnum = 0 then ''
        else cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar )
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when lpaaddr.endlvlnum = 0 then ''
        else cast ( cast ( lpaaddr.endlvlnum as integer ) as varchar )
    end as floor_no_2,
    '' as floor_suffix_2,
    case
        when lpapnam.propname is null then ''
        else upper ( lpapnam.propname )
    end as building_name,
    '' as complex_name,
    case
        when rtrim ( lpaaddr.prefix ) = 'REAR' then 'REAR'
        when rtrim ( lpaaddr.prefix ) = 'REAR OF' then 'REAR'
        when rtrim ( lpaaddr.lvlprefix ) = 'UPSTAIRS' then 'UPSTAIRS'
        else ''
    end as location_descriptor,
    '' as house_prefix_1,
    case
        when lpaaddr.strhousnum = 0 or lpaaddr.strhousnum is null then ''
        else cast ( cast ( lpaaddr.strhousnum as integer ) as varchar )
    end as house_number_1,
    case
        when lpaaddr.strhoussfx = '0' or lpaaddr.strhoussfx is null then ''
        else cast ( lpaaddr.strhoussfx as varchar )
    end as house_suffix_1,
    '' as house_prefix_2,
    case
        when lpaaddr.endhousnum = 0 or lpaaddr.endhousnum is null then ''
        else cast ( cast ( lpaaddr.endhousnum as integer ) as varchar )
    end as house_number_2,
    case
        when lpaaddr.endhoussfx = '0' or lpaaddr.endhoussfx is null then ''
        else cast ( lpaaddr.endhoussfx as varchar )
    end as house_suffix_2,
    upper ( cnacomp.descr ) as road_name, 
    case
        when
            cnaqual.descr like '% NORTH' or
            cnaqual.descr like '% SOUTH' or
            cnaqual.descr like '% EAST' or
            cnaqual.descr like '% WEST' then upper ( trim ( substr ( cnaqual.descr , 1 , length ( cnaqual.descr ) - 5 ) ) )
        else upper ( cnaqual.descr )
    end as road_type,
    case
        when cnaqual.descr like '% NORTH' then 'N'
        when cnaqual.descr like '% SOUTH' then 'S'
        when cnaqual.descr like '% EAST' then 'E'
        when cnaqual.descr like '% WEST' then 'W'
        else ''
    end as road_suffix, 
    upper ( lpasubr.suburbname ) as locality_name, 
    lpaprtp.abbrev as property_type,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '328' as lga_code,
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
    lpaprop.status <> 'H' and 
    lpaprop.tfklpacncl = 12 and
    lpaaddr.addrtype in ( 'P' , 'A' ) and
    lpaprtp.abbrev <> 'OTH'
)
)
)