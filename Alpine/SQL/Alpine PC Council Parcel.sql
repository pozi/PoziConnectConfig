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
        else ifnull ( vicParcelSpi , '' )
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
        when upper ( parish ) = 'BARROWORN' then '2084'
        when upper ( parish ) = 'BARWIDGEE' then '2085'
        when upper ( parish ) = 'BRIGHT' then '2227'
        when upper ( parish ) = 'BRUARONG' then '2239'
        when upper ( parish ) = 'BUCKLAND' then '2247'
        when upper ( parish ) = 'BULGABACK' then '2256'
        when upper ( parish ) = 'BUNGAMERO' then '2277'
        when upper ( parish ) = 'CARRUNO' then '2361'
        when upper ( parish ) = 'COOLUMBOOKA' then '2430'
        when upper ( parish ) = 'COOMA' then '2433'
        when upper ( parish ) = 'DANDONGADALE' then '2484'
        when upper ( parish ) = 'DARBALANG' then '2486'
        when upper ( parish ) = 'DEDERANG' then '2505'
        when upper ( parish ) = 'EURANDELONG' then '2606'
        when upper ( parish ) = 'FREEBURGH' then '2620'
        when upper ( parish ) = 'GUNDOWRING' then '2734'
        when upper ( parish ) = 'HARRIETVILLE' then '2744'
        when upper ( parish ) = 'HOTHAM' then '2765'
        when upper ( parish ) = 'KERGUNYAH' then '2863'
        when upper ( parish ) = 'MAHARATTA' then '3034'
        when upper ( parish ) = 'MATONG NORTH' then '3075'
        when upper ( parish ) = 'MOROCKDONG' then '3191'
        when upper ( parish ) = 'MUDGEGONGA' then '3210'
        when upper ( parish ) = 'MULLAGONG' then '3213'
        when upper ( parish ) = 'MULLAWYE' then '3214'
        when upper ( parish ) = 'MULLINDOLINGONG' then '3215'
        when upper ( parish ) = 'MURMUNGEE' then '3227'
        when upper ( parish ) = 'MYRTLEFORD' then '3249'
        when upper ( parish ) = 'PANBULLA' then '3366'
        when upper ( parish ) = 'POREPUNKAH' then '3413'
        when upper ( parish ) = 'TAWANGA' then '3568'
        when upper ( parish ) = 'THEDDORA' then '3583'
        when upper ( parish ) = 'TOWAMBA' then '3639'
        when upper ( parish ) = 'WANDILIGONG' then '3720'
        when upper ( parish ) = 'WERMATONG' then '3795'
        when upper ( parish ) = 'WHOROULY' then '3810'
        when upper ( parish ) = 'WINTERIGA' then '3842'
        when upper ( parish ) = 'YERTOO' then '3989'
        else ''
    end as parish_code,
    case
        when planPrefix <> 'CA' then ''
        when upper ( parish ) = 'BRIGHT (T)' then '5110'
        when upper ( parish ) = 'DEDERANG (T)' then '5234'
        when upper ( parish ) = 'FREEBURGH (T)' then '5302'
        when upper ( parish ) = 'HARRIETVILLE (T)' then '5367'
        when upper ( parish ) = 'MUDGEGONGA (T)' then '5558'
        when upper ( parish ) = 'MYRTLEFORD (T)' then '5568'
        when upper ( parish ) = 'POREPUNKAH (T)' then '5645'
        when upper ( parish ) = 'WANDILIGONG (T)' then '5826'
        else ''
    end as township_code,
    ifnull ( legacyData1 , '' ) as summary,
    case upper ( suburb )
        when 'FALLS CREEK' then '386'
        when 'HOTHAM HEIGHTS' then '388'
        else '300'
    end as lga_code,
    '' as assnum
from
    councilwise_parcels
where
    parcelStatus = 1
)
)
)