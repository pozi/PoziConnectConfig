select
    *,
    case
        when internal_spi <> '' and internal_spi not like '\%' then internal_spi
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
        when internal_spi <> '' and internal_spi not like '\%' then replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( internal_spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' )
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
    end as simple_spi,
    case
        when internal_spi <> '' and internal_spi not like '% %' then 'council_spi'
        else 'council_attributes'
    end as source
from
(
select
    cast ( Parcel.PropertyNumber as varchar ) as propnum,
    '' as status,
    '' as crefno,
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
    case
        when Parcel.TypeAbrev = 'CrD' or Parcel.PlanNo = '' then ''
        when Parcel.TypeAbrev in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then Parcel.TypeAbrev
        else
            case
                when Property.Lot like '%CP%' then 'CP'
                when Property.Lot like '%CS%' then 'CS'
                when Property.Lot like '%LP%' then 'LP'
                when Property.Lot like '%PC%' then 'PC'
                when Property.Lot like '%PS%' then 'PS'
                when Property.Lot like '%RP%' then 'RP'
                when Property.Lot like '%SP%' then 'SP'
                when Property.Lot like '%TP%' then 'TP'
                else ''
            end
    end ||
    case
        when substr ( Parcel.PlanNo , -1 , 1 ) in ( '0','1','2','3','4','5','6','7','8','9' ) then Parcel.PlanNo
        else substr ( Parcel.PlanNo , 1 , length ( Parcel.PlanNo ) - 1 )
    end as plan_number,
    case
        when Parcel.TypeAbrev = 'CrD' then ''
        when Parcel.TypeAbrev in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then Parcel.TypeAbrev
        else
            case
                when Property.Lot like '%CP%' then 'CP'
                when Property.Lot like '%CS%' then 'CS'
                when Property.Lot like '%LP%' then 'LP'
                when Property.Lot like '%PC%' then 'PC'
                when Property.Lot like '%PS%' then 'PS'
                when Property.Lot like '%RP%' then 'RP'
                when Property.Lot like '%SP%' then 'SP'
                when Property.Lot like '%TP%' then 'TP'
                else ''
            end
    end as plan_prefix,
    case
        when Parcel.PlanNo = '' then ''
        when substr ( Parcel.PlanNo , 1 , 2 ) in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then substr ( Parcel.PlanNo , 3 , 99 )
        when substr ( Parcel.PlanNo , -1 , 1 ) in ( '0','1','2','3','4','5','6','7','8','9' ) then Parcel.PlanNo
        else substr ( Parcel.PlanNo , 1 , length ( Parcel.PlanNo ) - 1 )
    end as plan_numeral,
    Parcel.Lot as lot_number,
    Parcel.CrownAllotment as allotment,
    Parcel.Section as sec,
    '' as block,
    Parcel.CrownPortion as portion,
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
    lynx_vwlandparcel Parcel join
    lynx_propertys Property on Parcel.PropertyNumber = Property.Property
where
    Parcel.Status = 'Active' and
    Parcel.Ended is null and
    Property.Type not in ( 672 , 700 )
)

