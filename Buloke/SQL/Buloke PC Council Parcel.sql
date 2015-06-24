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
    cast ( Parcel.PropertyNumber as varchar ) as propnum,
    '' as status,
    cast ( Parcel.LandParcelNumber as varchar ) as crefno,
    case
        when Parcel.StandardParcelId = '' then ''
        when Parcel.StandardParcelId like '%\%' then Parcel.StandardParcelId
        when Parcel.StandardParcelId like '%/%' then replace ( Parcel.StandardParcelId , '/' , '\' )
        when Parcel.StandardParcelId like '%CS%' then replace ( Parcel.StandardParcelId , 'CS' , '\CS' )
        when Parcel.StandardParcelId like '%LP%' then replace ( Parcel.StandardParcelId , 'LP' , '\LP' )
        when Parcel.StandardParcelId like '%RP%' then replace ( Parcel.StandardParcelId , 'RP' , '\RP' )
        when Parcel.StandardParcelId like '%PS%' then replace ( Parcel.StandardParcelId , 'PS' , '\PS' )
        when Parcel.StandardParcelId like '%SP%' then replace ( Parcel.StandardParcelId , 'SP' , '\SP' )
        when Parcel.StandardParcelId like '%TP%' then replace ( Parcel.StandardParcelId , 'TP' , '\TP' )
        when Parcel.StandardParcelId like '%PP%' then replace ( Parcel.StandardParcelId , 'PP' , '\PP' )
        when Parcel.StandardParcelId like '%CP%' then Parcel.StandardParcelId
        when Parcel.StandardParcelId like '%PC%' then Parcel.StandardParcelId
        else ''
    end as internal_spi,
    Property.Lot as summary,
    '' as part,
    case Parcel.Type
        when 'Lodged Plan' then 'LP'
        when 'Title Plan' then 'TP'
        when 'Plan of Subdivision' then 'PS'
        when 'Consolidation Plan' then 'CP'
        when 'Plan of Consolidation' then 'PC'
        when 'Strata Plan' then 'RP'
        when 'Stratum Plan' then 'SP'
        else ''
    end || case
            when ifnull ( Parcel.PlanNo , '' ) = '' then ''
            when substr ( Parcel.PlanNo , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then Parcel.PlanNo
            when substr ( Parcel.PlanNo , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( Parcel.PlanNo , 1 , length ( Parcel.PlanNo ) - 1 )
            else ''
        end as plan_number,
    case Parcel.Type
        when 'Lodged Plan' then 'LP'
        when 'Title Plan' then 'TP'
        when 'Plan of Subdivision' then 'PS'
        when 'Consolidation Plan' then 'CP'
        when 'Plan of Consolidation' then 'PC'
        when 'Strata Plan' then 'RP'
        when 'Stratum Plan' then 'SP'
        else ''
    end as plan_prefix,
    case
        when ifnull ( Parcel.PlanNo , '' ) = '' then ''
        when substr ( Parcel.PlanNo , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then Parcel.PlanNo
        when substr ( Parcel.PlanNo , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( Parcel.PlanNo , 1 , length ( Parcel.PlanNo ) - 1 )
        else ''
    end as plan_numeral,
    case
        when ifnull ( Parcel.PlanNo , '' ) = '' then ''
        else Parcel.Lot
    end as lot_number,
    Parcel.CrownAllotment as allotment,
    case
        when Parcel.Type = 'Crown Description' and ifnull ( Parcel.PlanNo , '' ) <> '' then ''
        else Parcel.Section
    end as sec,
    '' as block,
    Parcel.CrownPortion as portion,
    '' as subdivision,
    case upper ( Parcel.Parish )
        when 'BALLAPUR' then '2045'
        when 'BANGERANG' then '2062'
        when 'BANYENONG' then '2066'
        when 'BERRIWILLOCK' then '2128'
        when 'BEYAL' then '2138'
        when 'BIMBOURIE' then '2147'
        when 'BOIGBEAT' then '2167'
        when 'BOORONG' then '2195'
        when 'BOURKA' then '2213'
        when 'BUCKRABANYULE' then '2248'
        when 'BUNGULUKE' then '2285'
        when 'BURUPGA' then '2309'
        when 'CARAPUGNA' then '2341'
        when 'CARRON' then '2359'
        when 'CHARLTON EAST' then '2372'
        when 'CHARLTON WEST' then '2373'
        when 'CHINANGIN' then '2384'
        when 'COONOOER EAST' then '2438'
        when 'COONOOER WEST' then '2439'
        when 'COOROOPAJERRUP' then '2445'
        when 'CORACK' then '2447'
        when 'CORACK EAST' then '2448'
        when 'CURYO' then '2477'
        when 'DONALD' then '2532'
        when 'DOOBOOBETIC' then '2529'
        when 'GLENLOTH' then '2677'
        when 'JEFFCOTT' then '2789'
        when 'JERUK' then '2795'
        when 'JIL JIL' then '2797'
        when 'KALPIENUNG' then '2823'
        when 'KANEIRA' then '2829'
        when 'KARYRIE' then '2848'
        when 'KINNABULLA' then '2880'
        when 'LAEN' then '2954'
        when 'LALBERT' then '2957'
        when 'LIANIDUCK' then '2990'
        when 'MARLBED' then '3063'
        when 'MOAH' then '3130'
        when 'MOORTWORRA' then '3180'
        when 'MURNUNGIN' then '3229'
        when 'NARRAPORT' then '3276'
        when 'NARREWILLOCK' then '3280'
        when 'NINYEUNOOK' then '3314'
        when 'NULLAWIL' then '3334'
        when 'PERRIT PERRIT' then '3388'
        when 'PIER MILLAN' then '3394'
        when 'RICH AVON EAST' then '3450'
        when 'SWANWATER' then '3515'
        when 'TEDDYWADDY' then '3571'
        when 'TERRAPPEE' then '3577'
        when 'THALIA' then '3581'
        when 'TITTYBONG' then '3600'
        when 'TOORT' then '3635'
        when 'TOWANINNY' then '3641'
        when 'TOWMA' then '3643'
        when 'TUNGIE' then '3658'
        when 'TYENNA' then '3671'
        when 'TYRRELL' then '3678'
        when 'WANGIE' then '3728'
        when 'WARMUR' then '3742'
        when 'WATCHEM' then '3771'
        when 'WATCHUPGA' then '3772'
        when 'WHIRILY' then '3805'
        when 'WILKUR' then '3820'
        when 'WILLANGIE' then '3823'
        when 'WIRMBIRCHIP' then '3848'
        when 'WITCHIPOOL' then '3852'
        when 'WOOROONOOK' then '3892'
        when 'WOOSANG' then '3895'
        when 'WORTONGIE' then '3905'
        when 'WYCHEPROOF' then '3916'
        when 'YEUNGROON' then '3991'
        else ''
    end as parish_code,
    case upper ( Parcel.Township )
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
    '309' as lga_code
from
    lynx_vwlandparcel Parcel join
    lynx_propertys Property on Parcel.PropertyNumber = Property.Property
where
    Parcel.Status = 'Active' and
    Parcel.Ended is null and
    Property.Type not in ( 672 , 700 )
)
