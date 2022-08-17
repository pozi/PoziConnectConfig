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
        when upper ( parish ) = 'ADJIE' then '2003'
        when upper ( parish ) = 'BEETHANG' then '2103'
        when upper ( parish ) = 'BENAMBRA' then '2114'
        when upper ( parish ) = 'BERRINGA' then '2126'
        when upper ( parish ) = 'BERRINGAMA' then '2127'
        when upper ( parish ) = 'BOGONG NORTH' then '2164'
        when upper ( parish ) = 'BOGONG SOUTH' then '2165'
        when upper ( parish ) = 'BOLGA' then '2173'
        when upper ( parish ) = 'BONEGILLA' then '2178'
        when upper ( parish ) = 'BOORGUNYAH' then '2191'
        when upper ( parish ) = 'BULLIOH' then '2266'
        when upper ( parish ) = 'BUNGIL' then '2283'
        when upper ( parish ) = 'BUNGIL EAST' then '2284'
        when upper ( parish ) = 'BURROWYE' then '2303'
        when upper ( parish ) = 'BURRUNGABUGGE' then '2307'
        when upper ( parish ) = 'CANABORE' then '2327'
        when upper ( parish ) = 'CANBORE' then '2327'
        when upper ( parish ) = 'COLAC COLAC' then '2406'
        when upper ( parish ) = 'CORRYONG' then '2457'
        when upper ( parish ) = 'CUDGEWA' then '2471'
        when upper ( parish ) = 'DARTELLA' then '2500'
        when upper ( parish ) = 'DORCHAP' then '2539'
        when upper ( parish ) = 'GIBBO' then '2652'
        when upper ( parish ) = 'GRANYA' then '2720'
        when upper ( parish ) = 'GUNDOWRING' then '2734'
        when upper ( parish ) = 'GUNGARLAN' then '2735'
        when upper ( parish ) = 'INDI' then '2772'
        when upper ( parish ) = 'JEMBA' then '2791'
        when upper ( parish ) = 'JINGELLIC' then '2803'
        when upper ( parish ) = 'JINJELLIC' then '2803'
        when upper ( parish ) = 'KANCOBIN' then '2828'
        when upper ( parish ) = 'KEELANGIE' then '2855'
        when upper ( parish ) = 'KOETONG' then '2895'
        when upper ( parish ) = 'KOSCIUSKO' then '2931'
        when upper ( parish ) = 'MAGORRA' then '3033'
        when upper ( parish ) = 'MALKARA' then '3043'
        when upper ( parish ) = 'MITTA MITTA' then '3127'
        when upper ( parish ) = 'MOWAMBA' then '3203'
        when upper ( parish ) = 'MOYANGUL' then '3204'
        when upper ( parish ) = 'MULLAGONG' then '3213'
        when upper ( parish ) = 'NARIEL' then '3266'
        when upper ( parish ) = 'NOORONGONG' then '3322'
        when upper ( parish ) = 'PINNIBAR' then '3399'
        when upper ( parish ) = 'TALGARNO' then '3524'
        when upper ( parish ) = 'TALLANDOON' then '3527'
        when upper ( parish ) = 'TANGAMBALANGA' then '3541'
        when upper ( parish ) = 'TATONGA' then '3566'
        when upper ( parish ) = 'THOLOGOLONG' then '3584'
        when upper ( parish ) = 'THOWGLA' then '3588'
        when upper ( parish ) = 'THOWLGA' then '3588'
        when upper ( parish ) = 'TINTALDRA' then '3599'
        when upper ( parish ) = 'TONGARO' then '3603'
        when upper ( parish ) = 'TOWONG' then '3644'
        when upper ( parish ) = 'UNDOWAH' then '3683'
        when upper ( parish ) = 'WABBA' then '3691'
        when upper ( parish ) = 'WAGRA' then '3698'
        when upper ( parish ) = 'WALLABY' then '3704'
        when upper ( parish ) = 'WALWA' then '3717'
        when upper ( parish ) = 'WELUMLA' then '3791'
        when upper ( parish ) = 'WERMATONG' then '3795'
        when upper ( parish ) = 'WOLLONABY' then '3856'
        when upper ( parish ) = 'WYEEBOO' then '3918'
        when upper ( parish ) = 'YABBA' then '3927'
        else ''
    end as parish_code,
    case
        when upper ( township ) = 'TOWONG' then '5799'
        when upper ( township ) = 'NARIEL' then '5575'
        when upper ( township ) = 'CORRYONG' then '5200'
        when upper ( township ) = 'DARTMOUTH' then '5230'
        when upper ( township ) = 'BEETOOMBA' then '5063'
        when upper ( township ) = 'CRAVENSVILLE' then '5208'
        when upper ( township ) = 'BERRINGAMA' then '5074'
        when upper ( township ) = 'GRANITE FLAT' then '5345'
        when upper ( township ) = 'MITTA MITTA' then '5539'
        when upper ( township ) = 'KOETONG' then '5425'
        when upper ( township ) = 'TALLANGATTA VALLEY' then '5758'
        when upper ( township ) = 'ESKDALE' then '5285'
        when upper ( township ) = 'GRANYA' then '5349'
        when upper ( township ) = 'TALLANGATTA' then '5757'
        when upper ( township ) = 'TATONGA' then '5772'
        when upper ( township ) = 'BETHANGA' then '5079'
        else ''
    end as township_code,
    ifnull ( legacyData1 , '' ) as summary,
    '367' as lga_code,
    '' as assnum
from
    councilwise_parcels
where
    parcelStatus = 1
)
)
)