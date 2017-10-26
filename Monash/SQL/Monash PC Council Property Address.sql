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

select
    cast ( cast ( lpaprop.tpklpaprop as integer ) as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    case lpaadfm.tpklpaadfm
        when 1803 then 'Y'
        else ''
    end as hsa_flag,
    case lpaadfm.tpklpaadfm
        when 1803 then
            ( case
                when lpaaddr.lvlprefix is null or lpaaddr.lvlprefix = '' then ''
                else trim ( lpaaddr.lvlprefix )
              end ) ||
                ( case
                    when ( lpaaddr.strlvlnum ) = 0 then ''
                    else cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar)
                 end ) ||
                ( case
                    when ( lpaaddr.unitprefix ) is null or lpaaddr.unitprefix = '' then ''
                    else trim ( lpaaddr.unitprefix )
                 end ) ||
                ( case
                    when lpaaddr.strunitnum = 0 then ''
                    else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
                 end )
        else ''
    end as hsa_unit_id,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        else case
            when lpaaddr.unitprefix = 'ATM' then 'ATM'
            when lpaaddr.unitprefix = 'Factory' then 'FCTY'
            when lpaaddr.unitprefix = 'Office' then 'OFFC'
            when lpaaddr.unitprefix = 'Shop' then 'SHOP'
            when lpaaddr.unitprefix = 'Storage' then 'STOR'
            when lpaaddr.unitprefix = 'Suite' then 'SE'
            when lpaaddr.unitprefix = 'Tower' then 'TWR'
            when lpaaddr.unitprefix = 'Unit' then 'UNIT'
            when lpaaddr.prefix = 'ATM' then 'ATM'
            when lpaaddr.prefix = 'Carwash' then 'CARW'
            when lpaaddr.prefix = 'Factory' then 'FCTY'
            when lpaaddr.prefix = 'Flat' then 'FLAT'
            when lpaaddr.prefix = 'Kiosk' then 'KSK'
            when lpaaddr.prefix = 'Office' then 'OFFC'
            when lpaaddr.prefix = 'Shop' then 'SHOP'
            when lpaaddr.prefix = 'Storeroom' then 'STOR'
            when lpaaddr.prefix in ( 'Suite' , 'Suites' ) then 'SE'
            when lpaaddr.prefix = 'Tower' then 'TWR'
            when lpaaddr.prefix = 'Unit' then 'UNIT'
            when lpaaddr.prefix like 'Bldg%' then 'BLDG'
            when lpaaddr.lvlprefix like 'Bldg%' then 'BLDG'
            else ''
        end
    end as blg_unit_type,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        when lpaaddr.prefix like 'Bldg%' and substr ( lpaaddr.prefix , 6 , 1 ) not in ( '1','2','3','4','5','6','7','8','9' ) then substr ( lpaaddr.prefix , 6 , 1 )
        when lpaaddr.lvlprefix like 'Bldg %' and substr ( lpaaddr.lvlprefix , 6 , 1 ) not in ( '1','2','3','4','5','6','7','8','9' ) then substr ( lpaaddr.lvlprefix , 6 , 1 )
        else ''
    end as blg_unit_prefix_1,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        when lpaaddr.strunitnum = 0 or lpaaddr.strunitnum is null then ''
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as blg_unit_id_1,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        when lpaaddr.strunitsfx = '0' or lpaaddr.strunitsfx is null then ''
        else cast ( lpaaddr.strunitsfx as varchar )
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        when lpaaddr.endunitnum = 0 or lpaaddr.endunitnum is null then ''
        else cast ( cast ( lpaaddr.endunitnum as integer ) as varchar )
    end as blg_unit_id_2,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        when lpaaddr.endunitsfx = '0' or lpaaddr.endunitsfx is null then ''
        else cast ( lpaaddr.endunitsfx as varchar )
    end as blg_unit_suffix_2,
    case
        when lpaaddr.lvlprefix = 'Carpark' then 'P'
        when lpaaddr.lvlprefix = 'G0' then 'G'
        when lpaaddr.lvlprefix = 'Ground' then 'G'
        when lpaaddr.lvlprefix = 'Ground Lvl' then 'G'
        when lpaaddr.lvlprefix = 'Level' then 'L'
        when lpaaddr.lvlprefix = 'Levels' then 'L'
        when lpaaddr.lvlprefix = 'LG0' then 'LG'
        when lpaaddr.lvlprefix = 'Roof' then 'RT'
        when lpaaddr.lvlprefix in ('B','FL','G','L','LB','LG','LL','M','OD','P','PD','PF','RT','SB','UG') then lpaaddr.lvlprefix
        when lpaaddr.prefix = 'Lwr Ground' then 'LG'
        when lpaaddr.prefix like 'Level %' then 'L'
        else ''
    end as floor_type,
    '' as floor_prefix_1,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        when lpaaddr.strlvlnum <> 0 then cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar )
        when lpaaddr.prefix like 'Level %' then substr ( lpaaddr.prefix , 7 , 2 )
        else ''
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when lpaadfm.tpklpaadfm = 1803 then ''
        when lpaaddr.endlvlnum = 0 then ''
        else cast ( cast ( lpaaddr.endlvlnum as integer ) as varchar )
    end as floor_no_2,
    '' as floor_suffix_2,
    case
        when lpapnam.propname like '%CENTRO%' then ''
        when lpapnam.propname like '%SHOPPING CENTRE%' then ''
        else ifnull ( upper ( lpapnam.propname ) , '' )
    end as building_name,
    case
        when lpapnam.propname like '%CENTRO%' then  upper ( lpapnam.propname )
        when lpapnam.propname like '%SHOPPING CENTRE%' then  upper ( lpapnam.propname )
        else ''
    end as complex_name,
    case lpaaddr.prefix
        when 'Above' then 'ABOVE'
        when 'Below' then 'BELOW'
        when 'Under' then 'BELOW'
        when 'Front' then 'FRONT'
        when 'Off' then 'OFF'
        when 'Opposite' then 'OPPOSITE'
        when 'Rear' then 'REAR'
        when 'Rear of' THEN 'REAR'
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
        else ifnull ( upper ( cnaqual.descr ) , '' )
    end as road_type,
    case
        when cnaqual.descr like '%NORTH' then 'N'
        when cnaqual.descr like '%SOUTH' then 'S'
        when cnaqual.descr like '%EAST' then 'E'
        when cnaqual.descr like '%WEST' then 'W'
        else ''
    end as road_suffix,
    upper ( lpasubr.suburbname ) as locality_name,
    '' as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '348' as lga_code,
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
    pathway_lpapnam as lpapnam on lpaprop.tpklpaprop = lpapnam.tfklpaprop left join
    pathway_lpaadfm as lpaadfm on lpaadpr.tfklpaadfm = lpaadfm.tpklpaadfm
where
    lpaprop.status <> 'H' and
    lpaprop.tfklpacncl = 12 and
    lpaaddr.addrtype = 'P' and
    lpaprtp.abbrev <> 'HEADER'
)
)
)
