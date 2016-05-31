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
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    aualchkl.dta_val as internal_spi,
    case ttl_no2
        when 'Y' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde in ( 6 , 10 ) then ''
        when auprparc.ttl_no5 is null then ''
        else case
            when auprparc.ttl_cde = 1 then 'PS'
            when auprparc.ttl_cde = 2 then 'PC'
            when auprparc.ttl_cde = 3 then 'LP'
            when auprparc.ttl_cde = 4 then 'CP'
            when auprparc.ttl_cde = 5 then 'CS'
            when auprparc.ttl_cde = 7 then 'RP'
            when auprparc.ttl_cde = 8 then 'SP'
            when auprparc.ttl_cde = 9 then 'TP'
            when auprparc.ttl_cde = 11 then 'CP'
            when auprparc.ttl_cde = 20 then 'TP'
        end ||
        case
            when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then auprparc.ttl_no5
            when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( auprparc.ttl_no5 , 1 , length ( auprparc.ttl_no5 ) - 1 )
        end
    end as plan_number,
    case
        when auprparc.ttl_no5 is null then ''
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 5 then 'CS'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 8 then 'SP'
        when auprparc.ttl_cde = 9 then 'TP'
        when auprparc.ttl_cde = 11 then 'CP'
        when auprparc.ttl_cde = 20 then 'TP'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 6 , 10 ) then ''
        when auprparc.ttl_no5 is null then ''
        when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then auprparc.ttl_no5
        when substr ( cast ( auprparc.ttl_no5 as varchar ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( auprparc.ttl_no5 , 1 , length ( auprparc.ttl_no5 ) - 1 )
    end as plan_numeral,
    case
        when auprparc.ttl_cde in ( 6 , 10 , 11 ) then ''
        else ifnull ( auprparc.ttl_no1 , '' )
    end as lot_number,
    case
        when auprparc.ttl_cde in ( 6 , 10 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde = '11' then ifnull ( auprparc.ttl_no3 , '' )
        when auprparc.ttl_cde not in ( 6 , 10 ) then ''
        else ifnull ( auprparc.ttl_no3 , '' )
    end as sec,
    '' as block,
    case
        when auprparc.ttl_cde = '11' then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as portion,
    '' as subdivision,
    case
        when length ( auprparc.udn_cd2 ) = 4 then auprparc.udn_cd2
        else ''
    end as parish_code,
    case
        when length ( auprparc.udn_cd4 ) = 4 then auprparc.udn_cd4
        else ''
    end as township_code,
    auprparc.fmt_ttl as summary,
    '365' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num join
    authority_auprstad auprstad on auprparc.pcl_num = auprstad.pcl_num left join
    authority_aualchkl as aualchkl on auprparc.pcl_num = aualchkl.fmt_acc_int
where
    auprparc.pcl_flg in ( 'R' , 'P' , 'C' )
)
)