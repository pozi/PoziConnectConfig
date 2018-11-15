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
select distinct
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    ttl_nme as internal_spi,
    case
        when auprparc.ttl_cde in ( 10 , 19 , 20 ) then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde not in ( 9 , 10 , 27 , 28 ) then
            case
                when auprparc.ttl_cde in ( 1 , 2 , 13 , 18 , 20 , 24 , 25 , 26 ) then 'PS'
                when auprparc.ttl_cde in ( 3 , 4 , 19 , 21 ) then 'LP'
                when auprparc.ttl_cde = 5 then 'TP'
                when auprparc.ttl_cde = 6 then 'PC'
                when auprparc.ttl_cde = 7 then 'CP'
                when auprparc.ttl_cde in ( 8 , 30 ) then 'RP'
                when auprparc.ttl_cde in ( 11 , 23 ) then 'SP'
                when auprparc.ttl_cde = 22 then 'CS'
                else ''
            end ||
                case
                    when null then ''
                    when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( cast ( auprparc.ttl_no5 as integer ) as varchar )
                    when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( cast ( auprparc.ttl_no5 as varchar ) , 1 , length ( cast ( auprparc.ttl_no5 as varchar ) ) - 1 )
                    else ''
                end
        else ''
    end as plan_number,
    case
        when auprparc.ttl_cde in ( 1 , 2 , 13 , 18 , 20 , 24 , 25 , 26 ) then 'PS'
        when auprparc.ttl_cde in ( 3 , 4 , 19 , 21 ) then 'LP'
        when auprparc.ttl_cde = 5 then 'TP'
        when auprparc.ttl_cde = 6 then 'PC'
        when auprparc.ttl_cde = 7 then 'CP'
        when auprparc.ttl_cde in ( 8 , 30 ) then 'RP'
        when auprparc.ttl_cde in ( 11 , 23 ) then 'SP'
        when auprparc.ttl_cde = 22 then 'CS'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde not in ( 9 , 10 , 27 , 28 ) then
            case
                when null then ''
                when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( cast ( auprparc.ttl_no5 as integer ) as varchar )
                when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( cast ( auprparc.ttl_no5 as varchar ) , 1 , length ( cast ( auprparc.ttl_no5 as varchar ) ) - 1 )
                else ''
            end
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde in ( 9 , 10 , 27 , 28 ) then ''
        when auprparc.ttl_cde = 18 then 'RES' || ifnull ( auprparc.ttl_no2 , '' )
        when auprparc.ttl_cde = 24 then 'CM1'
        when auprparc.ttl_cde = 25 then 'CM2'
        when auprparc.ttl_cde = 26 then 'CM3'
        else ifnull ( auprparc.ttl_no1 , '' )
    end as lot_number,
    case
        when auprparc.ttl_cde in ( 9 , 10 , 27 , 28 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as allotment,
    replace (
        replace (
            replace (
                case
                    when auprparc.ttl_cde in ( 9 , 10 , 27 , 28 ) then ifnull ( auprparc.ttl_no5 , '' )
                    when auprparc.ttl_cde = 4 then ifnull ( auprparc.ttl_no3 , '' )
                    else ''
                end ,
            '*' , '' ) ,
        '.' , '' ) ,
    '0' , '' ) as sec,
    case
        when auprparc.ttl_cde = 21 then ifnull ( auprparc.ttl_no4 , '' )
        else ''
    end as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde not in ( 9 , 10 , 27 , 28 ) then ''
        else cast ( auprparc.udn_cd1 as varchar )
    end as parish_code,
    case
        when auprparc.ttl_cde not in ( 9 , 10 , 27 , 28 ) then ''
        when auprparc.udn_cd3 = 6000 then ''
        else cast ( auprparc.udn_cd3 as varchar )
    end as township_code,
    fmt_ttl as summary,
    '366' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num is not null and
    auprparc.ttl_cde not in ( 12 , 13 , 14 , 15 , 16 , 17 )
order by
    ass_num
)
)
