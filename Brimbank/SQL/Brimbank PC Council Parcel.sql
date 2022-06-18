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
    case
        when aurtmast.val_num like '%-%' or aurtmast.val_num like '%.%' or aurtmast.val_num like '%*%' or aurtmast.val_num like '% %' then ''
        when substr ( aurtmast.val_num , -1 , 1 ) not in ( '1','2','3','4','5','6','7','8','9','0' ) then ''
        when aurtmast.val_num like '%\%' then upper ( aurtmast.val_num )
        when ( aurtmast.val_num like 'PC%' or aurtmast.val_num like 'CP%' ) and aurtmast.val_num not like '%/%' then upper ( aurtmast.val_num )
    	else ''
    end as internal_spi,
    case
        when auprparc.ttl_no2 = 'PT' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'CP'
        when auprparc.ttl_cde = 3 then 'SP'
        when auprparc.ttl_cde = 4 then 'RP'
        when auprparc.ttl_cde = 5 then 'LP'
        when auprparc.ttl_cde = 6 then 'TP'
        when auprparc.ttl_cde = 7 then 'CS'
        else ''
    end || ifnull ( auprparc.ttl_no5 , '' ) as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'CP'
        when auprparc.ttl_cde = 3 then 'SP'
        when auprparc.ttl_cde = 4 then 'RP'
        when auprparc.ttl_cde = 5 then 'LP'
        when auprparc.ttl_cde = 6 then 'TP'
        when auprparc.ttl_cde = 7 then 'CS'
        else ''
    end as plan_prefix,
    ifnull ( auprparc.ttl_no5 , '' ) as plan_numeral,
    case
        when auprparc.ttl_cde in ( 1,2,3,4,5,6,7 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_cde = 8 then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde = 8 then ifnull ( auprparc.ttl_no3 , '' )
        when auprparc.ttl_cde <> 8 then ifnull ( auprparc.ttl_no6 , '' )
        else ''
    end as sec,
    '' as block,
    case
        when auprparc.ttl_cde = 8 then ifnull ( auprparc.ttl_no5 , '' )
        else ''
    end as portion,
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
    authority_auprparc as auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num not in ( '' , '0' )
order by
    auprparc.ass_num
)
)
)
