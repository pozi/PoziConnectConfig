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
        when upper ( parish ) = 'ADZAR' then '2004'
        when upper ( parish ) = 'AUDLEY' then '2030'
        when upper ( parish ) = 'BALMORAL' then '2053'
        when upper ( parish ) = 'BEEAR' then '2098'
        when upper ( parish ) = 'BEERIK' then '2102'
        when upper ( parish ) = 'BEPCHA' then '2122'
        when upper ( parish ) = 'BIL-BIL-WYT' then '2142'
        when upper ( parish ) = 'BILLIMINAH' then '2145'
        when upper ( parish ) = 'BILPAH' then '2146'
        when upper ( parish ) = 'BOCHARA' then '2161'
        when upper ( parish ) = 'BOONAHWAH' then '2188'
        when upper ( parish ) = 'BOORPOOL' then '2198'
        when upper ( parish ) = 'BORAMBORAM' then '2203'
        when upper ( parish ) = 'BOREANG EAST' then '2204'
        when upper ( parish ) = 'BOREANG WEST' then '2205'
        when upper ( parish ) = 'BRANXHOLME' then '2222'
        when upper ( parish ) = 'BRIM BRIM' then '2230'
        when upper ( parish ) = 'BRIMBOAL' then '2228'
        when upper ( parish ) = 'BRIT BRIT' then '2234'
        when upper ( parish ) = 'BRUK BRUK' then '2241'
        when upper ( parish ) = 'BUCKERAN YARRACK' then '2246'
        when upper ( parish ) = 'BULART' then '2253'
        when upper ( parish ) = 'BULLAWIN' then '2263'
        when upper ( parish ) = 'BUNNUGAL' then '2288'
        when upper ( parish ) = 'BURRAH BURRAH' then '2297'
        when upper ( parish ) = 'BYADUK' then '2313'
        when upper ( parish ) = 'BYAMBYNEE' then '2314'
        when upper ( parish ) = 'CARAMUT SOUTH' then '2337'
        when upper ( parish ) = 'CARAPOOK' then '2340'
        when upper ( parish ) = 'CARRAK' then '2357'
        when upper ( parish ) = 'CAVENDISH' then '2368'
        when upper ( parish ) = 'CHATSWORTH WEST' then '2375'
        when upper ( parish ) = 'COLERAINE' then '2408'
        when upper ( parish ) = 'CONNEWIRRECOO' then '2426'
        when upper ( parish ) = 'COREA' then '2451'
        when upper ( parish ) = 'CROXTON EAST' then '2469'
        when upper ( parish ) = 'CROXTON WEST' then '2470'
        when upper ( parish ) = 'DAAHL' then '2479'
        when upper ( parish ) = 'DEWRANG' then '2521'
        when upper ( parish ) = 'DUNKELD' then '2562'
        when upper ( parish ) = 'GANOO GANOO' then '2634'
        when upper ( parish ) = 'GATUM GATUM' then '2637'
        when upper ( parish ) = 'GEERAK' then '2641'
        when upper ( parish ) = 'GRINGEGALGONA' then '2727'
        when upper ( parish ) = 'GRITJURK' then '2728'
        when upper ( parish ) = 'HAMILTON NORTH' then '2741'
        when upper ( parish ) = 'HAMILTON SOUTH' then '2742'
        when upper ( parish ) = 'HARROW' then '2745'
        when upper ( parish ) = 'HILGAY' then '2757'
        when upper ( parish ) = 'JALUR' then '2779'
        when upper ( parish ) = 'JENNAWARRA' then '2792'
        when upper ( parish ) = 'JERRYWAROOK' then '2794'
        when upper ( parish ) = 'KANAWALLA' then '2826'
        when upper ( parish ) = 'KARABEAL' then '2836'
        when upper ( parish ) = 'KARUP KARUP' then '2846'
        when upper ( parish ) = 'KAY' then '2854'
        when upper ( parish ) = 'KNAAWING' then '2890'
        when upper ( parish ) = 'KONGBOOL' then '2900'
        when upper ( parish ) = 'KONONG WOOTONG' then '2903'
        when upper ( parish ) = 'KOOLOMERT' then '2906'
        when upper ( parish ) = 'KOUT NARIN' then '2933'
        when upper ( parish ) = 'LALKALDARNO' then '2958'
        when upper ( parish ) = 'LAMBRUK' then '2961'
        when upper ( parish ) = 'LANGULAC' then '2971'
        when upper ( parish ) = 'LARNEEBUNYAH' then '2975'
        when upper ( parish ) = 'LINLITHGOW' then '2999'
        when upper ( parish ) = 'MERINO' then '3092'
        when upper ( parish ) = 'MIRRANATWA' then '3124'
        when upper ( parish ) = 'MOKANGER' then '3139'
        when upper ( parish ) = 'MONIVAE' then '3151'
        when upper ( parish ) = 'MOORALLA' then '3165'
        when upper ( parish ) = 'MOOREE' then '3169'
        when upper ( parish ) = 'MOORWINSTOWE' then '3181'
        when upper ( parish ) = 'MOSTYN' then '3197'
        when upper ( parish ) = 'MOUTAJUP' then '3200'
        when upper ( parish ) = 'MUNTHAM' then '3221'
        when upper ( parish ) = 'MURNDAL' then '3228'
        when upper ( parish ) = 'MURYRTYM' then '3242'
        when upper ( parish ) = 'NANAPUNDAH' then '3253'
        when upper ( parish ) = 'NAPIER' then '3260'
        when upper ( parish ) = 'NAREEB NAREEB' then '3265'
        when upper ( parish ) = 'NEKEEYA' then '3295'
        when upper ( parish ) = 'PANYYABYR' then '3371'
        when upper ( parish ) = 'PAWBYMBYR' then '3379'
        when upper ( parish ) = 'PENDYK PENDYK' then '3384'
        when upper ( parish ) = 'POM POM' then '3408'
        when upper ( parish ) = 'PURDEET' then '3423'
        when upper ( parish ) = 'PURDEET EAST' then '3424'
        when upper ( parish ) = 'REDRUTH' then '3447'
        when upper ( parish ) = 'TAHARA' then '3522'
        when upper ( parish ) = 'TALLANGOORK' then '3531'
        when upper ( parish ) = 'TARRAYOUKYAN' then '3561'
        when upper ( parish ) = 'TELANGATUK' then '3572'
        when upper ( parish ) = 'TOOLANG' then '3614'
        when upper ( parish ) = 'TOOLKA' then '3616'
        when upper ( parish ) = 'TYAR' then '3670'
        when upper ( parish ) = 'URANGARA' then '3685'
        when upper ( parish ) = 'WANWANDYRA' then '3732'
        when upper ( parish ) = 'WARRABKOOK' then '3744'
        when upper ( parish ) = 'WARRAYURE' then '3757'
        when upper ( parish ) = 'WATEGAT' then '3773'
        when upper ( parish ) = 'WATGANIA WEST' then '3775'
        when upper ( parish ) = 'WEERANGOURT' then '3786'
        when upper ( parish ) = 'WILLAM' then '3822'
        when upper ( parish ) = 'WING WING' then '3837'
        when upper ( parish ) = 'WOOHLPOOER' then '3876'
        when upper ( parish ) = 'WOOKURKOOK' then '3877'
        when upper ( parish ) = 'WYTWALLAN' then '3922'
        when upper ( parish ) = 'YALIMBA' then '3931'
        when upper ( parish ) = 'YALIMBA EAST' then '3932'
        when upper ( parish ) = 'YARRAMYLJUP' then '3964'
        when upper ( parish ) = 'YAT NAT' then '3976'
        when upper ( parish ) = 'YATCHAW EAST' then '3973'
        when upper ( parish ) = 'YATCHAW WEST' then '3974'
        when upper ( parish ) = 'YATMERONE' then '3975'
        when upper ( parish ) = 'YOUPAYANG' then '3998'
        when upper ( parish ) = 'YULECART' then '4001'
        when upper ( parish ) = 'YUPPECKIAR' then '4004'
        else ''
    end as parish_code,
    case upper ( township )
        when 'BALMORAL' then '5035'
        when 'BRANXHOLME' then '5105'
        when 'BYADUK NORTH' then '5141'
        when 'BYADUK' then '5140'
        when 'CARAPOOK' then '5152'
        when 'CAVENDISH' then '5165'
        when 'COLERAINE' then '5188'
        when 'DUNKELD' then '5256'
        when 'GLENTHOMPSON' then '5328'
        when 'HAMILTON' then '5364'
        when 'KARABEAL' then '5405'
        when 'PENSHURST' then '5629'
        when 'PIGEON PONDS' then '5635'
        when 'PURDEET' then '5657'
        when 'TARRAYOUKYAN' then '5768'
        when 'WANNON' then '5830'
        when 'WARRAYURE' then '5839'
        when 'YUPPECKIAR' then '5909'
        else ''
    end as township_code,
    ifnull ( legacyData1 , '' ) as summary,
    '362' as lga_code,
    '' as assnum
from
    councilwise_parcels
where
    parcelStatus = 1
)
)
)