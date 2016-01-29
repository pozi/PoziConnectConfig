select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi
from
(
select
    cast ( A.key1 as varchar ) as propnum,
    cast ( L.land_no as varchar ) as crefno,
    '' as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    case 
        when ifnull ( upper ( part_lot ) , '' ) = 'Y' then 'P'
        else  ifnull ( upper ( part_lot ) , '' )
    end as part,
    case
        when substr ( L.plan_no , 1 , 1 ) not in ( '1','2','3','4','5','6','7','8','9','0' ) then ''
        when L.plan_desc = 'CrownDetl' then ''
        when substr ( trim ( ifnull ( L.plan_no , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || ifnull ( L.plan_no , '' )
        else trim ( ifnull ( L.plan_desc , '' ) ) || substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 )
    end as plan_number,
    case 
        when L.plan_desc = 'CrownDetl' then ''
        else ifnull ( L.plan_desc , '' )
    end as plan_prefix,
    case
        when substr ( L.plan_no , 1 , 1 ) not in ( '1','2','3','4','5','6','7','8','9','0' ) then ''
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull (substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    upper ( replace ( ifnull ( L.lot , '' ) , ' ' , '' ) ) as lot_number,
    ifnull ( L.CERT_OF_TITLE , '' ) as allotment,
    ifnull ( L.SECTION_FOR_LOT , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case L.parish_desc
        when 'Borriyall' then '2210'	
        when 'Borryall' then '2210'
        when 'Brucknell' then '2240'
        when 'CaramSth' then '2335'
        when 'Carpendeit' then '2354'
        when 'Colongulac' then '2411'
        when 'Cooriejong' then '2442'
        when 'Coradjil' then '2449'
        when 'Corangamit' then '2450'
        when 'Cressy' then '2463'
        when 'Darlington' then '2492'
        when 'Dunnawalla' then '2565'
        when 'Ecklin' then '2573'
        when 'Elingamite' then '2583'
        when 'Ettrick' then '2600'
        when 'Galla' then '2629'
        when 'Garvoc' then '2636'
        when 'Geelengla' then '2639'
        when 'Glenston' then '2683'
        when 'Gnarkeet' then '2688'
        when 'Jancourt' then '2781'
        when 'Jellalabad' then '2790'
        when 'Kariah' then '2840'
        when 'Keilambete' then '2857'
        when 'Kilnoorat' then '2878'
        when 'KtKtNong' then '2919'
        when 'La Trobe' then '2977'
        when 'Latrobe' then '2977'
        when 'Lismore' then '3002'
        when 'Mannibadar' then '3054'
        when 'MaridaYall' then '3062'
        when 'Moowroong' then '3157'
        when 'Narrawatk' then '3277'
        when 'NatMurrang' then '3286'
        when 'Paaratte' then '3360'
        when 'PbeteNth' then '3428'
        when 'PbeteSth' then '3429'
        when 'Pircarra' then '3400'
        when 'PoliahNth' then '3403'
        when 'PoliahSth' then '3404'
        when 'Pomborneit' then '3406'
        when 'Skipton' then '3489'
        when 'Struan' then '3509'
        when 'Taaraak' then '3517'
        when 'Tandarook' then '3539'
        when 'Terang' then '3575'
        when 'Timboon' then '3595'
        when 'Tooliorook' then '3615'
        when 'ViteVite' then '3687'
        when 'Waarre' then '3690'
        when 'Wangerrip' then '3727'
        when 'WilgulNth' then '3816'
        when 'WilgulSth' then '3817'
        when 'Wiridjil' then '3847'
        else ''
    end as parish_code,
    case L.county_desc 
        when 'Berrybank' then '5076'
        when 'Camperdown' then '5147'
        when 'Cobden' then '5180'
        when 'Cressy' then '5210'
        when 'Darlington' then '5226'
        when 'Derrinallu' then '5239'
        when 'ElingamitN' then '5273'
        when 'Elingamite' then ''
        when 'Foxhow' then '5298'
        when 'Garvoc' then '5309'
        when 'Lismore' then '5468'
        when 'MackinnonB' then '5488'
        when 'Nirranda' then '5599'
        when 'Port Campb' then '5648'
        when 'Princetown' then '5654'
        when 'Scotts Crk' then '5701'
        when 'Simpson' then ''
        when 'Skipton' then '5717'
        when 'Terang' then '5778'
        when 'Timboon' then '5783'
        else ''
    end as township_code,
    '315' as lga_code,
    cast ( A.key1 as varchar ) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
where
    A.association_type = 'PropLand' and
    A.date_ended is null and
    P.status in ( 'C' , 'F' )
)
)