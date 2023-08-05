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
    case
        when auprparc.pcl_flg = 'R' then 'A'
        when auprparc.pcl_flg = 'P' then 'P'
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case
        when aualchkl.dta_val like '%\%' or aualchkl.dta_val like 'CP%' or aualchkl.dta_val like 'PC%' then upper ( ifnull ( aualchkl.dta_val , '' ) )
        else ''
    end as internal_spi,
    case
        when auprparc.ttl_no5 like 'PART%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde in ( 1 , 2 ) then 'PS' || ifnull ( auprparc.ttl_no5 , '' )
        when auprparc.ttl_cde in ( 3 , 4 ) then 'LP' || ifnull ( auprparc.ttl_no5 , '' )
        when auprparc.ttl_cde in ( 5 , 6 ) then 'PC' || ifnull ( auprparc.ttl_no5 , '' )
        when auprparc.ttl_cde in ( 7 , 8 ) then 'CP' || ifnull ( auprparc.ttl_no5 , '' )
        when auprparc.ttl_cde in ( 9 , 10 ) then 'TP' || ifnull ( auprparc.ttl_no5 , '' )
        when auprparc.ttl_cde in ( 11 , 12 ) then 'RP' || ifnull ( auprparc.ttl_no5 , '' )
        when auprparc.ttl_cde in ( 13 , 14 ) then 'SP' || ifnull ( auprparc.ttl_no5 , '' )
        when auprparc.ttl_cde in ( 15 , 16 ) then 'CS' || ifnull ( auprparc.ttl_no5 , '' )
        else ''
    end as plan_number,
    case
        when auprparc.ttl_cde in ( 1 , 2 ) then 'PS'
        when auprparc.ttl_cde in ( 3 , 4 ) then 'LP'
        when auprparc.ttl_cde in ( 5 , 6 ) then 'PC'
        when auprparc.ttl_cde in ( 7 , 8 ) then 'CP'
        when auprparc.ttl_cde in ( 9 , 10 ) then 'TP'
        when auprparc.ttl_cde in ( 11 , 12 ) then 'RP'
        when auprparc.ttl_cde in ( 13 , 14 ) then 'SP'
        when auprparc.ttl_cde in ( 15 , 16 ) then 'CS'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde = 17 then ''
        else ifnull ( auprparc.ttl_no5 , '' )
    end as plan_numeral,
    case
        when auprparc.ttl_cde = 17 then ''
        else ifnull ( auprparc.ttl_no1 , '' )
    end as lot_number,
    case
        when auprparc.ttl_cde = 17 then replace ( ifnull ( auprparc.ttl_no5 , '' ) , 'PART ' , '' )
        else ''
    end as allotment,
    ifnull ( auprparc.ttl_no6 , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    ifnull ( auprparc.udn_cd1 , '' ) as parish_code,
    '' as township_code,
    auprparc.fmt_ttl as summary,
    '319' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc left join
    authority_aurtmast as aurtmast on auprparc.ass_num = aurtmast.ass_num left join
    authority_aualchkl as aualchkl on auprparc.pcl_num = aualchkl.mdu_acc and chk_typ = 9000
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num not in ( 81754, 84962, 78430, 70567, 94709, 97986 )
order by
    auprparc.ass_num
)
)
)
