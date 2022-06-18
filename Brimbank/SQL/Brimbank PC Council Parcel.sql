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
    case
        when auprparc.ttl_no1 like 'CM%' then 'NCPR'
        else cast ( auprparc.ass_num as varchar )
    end as propnum,
    case
        when auprparc.pcl_flg = 'R' then 'A'
        when auprparc.pcl_flg = 'P' then 'P'
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    ifnull ( auprparc.ttl_nme , '' ) as internal_spi,
    case
        when auprparc.ttl_cde in ( 2 , 4 , 6 , 8 , 12 , 14 ) then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde in ( 1 , 2 ) then 'TP'
        when auprparc.ttl_cde in ( 3 , 4 , 50 ) then 'PS'
        when auprparc.ttl_cde in ( 5 , 6 ) then 'LP'
        when auprparc.ttl_cde in ( 11 , 12 ) then 'PC'
        when auprparc.ttl_cde in ( 13 , 14 ) then 'RP'
        when auprparc.ttl_cde = 15 then 'SP'
        when auprparc.ttl_cde = 16 then 'CS'
        when auprparc.ttl_cde = 17 then 'CP'
        else ''
    end ||
        case
            when auprparc.ttl_cde in ( 7 , 8 , 9 , 10 ) then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde in ( 1 , 2 ) then 'TP'
        when auprparc.ttl_cde in ( 3 , 4 , 50 ) then 'PS'
        when auprparc.ttl_cde in ( 5 , 6 ) then 'LP'
        when auprparc.ttl_cde in ( 11 , 12 ) then 'PC'
        when auprparc.ttl_cde in ( 13 , 14 ) then 'RP'
        when auprparc.ttl_cde = 15 then 'SP'
        when auprparc.ttl_cde = 16 then 'CS'
        when auprparc.ttl_cde = 17 then 'CP'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 7 , 8 , 9 , 10 ) then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_no1 = '0' then ''
        when auprparc.ttl_cde not in ( 7 , 8 , 9 , 10 ) then ifnull ( trim ( replace ( auprparc.ttl_no1 , 'PT' , '' ) ) , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_no1 = '0' then ''
        when auprparc.ttl_cde in ( 7 , 8 , 9, 10 ) then ifnull ( trim ( replace ( auprparc.ttl_no1 , 'PT' , '' ) ) , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde in ( 7 , 8 , 9, 10 ) then ifnull ( trim ( auprparc.ttl_no3 ) , '' )
        else ''
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde in ( 7 , 8 , 9 , 10 ) then '2478'
        else ''
    end as parish_code,
    case
        when auprparc.ttl_no5 in ( '2478A' , '2478B' , '2478C' , '2478D' , '5106' , '5502' ) then auprparc.ttl_no5
        else ''
    end as township_code,
    auprparc.fmt_ttl as summary,
    '341' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num not in ( '' , '0' )
order by
    ass_num
)
)
)
