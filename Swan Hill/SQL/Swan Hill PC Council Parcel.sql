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
select distinct
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case
        when auprparc.ttl_cde in ( 10 , 19 , 20 ) then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde not in ( 9 , 10 , 27 , 28 ) then
            case
                when auprparc.ttl_cde in ( 1 , 2 , 13 , 18 , 19 , 20 , 21 ) then 'PS'
                when auprparc.ttl_cde in ( 3 , 4 ) then 'LP'
                when auprparc.ttl_cde in ( 5 , 12 ) then 'TP'
                when auprparc.ttl_cde = 6 then 'PC'
                when auprparc.ttl_cde = 7 then 'CP'
                when auprparc.ttl_cde = 8 then 'RP'
                when auprparc.ttl_cde = 11 then 'SP'
                when auprparc.ttl_cde = 22 then 'CS'
                else ''
            end ||
                case
                    when null then ''
                    when substr ( cast ( auprparc.ttl_in5 as varchar ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( auprparc.ttl_in5 as varchar )
                    when substr ( cast ( auprparc.ttl_in5 as varchar ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( cast ( auprparc.ttl_in5 as varchar ) , 1 , length ( cast ( auprparc.ttl_in5 as varchar ) ) - 1 )        
                    else ''
                end
        else ''
    end as plan_number,
    case
        when auprparc.ttl_cde in ( 1 , 2 , 13 , 18 , 19 , 20 , 21 ) then 'PS'
        when auprparc.ttl_cde in ( 3 , 4 ) then 'LP'
        when auprparc.ttl_cde in ( 5 , 12 ) then 'TP'
        when auprparc.ttl_cde = 6 then 'PC'
        when auprparc.ttl_cde = 7 then 'CP'
        when auprparc.ttl_cde = 8 then 'RP'
        when auprparc.ttl_cde = 11 then 'SP'
        when auprparc.ttl_cde = 22 then 'CS'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde not in ( 9 , 10 , 27 , 28 ) then
            case    
                when null then ''
                when substr ( cast ( auprparc.ttl_in5 as varchar ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( auprparc.ttl_in5 as varchar )
                when substr ( cast ( auprparc.ttl_in5 as varchar ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( cast ( auprparc.ttl_in5 as varchar ) , 1 , length ( cast ( auprparc.ttl_in5 as varchar ) ) - 1 )        
                else ''
            end
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde not in ( 9 , 10 , 27 , 28 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_cde in ( 9 , 10 , 27 , 28 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde in ( 9 , 10 , 27 , 28 ) then ifnull ( auprparc.ttl_no5 , '' )
        else ifnull ( auprparc.ttl_no3 , '' )
    end as sec,
    cast ( auprparc.udn_cd1 as varchar ) as parish_code,
    case
        when auprparc.udn_cd3 = 6000 then ''
        else cast ( auprparc.udn_cd3 as varchar )
    end as township_code,
    fmt_ttl as summary,
    '366' as lga_code
from
    authority_auprparc auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num is not null
order by
    ass_num
)