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
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi
from
(
select
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case
        when auprparc.ttl_no1 like '%PT%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then
            case
                when auprparc.fmt_ttl like '%CP%' then 'CP'
                when auprparc.fmt_ttl like '%PC%' then 'PC'
                else ''
            end
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 5 then 'CS'
        when auprparc.ttl_cde = 6 then 'TP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 8 then 'SP'
        when auprparc.ttl_cde = 9 then ''
    end ||
        case
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then
            case
                when auprparc.fmt_ttl like '%CP%' then 'CP'
                when auprparc.fmt_ttl like '%PC%' then 'PC'
                else ''
            end
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 5 then 'CS'
        when auprparc.ttl_cde = 6 then 'TP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 8 then 'SP'
        when auprparc.ttl_cde = 9 then ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde = 9 then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end as plan_numeral,
    case when auprparc.ttl_cde <> 9 then ifnull ( replace ( replace ( replace ( upper ( ttl_no1 ) , '.' , '' ) , 'PT' , '' ) , ' ' , '' ) , '' ) else '' end as lot_number,
    case when auprparc.ttl_cde = 9 then ifnull ( replace ( replace ( replace ( upper ( ttl_no1 ) , '.' , '' ) , 'PT' , '' ) , ' ' , '' ) , '' ) else '' end as allotment,
    ifnull ( ttl_no3 , '' ) as sec,
    '' as block,
    case when length ( auprparc.ttl_no4 ) < 4 and auprparc.ttl_no4 <> '\' then ifnull ( auprparc.ttl_no4 , '' ) else '' end as portion,
    '' as subdivision,
    case when auprparc.ttl_cde = 9 then ifnull ( auprparc.udn_cd1 , '' ) else '' end as parish_code,
    '' as township_code,
    fmt_ttl as summary,
    '314' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num not in ( '' , '0' ) and
    auprparc.ttl_cde <> 99
)
)