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
    ifnull ( Property.Lot , '' ) as summary,
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
        else upper ( replace ( Parcel.Lot , ' ' , '' ) )
    end as lot_number,
    Parcel.CrownAllotment as allotment,
    case
        when Parcel.Section = 'NO' then ''
        when Parcel.Type = 'Crown Description' and ifnull ( Parcel.PlanNo , '' ) <> '' then ''
        when ifnull ( Parcel.PlanNo , '' ) <> '' and Parcel.CrownAllotment <> '' then ''
        else Parcel.Section
    end as sec,
    '' as block,
    Parcel.CrownPortion as portion,
    '' as subdivision,
    case upper ( Parcel.Parish )
        when 'BALLARAT' then '2046'
        when 'BALLARK' then '2047'
        when 'BALLIANG' then '2049'
        when 'BEREMBOKE' then '2123'
        when 'BLACKWOOD' then '2160'
        when 'BORHONEYGHURK' then '2206'
        when 'BULLARTO' then '2262'
        when 'BUNGAL' then '2275'
        when 'BUNGAREE' then '2279'
        when 'BUNGEELTAP' then '2281'
        when 'BUNINYONG' then '2287'
        when 'CARGERIE' then '2345'
        when 'CLARENDON' then '2387'
        when 'COIMADAI' then '2404'
        when 'DEAN' then '2503'
        when 'DJERRIWARRH' then '2528'
        when 'GORONG' then '2709'
        when 'GORROCKBURKGHAP' then '2711'
        when 'KERRIT BAREET' then '2867'
        when 'KORKUPERRIMUL' then '2922'
        when 'KORWEINGUBOORA' then '2930'
        when 'LAL LAL' then '2959'
        when 'MEREDITH' then '3090'
        when 'MERRIMU' then '3095'
        when 'MOORADORANOOK' then '3164'
        when 'MOORARBOOL EAST' then '3166'
        when 'MOORARBOOL WEST' then '3167'
        when 'MOUYONG' then '3201'
        when 'MYRNIONG' then '3247'
        when 'NARMBOOL' then '3271'
        when 'PARWAN' then '3375'
        when 'TRENTHAM' then '3649'
        when 'WARRENHEIP' then '3760'
        when 'WOODEND' then '3872'
        when 'YALOAK' then '3939'
        else ''
    end as parish_code,
    case upper ( Parcel.Township )
        when 'BACCHUS MARSH' then '5025'
        when 'BALLAN' then '5029'
        when 'BALLIANG' then '5033'
        when 'BARKSTEAD' then '5044'
        when 'BARRYS REEF' then '5050'
        when 'BLACKWOOD' then '5087'
        when 'BLAKEVILLE' then '5088'
        when 'BUNINYONG' then '5134'
        when 'CARGERIE' then '5153'
        when 'CLARENDON' then '5175'
        when 'EGERTON' then '5268'
        when 'ELAINE' then '5270'
        when 'ELAINE NORTH' then '5271'
        when 'GORDON' then '5337'
        when 'GREENDALE' then '5352'
        when 'LAL LAL' then '5448'
        when 'MORRISONS' then '5552'
        when 'MORRISONS (Township)' then '5552'
        when 'MYRNIONG' then '5567'
        when 'ROWSLEY' then '5685'
        when 'WALLACE' then '5821'
        when 'WARRENHEIP' then '5840'
        when 'YENDON' then '5907'
        else ''
    end as township_code,
    '350' as lga_code,
    cast ( Parcel.PropertyNumber as varchar ) as assnum
from
    lynx_vwlandparcel Parcel join
    lynx_propertys Property on Parcel.PropertyNumber = Property.Property
where
    Parcel.Status = 'Active' and
    Parcel.Ended is null and
    Property.Type not in ( 672 )
)
)
)
