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
    cast ( propnum as varchar ) as propnum,
    status as status,
    cast ( crefno as varchar ) as crefno,
    spi as internal_spi,
    summary,
    part,
    plan_number,
    plan_prefix,
    plan_numeral,
    lot_number,
    allotment,
    sec,
    block,
    portion,
    subdivision,
    case upper ( parish_code )
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
    case upper ( township_code )
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
    cast ( propnum as varchar ) as assnum
from
    datascape_parcels
)
)
)
