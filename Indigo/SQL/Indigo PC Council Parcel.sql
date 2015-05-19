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
    '' as summary,
    '' as part,
    case Parcel.Type
        when 'Lodged Plan' then 'LP' || Parcel.PlanNo
        when 'Title Plan' then 'TP' || Parcel.PlanNo
        when 'Plan of Subdivision' then 'PS' || Parcel.PlanNo
        when 'Consolidation Plan' then 'PC' || Parcel.PlanNo
        when 'Strata Plan' then 'RP' || Parcel.PlanNo
        when 'Stratum Plan' then 'SP' || Parcel.PlanNo
        else ''
    end as plan_number,
    case Parcel.Type
        when 'Lodged Plan' then 'LP'
        when 'Title Plan' then 'TP'
        when 'Plan of Subdivision' then 'PS'
        when 'Consolidation Plan' then 'PC'
        when 'Strata Plan' then 'RP'
        when 'Stratum Plan' then 'SP'
        else ''
    end as plan_prefix,
    Parcel.PlanNo as plan_numeral,
    case
        when Parcel.Lot = 'CROWN LAND' then ''
        when Parcel.Lot glob '?(*' then substr ( Parcel.Lot , 1 , 1 )
        when Parcel.Lot glob '??(*' then substr ( Parcel.Lot , 1 , 2 )
        else Parcel.Lot
    end as lot_number,
    Parcel.CrownAllotment as allotment,
    case
        when Parcel.Section in ( 'NO' , 'NO SEC' ) then ''
        else Parcel.Section
    end as sec,
    case when Lot like '%(BLK%)' then substr ( Lot , length ( Lot ) - 1 , 1 ) else '' end as block,
    '' as portion,
    '' as subdivision,
    case upper ( Parcel.Parish )
        when 'BARAMBOGIE' then '2067'
        when 'BARANDUDA' then '2068'
        when 'BARNAWARTHA NORTH' then '2076'
        when 'BARNAWARTHA SOUTH' then '2077'
        when 'BEECHWORTH' then '2099'
        when 'BEETHANG' then '2103'
        when 'BELVOIR WEST' then '2110'
        when 'BERRINGA' then '2126'
        when 'BOLGA' then '2173'
        when 'BONTHERAMBO' then '2180'
        when 'BOORHAMAN' then '2192'
        when 'BRIMIN' then '2231'
        when 'BRUARONG' then '2239'
        when 'BUNDALONG' then '2272'
        when 'BYAWATHA' then '2316'
        when 'CARLYLE' then '2349'
        when 'CHILTERN' then '2381'
        when 'CHILTERN WEST' then '2382'
        when 'EL DORADO' then '2582'
        when 'ELDORADO' then '2582'
        when 'EVERTON' then '2610'
        when 'GOORAMADDA' then '2703'
        when 'GUNDOWRING' then '2734'
        when 'KERGUNYAH' then '2863'
        when 'KERGUNYAH NORTH' then '2864'
        when 'LILLIPUT' then '2996'
        when 'MUDGEEGONGA' then '3210'
        when 'MURMUNGEE' then '3227'
        when 'MURRAMURRANGBONG' then '3232'
        when 'NOORONGONG' then '3322'
        when 'NORONG' then '3323'
        when 'STANLEY' then '3498'
        when 'TALLANDOON' then '3527'
        when 'TANGAMBALANGA' then '3541'
        when 'TANGAMABLANGA' then '3541'
        when 'WOORRAGEE' then '3893'
        when 'WOORAGEE' then '3893'
        when 'WOORRAGEE NORTH' then '3894'
        when 'WOORAGEE NOERH' then '3894'
        when 'YACKANDANDAH' then '3929'
        else ''
    end as parish_code,
    case upper ( Parcel.Township )
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
    '334' as lga_code
from
    lynx_vwlandparcel Parcel
where
    Parcel.Status = 'Active' and
    Parcel.Ended is null
)

