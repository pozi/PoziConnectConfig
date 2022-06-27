select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when internal_spi <> '' then internal_spi
        else constructed_spi
    end as spi,
    case
        when internal_spi <> '' then 'council_spi'
        else 'council_attributes'
    end as spi_source
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
    end as constructed_spi
from
(
select
    cast ( propertyNumber as varchar ) as propnum,
    '' as status,
    cast ( parcelId as varchar ) as crefno,
    case
        when planPrefix = 'CA' then ''
        else replace ( ifnull ( vicParcelSpi , '' ), '/' , '\' )
    end as internal_spi,
    case
        when isPartOfLot = 'Yes' then 'P'
        else ''
    end as part,
    case
        when planPrefix = 'CA' then ''
        else planPrefix || cast ( planNo as varchar )
    end as plan_number,
    case
        when planPrefix = 'CA' then ''
        else planPrefix
    end as plan_prefix,
    ifnull ( planNo , '' ) as plan_numeral,
    ifnull ( lot , '' ) as lot_number,
    ifnull ( crownAllotment , '' ) as allotment,
    case
        when planPrefix = 'CA' then ifnull ( section , '' )
        else ''
    end as sec,
    ifnull ( block , '' ) as block,
    ifnull ( portion , '' ) as portion,
    ifnull ( subdivision , '' ) as subdivision,
    case
        when planPrefix <> 'CA' then ''
        when upper ( parish ) = 'AWONGA' then '2033'
        when upper ( parish ) = 'BAMBADIN' then '2058'
        when upper ( parish ) = 'BEEWAR' then '2104'
        when upper ( parish ) = 'BENAYEO' then '2115'
        when upper ( parish ) = 'BOGALARA' then '2163'
        when upper ( parish ) = 'BOIKERBERT' then '2168'
        when upper ( parish ) = 'BOOROOPKI' then '2197'
        when upper ( parish ) = 'BRINGALBART' then '2233'
        when upper ( parish ) = 'CHARAM' then '2371'
        when upper ( parish ) = 'CONNEWIRRECOO' then '2426'
        when upper ( parish ) = 'COOACK' then '2427'
        when upper ( parish ) = 'CURTAYNE' then '2476'
        when upper ( parish ) = 'DING-A-DING' then '2525'
        when upper ( parish ) = 'DERGHOLM' then '2512'
        when upper ( parish ) = 'DINYARRAK' then '2527'
        when upper ( parish ) = 'DOPEWORA' then '2538'
        when upper ( parish ) = 'DURONG' then '2570'
        when upper ( parish ) = 'DURNDAL' then '2569'
        when upper ( parish ) = 'EDENHOPE' then '2575'
        when upper ( parish ) = 'GANOO GANOO' then '2634'
        when upper ( parish ) = 'GOROKE' then '2708'
        when upper ( parish ) = 'GYMBOWEN' then '2739'
        when upper ( parish ) = 'HARROW' then '2745'
        when upper ( parish ) = 'JALLAKIN' then '2777'
        when upper ( parish ) = 'JUNGKUM' then '2812'
        when upper ( parish ) = 'KADNOOK' then '2815'
        when upper ( parish ) = 'KALINGUR' then '2818'
        when upper ( parish ) = 'KANIVA' then '2833'
        when upper ( parish ) = 'KARNAK' then '2842'
        when upper ( parish ) = 'KANAWINKA' then '2827'
        when upper ( parish ) = 'KONNEPRA' then '2902'
        when upper ( parish ) = 'KOONIK KOONIK' then '2910'
        when upper ( parish ) = 'KOUT NARIN' then '2933'
        when upper ( parish ) = 'LANGKOOP' then '2967'
        when upper ( parish ) = 'LAWLOIT' then '2981'
        when upper ( parish ) = 'LEEOR' then '2985'
        when upper ( parish ) = 'LILLIMUR' then '2995'
        when upper ( parish ) = 'MAGEPPA' then '3032'
        when upper ( parish ) = 'MAHRONG' then '3036'
        when upper ( parish ) = 'MEEREEK' then '3079'
        when upper ( parish ) = 'MINIMAY' then '3111'
        when upper ( parish ) = 'MIRAMPIRAM' then '3118'
        when upper ( parish ) = 'MOOREE' then '3169'
        when upper ( parish ) = 'MOREA' then '3187'
        when upper ( parish ) = 'MURRANDARRA' then '3233'
        when upper ( parish ) = 'MORTAT' then '3194'
        when upper ( parish ) = 'MURRAWONG' then '3234'
        when upper ( parish ) = 'NATEYIP' then '3284'
        when upper ( parish ) = 'NEUARPUR' then '3303'
        when upper ( parish ) = 'NURCOUNG' then '3342'
        when upper ( parish ) = 'ROSENEATH' then '3458'
        when upper ( parish ) = 'TALLAGEIRA' then '3526'
        when upper ( parish ) = 'TOOLONGROOK' then '3620'
        when upper ( parish ) = 'TOONAMBOOL' then '3625'
        when upper ( parish ) = 'TURANDUREY' then '3659'
        when upper ( parish ) = 'WALLOWA' then '3710'
        when upper ( parish ) = 'WILLOBY' then '3827'
        when upper ( parish ) = 'WOMBELANO' then '3858'
        when upper ( parish ) = 'WYTWARRONE' then '3923'
        when upper ( parish ) = 'YALLAKAR' then '3933'
        when upper ( parish ) = 'YANIPY' then '3952'
        when upper ( parish ) = 'YARROCK' then '3969'
        when upper ( parish ) = 'YEARINGA' then '3980'
        when upper ( parish ) = 'YARRANGOOK' then '3965'
        when upper ( parish ) = 'YOUPAYANG' then '3998'
        when upper ( parish ) = 'COOACK' then '2427'
        else ''
    end as parish_code,
    case
        when upper ( township ) = 'APSLEY' then '5015'
        when upper ( township ) = 'BOOROOPKI' then '5101'
        when upper ( township ) = 'CHETWYND' then '5171'
        when upper ( township ) = 'DERGHOLM' then '5238'
        when upper ( township ) = 'DOUGLAS' then '5249'
        when upper ( township ) = 'EDENHOPE' then '5266'
        when upper ( township ) = 'GOROKE' then '5339'
        when upper ( township ) = 'HARROW' then '5368'
        when upper ( township ) = 'KANIVA' then '5404'
        when upper ( township ) = 'KARNAK' then '5408'
        when upper ( township ) = 'LAWLOIT' then '5455'
        when upper ( township ) = 'KONNEPRA' then '5870'
        when upper ( township ) = 'MINIMAY' then '5532'
        when upper ( township ) = 'MIRAM' then '5535'
        when upper ( township ) = 'NEUARPUR' then '5587'
        when upper ( township ) = 'SERVICETON' then '5709'
        when upper ( township ) = 'SOUTH LILLIMUR' then '5464'
        when upper ( township ) = 'LILLIMUR' then '5463'
        when upper ( township ) = 'TELOPEA DOWNS' then '5775'
        when upper ( township ) = 'WOMBELANO' then '5870'
        else ''
    end as township_code,
    ifnull ( legacyData1 , '' ) as summary,
    '371' as lga_code,
    '' as assnum
from
    councilwise_parcels
where
    parcelStatus = 1
)
)
)