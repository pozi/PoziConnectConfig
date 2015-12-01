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
    '' as crefno,
    '' as summary,
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
            when Parcel.Type = 'Crown Description' then ''
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
        when Parcel.Type = 'Crown Description' then ''
        when substr ( Parcel.PlanNo , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then Parcel.PlanNo
        when substr ( Parcel.PlanNo , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( Parcel.PlanNo , 1 , length ( Parcel.PlanNo ) - 1 )
        else ''
    end as plan_numeral,
    case
        when Parcel.Type = 'Crown Description' then ''
        else Parcel.Lot
    end as lot_number,
    case
        when Parcel.Type = 'Crown Description' then Parcel.CrownAllotment
        else ''
    end as allotment,
    case
        when Parcel.Type in ( 'Title Plan' , 'Plan of Subdivision' , 'Consolidation Plan' , 'Plan of Consolidation' , 'Strata Plan' , 'Stratum Plan' ) then ''
        when upper ( Parcel.Section ) in ( 'NO' , 'NO SEC' , 'NO SECTION' ) then ''
        else Parcel.Section
    end as sec,
    '' as block,
    case
        when Parcel.Type = 'Crown Description' then Parcel.CrownPortion
        else ''
    end as portion,
    '' as subdivision,
    case upper ( Parcel.Parish )
        when 'BARRAKEE' then '2081'
        when 'BEALIBA' then '2095'
        when 'BERRIMAL' then '2125'
        when 'BOORT' then '2200'
        when 'BORUNG' then '2211'
        when 'BRADFORD' then '2216'
        when 'BRENANAH' then '2223'
        when 'BRIDGEWATER' then '2226'
        when 'BUCKRABANYULE' then '2248'
        when 'CALIVIL' then '2320'
        when 'COONOOER EAST' then '2438'
        when 'DERBY' then '2510'
        when 'DINGEE' then '2526'
        when 'DUNOLLY' then '2567'
        when 'EDDINGTON' then '2574'
        when 'GLENALBYN' then '2664'
        when 'GLENLOTH' then '2677'
        when 'GOWAR' then '2715'
        when 'GREDGWIN' then '2722'
        when 'GUNBOWER WEST' then '2733'
        when 'HAYANMI' then '2748'
        when 'INGLEWOOD' then '2774'
        when 'JANIEMBER EAST' then '2782'
        when 'JANIEMBER WEST' then '2783'
        when 'JARKLAN' then '2785'
        when 'JERUK' then '2795'
        when 'KAMAROOKA' then '2825'
        when 'KANGDERAAR' then '2830'
        when 'KINGOWER' then '2882'
        when 'KINYPANIAL' then '2885'
        when 'KOOREH' then '2913'
        when 'KOOROC' then '2915'
        when 'KORONG' then '2926'
        when 'KURRACA' then '2945'
        when 'KURTING' then '2946'
        when 'LAANECOORIE' then '2951'
        when 'LEAGHUR' then '2983'
        when 'LEICHARDT' then '2986'
        when 'LODDON' then '3007'
        when 'MACORNA' then '3028'
        when 'MARMAL' then '3066'
        when 'MARONG' then '3068'
        when 'MEERING' then '3080'
        when 'MEERING WEST' then '3081'
        when 'MILLOO' then '3104'
        when 'MINCHA' then '3107'
        when 'MINCHA WEST' then '3108'
        when 'MITIAMO' then '3126'
        when 'MOLIAGUL' then '3143'
        when 'MOLOGA' then '3145'
        when 'MYSIA' then '3250'
        when 'NEEREMAN' then '3291'
        when 'NEILBOROUGH' then '3294'
        when 'NERRING' then '3301'
        when 'PAINSWICK' then '3362'
        when 'PATHO' then '3378'
        when 'POMPAPIEL' then '3407'
        when 'POWLETT' then '3415'
        when 'QUAMBATOOK' then '3433'
        when 'SALISBURY' then '3469'
        when 'SALISBURY WEST' then '3470'
        when 'SHELBOURNE' then '3483'
        when 'TALAMBE' then '3523'
        when 'TANDARRA' then '3540'
        when 'TARNAGULLA' then '3551'
        when 'TCHUTERR' then '3570'
        when 'TERRAPPEE' then '3577'
        when 'TERRICK TERRICK EAST' then '3578'
        when 'TERRICK TERRICK WEST' then '3579'
        when 'TRAGOWEL' then '3646'
        when 'WAANYARRA' then '3689'
        when 'WEDDERBURNE' then '3782'
        when 'WEHLA' then '3788'
        when 'WHIRRAKEE' then '3806'
        when 'WOODSTOCK' then '3875'
        when 'WOOSANG' then '3895'
        when 'WYCHITELLA' then '3917'
        when 'YALLOOK' then '3936'
        when 'YARRABERB' then '3961'
        when 'YARRAYNE' then '3968'
        when 'YARROWALLA' then '3970'
        when 'YEUNGROON' then '3991'
        else ''
    end as parish_code,
    case upper ( Parcel.Township )
        when 'ARNOLD' then '5019'
        when 'BARRAPOORT' then '5048'
        when 'BEARS LAGOON' then '5057'
        when 'BOCCA FLAT' then '5089'
        when 'BOORT' then '5102'
        when 'BORUNG' then '5103'
        when 'BRIDGEWATER' then '5109'
        when 'BURKES FLAT' then '5136'
        when 'COONOOER' then '5192'
        when 'DURHAM OX' then '5260'
        when 'EDDINGTON' then '5265'
        when 'FERNIHURST' then '5291'
        when 'GOWAR EAST' then '5343'
        when 'INGLEWOOD' then '5391'
        when 'KINGOWER' then '5423'
        when 'KOOYOORA' then '5431'
        when 'KORONG VALE' then '5433'
        when 'KURRACA' then '5437'
        when 'LAANECOORIE' then '5440'
        when 'LEICHARDT' then '5458'
        when 'LLANELLY' then '5470'
        when 'MOLIAGUL' then '5544'
        when 'NEWBRIDGE' then '5588'
        when 'PYRAMID HILL' then '5659'
        when 'RHEOLA' then '5673'
        when 'SERPENTINE' then '5708'
        when 'TARNAGULLA' then '5765'
        when 'TERRICK TERRICK SOUTH' then '5780'
        when 'TERRICK TERRICK' then '5779'
        when 'WAANYARRA' then '5817'
        when 'WEDDERBURN' then '5845'
        when 'WEHLA' then '5846'
        else ''
    end as township_code,
    '338' as lga_code
from
    lynx_vwlandparcel Parcel
where
    Parcel.Status = 'Active' and
    Parcel.Ended is null and
    Parcel.TypeID in ( 750 , 751 , 755 , 756 , 757 , 758 , 759 )
)

