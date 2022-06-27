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
        when upper ( parish ) = 'BALLAPUR' then '2045'
        when upper ( parish ) = 'BANGERANG' then '2062'
        when upper ( parish ) = 'BANYENONG' then '2066'
        when upper ( parish ) = 'BERRIWILLOCK' then '2128'
        when upper ( parish ) = 'BEYAL' then '2138'
        when upper ( parish ) = 'BIMBOURIE' then '2147'
        when upper ( parish ) = 'BOIGBEAT' then '2167'
        when upper ( parish ) = 'BOORONG' then '2195'
        when upper ( parish ) = 'BOURKA' then '2213'
        when upper ( parish ) = 'BUCKRABANYULE' then '2248'
        when upper ( parish ) = 'BUNGULUKE' then '2285'
        when upper ( parish ) = 'BURUPGA' then '2309'
        when upper ( parish ) = 'CARAPUGNA' then '2341'
        when upper ( parish ) = 'CARRON' then '2359'
        when upper ( parish ) = 'CHARLTON EAST' then '2372'
        when upper ( parish ) = 'CHARLTON WEST' then '2373'
        when upper ( parish ) = 'CHINANGIN' then '2384'
        when upper ( parish ) = 'COONOOER EAST' then '2438'
        when upper ( parish ) = 'COONOOER WEST' then '2439'
        when upper ( parish ) = 'COOROOPAJERRUP' then '2445'
        when upper ( parish ) = 'CORACK' then '2447'
        when upper ( parish ) = 'CORACK EAST' then '2448'
        when upper ( parish ) = 'CURYO' then '2477'
        when upper ( parish ) = 'DONALD' then '2532'
        when upper ( parish ) = 'DOOBOOBETIC' then '2529'
        when upper ( parish ) = 'GLENLOTH' then '2677'
        when upper ( parish ) = 'JEFFCOTT' then '2789'
        when upper ( parish ) = 'JERUK' then '2795'
        when upper ( parish ) = 'JIL JIL' then '2797'
        when upper ( parish ) = 'KALPIENUNG' then '2823'
        when upper ( parish ) = 'KANEIRA' then '2829'
        when upper ( parish ) = 'KARYRIE' then '2848'
        when upper ( parish ) = 'KINNABULLA' then '2880'
        when upper ( parish ) = 'KINABULLA' then '2880'
        when upper ( parish ) = 'LAEN' then '2954'
        when upper ( parish ) = 'LALBERT' then '2957'
        when upper ( parish ) = 'LIANIDUCK' then '2990'
        when upper ( parish ) = 'MARLBED' then '3063'
        when upper ( parish ) = 'MOAH' then '3130'
        when upper ( parish ) = 'MOORTWORRA' then '3180'
        when upper ( parish ) = 'MURNUNGIN' then '3229'
        when upper ( parish ) = 'NARRAPORT' then '3276'
        when upper ( parish ) = 'NARREWILLOCK' then '3280'
        when upper ( parish ) = 'NINYEUNOOK' then '3314'
        when upper ( parish ) = 'NULLAWIL' then '3334'
        when upper ( parish ) = 'PERRIT PERRIT' then '3388'
        when upper ( parish ) = 'PIER MILLAN' then '3394'
        when upper ( parish ) = 'RICH AVON EAST' then '3450'
        when upper ( parish ) = 'SWANWATER' then '3515'
        when upper ( parish ) = 'TEDDYWADDY' then '3571'
        when upper ( parish ) = 'TERRAPPEE' then '3577'
        when upper ( parish ) = 'THALIA' then '3581'
        when upper ( parish ) = 'TITTYBONG' then '3600'
        when upper ( parish ) = 'TOORT' then '3635'
        when upper ( parish ) = 'TOWANINNY' then '3641'
        when upper ( parish ) = 'TOWMA' then '3643'
        when upper ( parish ) = 'TUNGIE' then '3658'
        when upper ( parish ) = 'TYENNA' then '3671'
        when upper ( parish ) = 'TYRRELL' then '3678'
        when upper ( parish ) = 'WANGIE' then '3728'
        when upper ( parish ) = 'WARMUR' then '3742'
        when upper ( parish ) = 'WATCHEM' then '3771'
        when upper ( parish ) = 'WATCHUPGA' then '3772'
        when upper ( parish ) = 'WHIRILY' then '3805'
        when upper ( parish ) = 'WILKUR' then '3820'
        when upper ( parish ) = 'WILLANGIE' then '3823'
        when upper ( parish ) = 'WIRMBIRCHIP' then '3848'
        when upper ( parish ) = 'WITCHIPOOL' then '3852'
        when upper ( parish ) = 'WOOROONOOK' then '3892'
        when upper ( parish ) = 'WOOSANG' then '3895'
        when upper ( parish ) = 'WORTONGIE' then '3905'
        when upper ( parish ) = 'WYCHEPROOF' then '3916'
        when upper ( parish ) = 'YEUNGROON' then '3991'
        else ''
    end as parish_code,
    case upper ( township )
        when 'BERRIWILLOCK' then '5075'
        when 'BIRCHIP' then '5084'
        when 'CHARLTON' then '5166'
        when 'CORACK' then '5195'
        when 'CULGOA' then '5216'
        when 'DONALD' then '5247'
        when 'NANDALY' then '5572'
        when 'NULLAWIL' then '5606'
        when 'SEA LAKE' then '5703'
        when 'WATCHEM' then '5842'
        when 'WYCHEPROOF' then '5889'
        else ''
    end as township_code,
    ifnull ( legacyData1 , '' ) as summary,
    '309' as lga_code,
    '' as assnum
from
    councilwise_parcels
where
    parcelStatus = 1
)
)
)