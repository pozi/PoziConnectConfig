select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
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
    end as spi
from
(
select
    case propid
        when 10978 then 'NCPR'
        when 10986 then 'NCPR'
        else cast ( propid as varchar )
    end as propnum,
    case status
        when 'C' then 'A'
        when 'F' then 'P'
    end as status,
    cast ( landid as varchar ) as crefno,
    notes as summary,
    spi as internal_spi,
    case pca
        when '' then ''
        else 'P'
    end as part,
    plantype || plannumber as plan_number,
    plantype as plan_prefix,
    plannumber as plan_numeral,
    lot as lot_number,
    ca as allotment,
    section as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    parish as parish_code,
    township as township_code,
    '353' as lga_code,
    cast ( propid as varchar ) as assnum
from
    techone_parcel
)
)