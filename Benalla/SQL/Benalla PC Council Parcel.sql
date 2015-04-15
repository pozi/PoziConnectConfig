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
select distinct
    assess as propnum,
    '' as status,
    dola_pin as crefno,
    case
        when [pt_lot/ca] like 'P%T%' then 'P'
        else ''
    end as part,
    '' as summary,
    case
        when plan_number = 'PP' then ''
        else replace ( plan_number , ' ' , '' ) 
    end as plan_number,
    case
        when plan_number = 'PP' then ''
        else substr ( plan_number , 1 , 2 ) 
    end as plan_prefix,
    case
        when plan_number = 'PP' then ''
        else substr ( plan_number , 4 , 99 ) 
    end as plan_numeral,
    case
        when plan_number = 'PP' then ''
        else [lot/ca_no]
    end as lot_number,
    case
        when plan_number = 'PP' then [lot/ca_no]
        else ''
    end as allotment,
    [section] as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when plan_number = 'PP' and parish not like 'T/SHIP%' then parish
        else ''
    end as parish_code,
    case
        when plan_number = 'PP' and parish like 'T/SHIP%' then parish
        else ''
    end as township_code,
    '381' as lga_code,
    assess as assnum
from
    synergysoft
where
    curr_assess <> 'X' and
    type not in ( 'D' , 'Z' )
)