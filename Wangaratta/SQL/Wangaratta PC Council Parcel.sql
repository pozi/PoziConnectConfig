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
    end as spi,
    case
        when plan_numeral <> '' and lot_number = '' then plan_numeral
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_numeral
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_numeral
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select
    case
        when A.key1 in ( 16953 , 16899 , 17736 , 15127 , 14359 , 15893 , 14360 , 15303 ) then 'NCPR'
        else cast ( A.key1 as varchar )
    end as propnum,
    cast ( L.land_no as varchar ) as crefno,
    '' as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    ifnull ( upper ( part_lot ) , '' ) as part,
    case
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( L.plan_desc ) || L.plan_no
        else ifnull ( trim ( L.plan_desc ) || substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_number,
    ifnull ( replace ( L.plan_desc , 'CG' , '' ) , '' ) as plan_prefix,
    case
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull ( substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    ifnull ( replace ( L.lot , ' ' , '' ) , '' ) as lot_number,
    ifnull ( L.text3,'') as allotment,
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
    case    
        when upper ( L.text1 ) = 'CTS' then '5170'
        when upper ( L.text1 ) = 'EDTS' then '5267'
        when upper ( L.text1 ) = 'ETS' then '5272'
        when upper ( L.text1 ) = 'EVTS' then '5289'
        when upper ( L.text1 ) = 'GTS' then '5327'
        when upper ( L.text1 ) = 'GRTS' then '5357'
        when upper ( L.text1 ) = 'GWTS' then '5358'
        when upper ( L.text1 ) = 'JTS' then '5397'
        when upper ( L.text1 ) = 'OTS' then '5622'
        when upper ( L.text1 ) = 'PTS' then '5628'
        when upper ( L.text1 ) = 'STS' then '5727'
        when upper ( L.text1 ) = 'WTS' then '5829'
        when upper ( L.text1 ) = 'WHOTS' then '5856'        
        else ''        
    end as township_code,
    '368' as lga_code
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
    L.plan_desc in ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' , 'RP' , 'CG' ) and
    T.key1 is null and
    P.status in ( 'C' , 'F' , 'c' , 'f' )
)