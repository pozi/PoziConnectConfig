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
    cast ( propertyNumber as varchar ) ||
        case
            when substr ( propertyNumber , -7 , 1 ) = '.' then ''
            when substr ( propertyNumber , -6 , 1 ) = '.' then '0'
            when substr ( propertyNumber , -5 , 1 ) = '.' then '00'
            when substr ( propertyNumber , -4 , 1 ) = '.' then '000'
            when substr ( propertyNumber , -3 , 1 ) = '.' then '0000'
            when substr ( propertyNumber , -2 , 1 ) = '.' then '00000'
            else '.000000'
        end as propnum,
    '' as status,
    cast ( parcelId as varchar ) as crefno,
    ifnull ( vicParcelSpi , '' ) as internal_spi,
    case
        when isPartOfLot = 'Yes' then 'P'
        else ''
    end as part,
    ifnull ( planPrefix || cast ( planNo as varchar ) , '' ) as plan_number,
    ifnull ( planPrefix , '' ) as plan_prefix,
    ifnull ( planNo , '' ) as plan_numeral,
    ifnull ( lot , '' ) as lot_number,
    ifnull ( crownAllotment , '' ) as allotment,
    ifnull ( section , '' ) as sec,
    ifnull ( block , '' ) as block,
    ifnull ( portion , '' ) as portion,
    ifnull ( subdivision , '' ) as subdivision,
    case
        when upper ( parish ) = 'ADZAR' then '2004'
        when upper ( parish ) = 'ARARAT' then '2020'
        when upper ( parish ) = 'BALLYROGAN' then '2051'
        when upper ( parish ) = 'BELLELLEN' then '2108'
        when upper ( parish ) = 'BOROKA' then '2208'
        when upper ( parish ) = 'BUANGOR' then '2243'
        when upper ( parish ) = 'BUCKERAN YARRACK' then '2246'
        when upper ( parish ) = 'BULGANA' then '2257'
        when upper ( parish ) = 'BUNNUGAL' then '2288'
        when upper ( parish ) = 'BURRAH BURRAH' then '2297'
        when upper ( parish ) = 'BURRUMBEEP' then '2304'
        when upper ( parish ) = 'CARAMBALLUC NORTH' then '2334'
        when upper ( parish ) = 'CARAMBALLUC SOUTH' then '2335'
        when upper ( parish ) = 'CHATSWORTH WEST' then '2375'
        when upper ( parish ) = 'COLVINSBY' then '2415'
        when upper ( parish ) = 'CONCONGELLA SOUTH' then '2419'
        when upper ( parish ) = 'CROWLANDS' then '2468'
        when upper ( parish ) = 'DUNNEWORTHY' then '2566'
        when upper ( parish ) = 'EILYAR' then '2581'
        when upper ( parish ) = 'EURAMBEEN' then '2605'
        when upper ( parish ) = 'EVERSLEY' then '2609'
        when upper ( parish ) = 'GLENPATRICK' then '2684'
        when upper ( parish ) = 'GORRINN' then '2710'
        when upper ( parish ) = 'HELENDOITE' then '2751'
        when upper ( parish ) = 'JALLUKAR' then '2778'
        when upper ( parish ) = 'JALUR' then '2779'
        when upper ( parish ) = 'KALYMNA' then '2824'
        when upper ( parish ) = 'KIORA' then '2886'
        when upper ( parish ) = 'KORNONG' then '2923'
        when upper ( parish ) = 'LALKALDARNO' then '2958'
        when upper ( parish ) = 'LANGI LOGAN' then '2966'
        when upper ( parish ) = 'LANGI-GHIRAN' then '2964'
        when upper ( parish ) = 'LEXINGTON' then '2988'
        when upper ( parish ) = 'MELLIER' then '3086'
        when upper ( parish ) = 'MERRYMBUELA' then '3097'
        when upper ( parish ) = 'MININERA' then '3112'
        when upper ( parish ) = 'MIRRANATWA' then '3124'
        when upper ( parish ) = 'MOALLAACK' then '3131'
        when upper ( parish ) = 'MOKEPILLY' then '3140'
        when upper ( parish ) = 'MOUNT COLE' then '3198'
        when upper ( parish ) = 'MOUTAJUP' then '3200'
        when upper ( parish ) = 'MOYSTON' then '3207'
        when upper ( parish ) = 'MOYSTON WEST' then '3208'
        when upper ( parish ) = 'NANAPUNDAH' then '3253'
        when upper ( parish ) = 'NEKEEYA' then '3295'
        when upper ( parish ) = 'NERRIN NERRIN' then '3302'
        when upper ( parish ) = 'PANYYABYR' then '3371'
        when upper ( parish ) = 'PARRIE YALLOAK' then '3373'
        when upper ( parish ) = 'PARUPA' then '3374'
        when upper ( parish ) = 'RAGLAN WEST' then '3440'
        when upper ( parish ) = 'SHIRLEY' then '3488'
        when upper ( parish ) = 'STREATHAM' then '3508'
        when upper ( parish ) = 'TARA' then '3546'
        when upper ( parish ) = 'TATYOON' then '3567'
        when upper ( parish ) = 'TOWANWAY' then '3642'
        when upper ( parish ) = 'WALLA WALLA' then '3708'
        when upper ( parish ) = 'WARRAK' then '3750'
        when upper ( parish ) = 'WATGANIA' then '3774'
        when upper ( parish ) = 'WATGANIA WEST' then '3775'
        when upper ( parish ) = 'WICKLIFFE NORTH' then '3814'
        when upper ( parish ) = 'WICKLIFFE SOUTH' then '3815'
        when upper ( parish ) = 'WILLAM' then '3822'
        when upper ( parish ) = 'WILLAURA' then '3825'
        when upper ( parish ) = 'WONGAN' then '3860'
        when upper ( parish ) = 'WOODNAGGERAK' then '3873'
        when upper ( parish ) = 'WOORNDOO' then '3890'
        when upper ( parish ) = 'YALLA-Y-POORA' then '3934'
        when upper ( parish ) = 'YUPPECKIAR' then '4004'
        else ''
    end as parish_code,
    case
        when upper ( township ) = 'ARARAT' then '5017'
        when upper ( township ) = 'BALLYROGAN' then '5034'
        when upper ( township ) = 'BUANGOR' then '5121'
        when upper ( township ) = 'ELMHURST' then '5276'
        when upper ( township ) = 'LAKE BOLAC' then '5444'
        when upper ( township ) = 'MAFEKING' then '5489'
        when upper ( township ) = 'MAROONA' then '5506'
        when upper ( township ) = 'MOYSTON' then '5556'
        when upper ( township ) = 'PURA PURA' then '5656'
        when upper ( township ) = 'ROSSBRIDGE' then '5684'
        when upper ( township ) = 'STREATHAM' then '5741'
        when upper ( township ) = 'WARRAK' then '5836'
        when upper ( township ) = 'WESTMERE' then '5851'
        when upper ( township ) = 'WICKLIFFE' then '5858'
        else ''
    end as township_code,
    ifnull ( legalDescription , '' ) as summary,
    '301' as lga_code,
    '' as assnum
from
    councilwise_parcels
where
    parcelStatus = 1
)
)
)