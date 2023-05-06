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
        when upper ( lpaaddr.unitprefix ) is null then ''
        when upper ( lpaaddr.unitprefix ) in ('ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then upper ( lpaaddr.unitprefix )
        when upper ( lpaaddr.unitprefix ) = 'OFFICE' then 'OFFC'
        when upper ( lpaaddr.unitprefix ) = 'SUITE' then 'SE'
        when upper ( lpaaddr.prefix ) in ('ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then upper ( lpaaddr.prefix )
        when upper ( lpaaddr.prefix ) = 'BUILDING' then 'BLDG'
        when upper ( lpaaddr.prefix ) = 'ADV SIGN' then 'SIGN'
        when upper ( lpaaddr.prefix ) = 'KIOSK' then 'KSK'
        else ''
    end as blg_unit_type,
    case
        when upper ( cnacomp.descr ) in ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' ) and length ( lpaaddr.prefix ) in ( 1 , 2 ) then upper ( lpaaddr.prefix )
        when upper ( cnacomp.descr ) in ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' ) and substr ( lpaaddr.prefix , 1 , 2 ) in ( 'C ' , 'E ' , 'N ' , 'NN' ) then trim ( substr ( lpaaddr.prefix , 1 , 2 ) )
        when length ( lpaaddr.lvlprefix ) in ( 1 , 2 ) then upper ( lpaaddr.lvlprefix )
        when upper ( lpaaddr.unitprefix ) in ('ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then ''
        when length ( lpaaddr.unitprefix ) = 1 then upper ( lpaaddr.unitprefix )
        when ifnull ( lpaaddr.strunitnum , 0 ) > 0 and length ( lpaaddr.prefix ) in ( 1 , 2 ) and not upper ( lpaaddr.prefix ) in ( 'GX' , 'GZ' ) then upper ( ifnull ( lpaaddr.prefix , '' ) )
        else ''
    end as blg_unit_prefix_1,
    case
        when upper ( cnacomp.descr ) in ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' ) and lpaaddr.strhousnum <> 0 then cast ( cast ( lpaaddr.strhousnum as integer ) as varchar )
        when lpaaddr.strunitnum = 0 or lpaaddr.strunitnum is null then ''
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as blg_unit_id_1,
    case
        when upper ( cnacomp.descr ) in ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' ) and ifnull ( lpaaddr.strhoussfx , '' ) <> '' then upper ( ifnull ( lpaaddr.strhoussfx , '' ) )
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
        when upper ( lpaaddr.lvlprefix ) in ( 'B','FL','G','L','LG','M','UG','RT','PD','LB','LL','OD','P','PF','SB' ) then upper ( lpaaddr.lvlprefix )
        when upper ( lpaaddr.lvlprefix ) = 'BASEMENT' then 'B'
        when upper ( lpaaddr.lvlprefix ) = 'FLOOR' then 'FL'
        when upper ( lpaaddr.lvlprefix ) = 'GROUND' then 'G'
        when upper ( lpaaddr.lvlprefix ) = 'LEVEL' then 'L'
        when upper ( lpaaddr.lvlprefix ) = 'LWR GROUND' then 'LG'
        else ''
    end as floor_type,
    '' as floor_prefix_1,
    case
        when lpaaddr.strlvlnum <> 0 then cast ( cast ( lpaaddr.strlvlnum as integer ) as varchar )
        else ''
    end as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when lpaaddr.endlvlnum = 0 then ''
        else cast ( cast ( lpaaddr.endlvlnum as integer ) as varchar )
    end as floor_no_2,
    '' as floor_suffix_2,
    upper ( ifnull ( lpapnam.propname , '' ) ) as building_name,
    case
        when upper ( cnacomp.descr ) in ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' ) then upper ( cnacomp.descr )
        when upper ( cnacomp.descr ) = 'THE AGORA LA TROBE UNIVERSITY' then 'LA TROBE UNIVERSITY'
        else ''
    end as complex_name,
    case
        when lpaaddr.prefix is null then ''
        when upper ( lpaaddr.prefix ) = 'FRONT OF' then 'FRONT'
        when upper ( lpaaddr.prefix ) = 'REAR OF' then 'REAR'
        when upper ( lpaaddr.prefix ) in ('ABOVE','ADJACENT','BELOW','BETWEEN','CORNER','EAST','FRONT','NORTH','OFF','OPPOSITE','PART','REAR','ROOFTOP','SOUTH','WEST') then upper ( lpaaddr.prefix )
        when upper ( lpaaddr.lvlprefix ) = 'UPSTAIRS' then 'ABOVE'
        else ''
    end as location_descriptor,
    case
        when upper ( cnacomp.descr ) in ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' ) then ''
        when upper ( lpaaddr.prefix ) in ( 'GX' , 'GZ' ) then ''
        when ifnull ( lpaaddr.strunitnum , 0 ) > 0 then ''
        when length ( lpaaddr.prefix ) in ( 1 , 2 ) then upper ( lpaaddr.prefix )
        else ''
    end as house_prefix_1,
    case
        when upper ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' then '2'
        when upper ( cnacomp.descr ) = 'PRESTON MARKET' then '20'
        when lpaaddr.strhousnum = 0 or lpaaddr.strhousnum is null then ''
        else cast ( cast ( lpaaddr.strhousnum as integer ) as varchar )
    end as house_number_1,
    case
        when upper ( cnacomp.descr ) in ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' ) then ''
        when upper ( lpaaddr.prefix ) in ( 'GX' , 'GZ' ) then upper ( lpaaddr.prefix )
        when lpaaddr.strhoussfx = '0' or lpaaddr.strhoussfx is null then ''
        else cast ( lpaaddr.strhoussfx as varchar )
    end as house_suffix_1,
    '' as house_prefix_2,
    case
        when upper ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' then '50'
        when lpaaddr.endhousnum = 0 or lpaaddr.endhousnum is null then ''
        else cast ( cast ( lpaaddr.endhousnum as integer ) as varchar )
    end as house_number_2,
    case
        when lpaaddr.endhoussfx = '0' or lpaaddr.endhoussfx is null then ''
        else cast ( lpaaddr.endhoussfx as varchar )
    end as house_suffix_2,
    case
        when upper ( cnacomp.descr ) = 'JV SMITH' then 'J V SMITH'
        when upper ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' then 'MURRAY'
        when upper ( cnacomp.descr ) = 'PRESTON MARKET' then 'CRAMER'
        when upper ( cnacomp.descr ) = 'THE AGORA LA TROBE UNIVERSITY' then 'THE AGORA'
        when cnacomp.descr like '%''%' then replace ( upper ( cnacomp.descr ) , '''' , '' )
        when cnacomp.descr like '%MC %' then replace ( upper ( cnacomp.descr ) , 'MC ' , 'MC' )
        else upper ( cnacomp.descr )
    end as road_name,
    case
        when upper ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' then 'ROAD'
        when upper ( cnacomp.descr ) = 'PRESTON MARKET' then 'STREET'
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
    '316' as lga_code,
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
    pathway_lparole as lparole on lpaprop.tpklpaprop = lparole.tfklocl left join
    pathway_lraassm as lraassm on lparole.tfkappl = lraassm.tpklraassm left join
    pathway_lpaadfm as lpaadfm on lpaadpr.tfklpaadfm = lpaadfm.tpklpaadfm
where
    lpaprop.status <> 'H' and
    lpaaddr.addrtype = 'P' and
    lpaprop.tfklpacncl = 14 and
    lpaprtp.abbrev <> 'MASTER'
)
)
)
