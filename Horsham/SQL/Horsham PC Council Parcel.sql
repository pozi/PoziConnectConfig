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
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
    end as status,
    '' as crefno,
    case
        when auprparc.ttl_no1 like '%PT%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 5 then 'CS'
        when auprparc.ttl_cde = 6 then 'TP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 8 then 'SP'
        when auprparc.ttl_cde = 9 then ''
        when auprparc.ttl_cde = 10 then 'PS'
    end ||
        replace ( replace ( case
            when auprparc.ttl_no5 like '%/%' then substr ( replace ( auprparc.ttl_no5 , 'P' , '' ) , 1 , 6 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end , 'p' , '' ) , 'P' , '' ) as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 5 then 'CS'
        when auprparc.ttl_cde = 6 then 'TP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 8 then 'SP'
        when auprparc.ttl_cde = 9 then ''
        when auprparc.ttl_cde = 10 then 'PS'
    end as plan_prefix,
    replace ( replace ( case
        when auprparc.ttl_cde = 9 then ''
        when auprparc.ttl_no5 like '%/%' then substr ( replace ( auprparc.ttl_no5 , 'P' , '' ) , 1 , 6 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end , 'p' , '' ) , 'P' , '' ) as plan_numeral,
    case
        when auprparc.ttl_cde = 10 and ttl_no1 not like '%RES%' then 'RES' || ifnull ( upper ( ttl_no1 ) , '' )
        when auprparc.ttl_cde <> 9 then ifnull ( upper ( ttl_no1 ) , '' )
        else '' 
    end as lot_number,
    case when auprparc.ttl_cde = 9 then ifnull ( upper ( ttl_no1 ) , '' ) else '' end as allotment,
    ifnull ( ttl_no3 , '' ) as sec,
    ifnull ( ttl_no4 , '' ) as block,
    '' as portion,
    '' as subdivision,
    ifnull ( auprparc.udn_cd1 , '' ) as parish_code,
    ifnull ( replace ( auprparc.udn_cd2 , '9999' , '' ) , '' ) as township_code,
    fmt_ttl as summary,
    '332' as lga_code
from
    authority_auprparc as auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ttl_cde not in ( 11 , 12 , 13 , 14 , 99 ) and    
    aurtmast.rte_zne <> 'LS'
)