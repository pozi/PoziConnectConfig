select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi,
    case
        when plan_numeral <> '' and lot_number = '' then plan_numeral
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_numeral
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
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
    '' as summary,
    '' as part,
    case Parcel.Type    
        when 'Lodged Plan' then 'LP' || Parcel.PlanNo
        when 'Title Plan' then 'TP' || Parcel.PlanNo
        when 'Plan of Subdivision' then 'PS' || Parcel.PlanNo
        when 'Consolidation Plan' then 'PC' || Parcel.PlanNo
        when 'Stratum Plan' then 'SP' || Parcel.PlanNo
        else ''
    end as plan_number,
    case Parcel.Type    
        when 'Lodged Plan' then 'LP'
        when 'Title Plan' then 'TP'
        when 'Plan of Subdivision' then 'PS'
        when 'Consolidation Plan' then 'PC'
        when 'Stratum Plan' then 'SP'
        else ''
    end as plan_prefix,
    Parcel.PlanNo as plan_numeral,
    Parcel.Lot as lot_number,
    Parcel.CrownAllotment as allotment,
    Parcel.Section as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case upper ( Parcel.Parish )
        when 'ADJIE' then '2003'
        when 'BEETHANG' then '2103'
        when 'BENAMBRA' then '2114'
        when 'BERRINGA' then '2126'
        when 'BERRINGAMA' then '2127'
        when 'BOGONG NORTH' then '2164'
        when 'BOGONG SOUTH' then '2165'
        when 'BOLGA' then '2173'
        when 'BONEGILLA' then '2178'
        when 'BOORGUNYAH' then '2191'
        when 'BULLIOH' then '2266'
        when 'BUNGIL' then '2283'
        when 'BUNGIL EAST' then '2284'
        when 'BURROWYE' then '2303'
        when 'BURRUNGABUGGE' then '2307'
        when 'CANABORE' then '2327'
        when 'COLAC COLAC' then '2406'
        when 'CORRYONG' then '2457'
        when 'CUDGEWA' then '2471'
        when 'DARTELLA' then '2500'
        when 'DORCHAP' then '2539'
        when 'GIBBO' then '2652'
        when 'GRANYA' then '2720'
        when 'GUNDOWRING' then '2734'
        when 'GUNGARLAN' then '2735'
        when 'INDI' then '2772'
        when 'JEMBA' then '2791'
        when 'JINJELLIC' then '2803'
        when 'KANCOBIN' then '2828'
        when 'KEELANGIE' then '2855'
        when 'KOETONG' then '2895'
        when 'KOSCIUSKO' then '2931'
        when 'MAGORRA' then '3033'
        when 'MALKARA' then '3043'
        when 'MITTA MITTA' then '3127'
        when 'MOWAMBA' then '3203'
        when 'MOYANGUL' then '3204'
        when 'MULLAGONG' then '3213'
        when 'NARIEL' then '3266'
        when 'NOORONGONG' then '3322'
        when 'PINNIBAR' then '3399'
        when 'TALGARNO' then '3524'
        when 'TALLANDOON' then '3527'
        when 'TANGAMBALANGA' then '3541'
        when 'TATONGA' then '3566'
        when 'THOLOGOLONG' then '3584'
        when 'THOWGLA' then '3588'
        when 'TINTALDRA' then '3599'
        when 'TONGARO' then '3603'
        when 'TOWONG' then '3644'
        when 'UNDOWAH' then '3683'
        when 'WABBA' then '3691'
        when 'WAGRA' then '3698'
        when 'WALLABY' then '3704'
        when 'WALWA' then '3717'
        when 'WELUMLA' then '3791'
        when 'WERMATONG' then '3795'
        when 'WOLLONABY' then '3856'
        when 'WYEEBOO' then '3918'
        when 'YABBA' then '3927'
        else ''
    end as parish_code,
    case upper ( Parcel.Township )
        when 'TOWONG' then '5799'
        when 'NARIEL' then '5575'
        when 'CORRYONG' then '5200'
        when 'DARTMOUTH' then '5230'
        when 'BEETOOMBA' then '5063'
        when 'CRAVENSVILLE' then '5208'
        when 'BERRINGAMA' then '5074'
        when 'GRANITE FLAT' then '5345'
        when 'MITTA MITTA' then '5539'
        when 'KOETONG' then '5425'
        when 'TALLANGATTA VALLEY' then '5758'
        when 'ESKDALE' then '5285'
        when 'GRANYA' then '5349'
        when 'TALLANGATTA' then '5757'
        when 'TATONGA' then '5772'
        when 'BETHANGA' then '5079'
        else ''
    end as township_code,
    '367' as lga_code
from
    lynx_vwlandparcel Parcel
where
    Parcel.Status = 'Active' and
    Parcel.Ended is null
)

