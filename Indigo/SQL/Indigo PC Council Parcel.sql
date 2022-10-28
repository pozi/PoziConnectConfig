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
        when upper ( parish ) = 'BARAMBOGIE' then '2067'
        when upper ( parish ) = 'BARANDUDA' then '2068'
        when upper ( parish ) = 'BARNAWARTHA NORTH' then '2076'
        when upper ( parish ) = 'BARNAWARTHA SOUTH' then '2077'
        when upper ( parish ) = 'BEECHWORTH' then '2099'
        when upper ( parish ) = 'BEETHANG' then '2103'
        when upper ( parish ) = 'BELVOIR WEST' then '2110'
        when upper ( parish ) = 'BERRINGA' then '2126'
        when upper ( parish ) = 'BOLGA' then '2173'
        when upper ( parish ) = 'BONTHERAMBO' then '2180'
        when upper ( parish ) = 'BOORHAMAN' then '2192'
        when upper ( parish ) = 'BRIMIN' then '2231'
        when upper ( parish ) = 'BRUARONG' then '2239'
        when upper ( parish ) = 'BUNDALONG' then '2272'
        when upper ( parish ) = 'BYAWATHA' then '2316'
        when upper ( parish ) = 'CARLYLE' then '2349'
        when upper ( parish ) = 'CHILTERN' then '2381'
        when upper ( parish ) = 'CHILTERN WEST' then '2382'
        when upper ( parish ) = 'EL DORADO' then '2582'
        when upper ( parish ) = 'ELDORADO' then '2582'
        when upper ( parish ) = 'EVERTON' then '2610'
        when upper ( parish ) = 'GOORAMADDA' then '2703'
        when upper ( parish ) = 'GUNDOWRING' then '2734'
        when upper ( parish ) = 'KERGUNYAH' then '2863'
        when upper ( parish ) = 'KERGUNYAH NORTH' then '2864'
        when upper ( parish ) = 'LILLIPUT' then '2996'
        when upper ( parish ) = 'MUDGEEGONGA' then '3210'
        when upper ( parish ) = 'MURMUNGEE' then '3227'
        when upper ( parish ) = 'MURRAMURRANGBONG' then '3232'
        when upper ( parish ) = 'NOORONGONG' then '3322'
        when upper ( parish ) = 'NORONG' then '3323'
        when upper ( parish ) = 'STANLEY' then '3498'
        when upper ( parish ) = 'TALLANDOON' then '3527'
        when upper ( parish ) = 'TANGAMBALANGA' then '3541'
        when upper ( parish ) = 'TANGAMABLANGA' then '3541'
        when upper ( parish ) = 'WOORRAGEE' then '3893'
        when upper ( parish ) = 'WOORAGEE' then '3893'
        when upper ( parish ) = 'WOORRAGEE NORTH' then '3894'
        when upper ( parish ) = 'WOORAGEE NOERH' then '3894'
        when upper ( parish ) = 'YACKANDANDAH' then '3929'
        else ''
    end as parish_code,
    case upper ( township )
        when 'ALLANS FLAT' then '5007'
        when 'BARNAWARTHA' then '5046'
        when 'BEECHWORTH' then '5061'
        when 'BRUARONG' then '5119'
        when 'BUNDALONG' then '5131'
        when 'CARLYLE' then '5156'
        when 'CHILTERN' then '5173'
        when 'DURHAM' then '5258'
        when 'GOORAMADDA' then '5334'
        when 'HAINES' then '5363'
        when 'NORONG' then '5602'
        when 'RUTHERGLEN' then '5690'
        when 'STANLEY' then '5729'
        when 'YACKANDANDAH' then '5893'
        else ''
    end as township_code,
    ifnull ( legacyData1 , '' ) as summary,
    '334' as lga_code,
    '' as assnum
from
    councilwise_parcels
where
    parcelStatus = 1
)
)
)