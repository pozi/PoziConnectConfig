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
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    ifnull ( auprparc.ttl_nme , '' ) as internal_spi,
    case
        when auprparc.ttl_no1 like '%PT%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 3 then 'TP'
        when auprparc.ttl_cde = 4 then ''
        when auprparc.ttl_cde = 5 then 'LP'
        when auprparc.ttl_cde = 6 then 'RP'
        when auprparc.ttl_cde = 7 then 'TP'
        when auprparc.ttl_cde = 8 then 'CP'
        when auprparc.ttl_cde = 10 then 'PC'
        when auprparc.ttl_cde = 99 then 'SP'
    end ||
        case
            when auprparc.ttl_cde in ( 4, 11, 12, 13, 14 ) then ''
            else ifnull ( cast ( auprparc.ttl_in5 as varchar ) , '' )
        end as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 3 then 'TP'
        when auprparc.ttl_cde in ( 4, 11, 12, 13, 14 ) then ''
        when auprparc.ttl_cde = 5 then 'LP'
        when auprparc.ttl_cde = 6 then 'RP'
        when auprparc.ttl_cde = 7 then 'TP'
        when auprparc.ttl_cde = 8 then 'CP'
        when auprparc.ttl_cde = 10 then 'PC'
        when auprparc.ttl_cde = 99 then 'SP'
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 4, 11, 12, 13, 14 ) then ''
        else ifnull ( cast ( auprparc.ttl_in5 as varchar ) , '' )
    end as plan_numeral,
    case when auprparc.ttl_cde not in ( 4, 11, 12, 13, 14 ) then ifnull ( upper ( ttl_no1 ) , '' ) else '' end as lot_number,
    case when auprparc.ttl_cde in ( 4, 11, 12, 13, 14 ) then ifnull ( upper ( ttl_no1 ) , '' ) else '' end as allotment,
    ifnull ( ttl_no3 , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    '' as parish_code,
    '' as township_code,
    fmt_ttl as summary,
    '338' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num
where
    auprparc.pcl_flg in ( 'M' , 'R' , 'P' ) and
    auprparc.ttl_cde not in ( 13 )
)
)
)
