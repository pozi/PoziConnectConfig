select
    *,
    spi as constructed_spi,
    'council_attributes' as spi_source,
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
            case when sec <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi
from
(
select
    case
        when A.key1 in ( 16953 , 16899 , 17736 , 15127 , 14359 , 15893 , 14360 , 15303 ) then 'NCPR'
        else cast ( A.key1 as varchar )
    end as propnum,
    cast ( L.land_no as varchar ) as crefno,
    '' as internal_spi,
    '' as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    case
        when part_lot = 'Y' then 'P'
        when L.text3 like 'PT%' then 'P'
        else ''
    end as part,
    case
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( L.plan_desc ) || L.plan_no
        else ifnull ( trim ( L.plan_desc ) || substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_number,
    ifnull ( replace ( replace ( L.plan_desc , 'CG' , '' ) , 'CA' , '' ) , '' ) as plan_prefix,
    case
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull ( substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    ifnull ( replace ( L.lot , ' ' , '' ) , '' ) as lot_number,
    ifnull ( trim ( replace ( upper ( L.text3 ) , 'PT' , '' ) ) ,'' ) as allotment,
    ifnull ( replace ( L.parish_section , 'NO' , '' ) , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case upper ( parish_desc )
        when 'BARAMBOGIE' then '2067'
        when 'BONTHERAMB' then '2180'
        when 'BOORHAMAN' then '2192'
        when 'BUNGAMERO' then '2277'
        when 'BYAWATHA' then '2316'
        when 'CAMBATONG' then '2324'
        when 'CARBOOR' then '2342'
        when 'CARRARAGAR' then '2358'
        when 'CHILTERNW' then '2382'
        when 'DUERANE' then '2556'
        when 'EDI' then '2577'
        when 'ESTCOURT' then '2599'
        when 'EVERTON' then '2610'
        when 'GLENROWEN' then '2685'
        when 'GRETA' then '2726'
        when 'KILLAWARRA' then '2876'
        when 'KOONIKA' then '2909'
        when 'LACEBY' then '2953'
        when 'LURG' then '3022'
        when 'MATONG' then '3074'
        when 'MATONGN' then '3075'
        when 'MIRIMBAH' then '3121'
        when 'MOYHU' then '3205'
        when 'MURMUNGEE' then '3227'
        when 'MYRRHEE' then '3248'
        when 'OXLEY' then '3359'
        when 'PEECHELBA' then '3381'
        when 'TAMINICK' then '3537'
        when 'TARRAWINGE' then '3560'
        when 'TOOMBULLUP' then '3623'
        when 'TOOMBULLUN' then '3624'
        when 'WABONGA' then '3693'
        when 'WABONGAS' then '3694'
        when 'WALLAGOOT' then '3705'
        when 'WANGARATTN' then '3725'
        when 'WANGARATTS' then '3726'
        when 'WHITFIELD' then '3807'
        when 'WHITFIELDS' then '3808'
        when 'WHOROULY' then '3810'
        when 'WINTERIGA' then '3842'
        else ''
    end as parish_code,
    case upper ( L.text1 )
        when 'CTS' then '5170'
        when 'EDTS' then '5267'
        when 'ETS' then '5272'
        when 'EVTS' then '5289'
        when 'GTS' then '5327'
        when 'GRTS' then '5357'
        when 'GWTS' then '5358'
        when 'JTS' then '5397'
        when 'OTS' then '5622'
        when 'PTS' then '5628'
        when 'STS' then '5727'
        when 'WTS' then '5829'
        when 'WHOTS' then '5856'
        else ''
    end as township_code,
    '368' as lga_code,
    cast ( A.key1 as varchar ) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and
        L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = p.Property_no
    left join techone_nucassociation T on A.key1 = T.key1 and
        A.key2 = T.key2 and
        T.association_type = 'TransPRLD' and
        A.date_ended is null
where
    A.association_type = 'PropLand' and
    A.date_ended is null and
    ifnull ( L.plan_desc , '' ) in ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' , 'RP' , 'CG' , 'CA' , '' ) and
    T.key1 is null and
    P.status in ( 'C' , 'F' ) and
    ifnull ( P.rate_analysis_desc , '' ) <> 'Supp'
)
)
