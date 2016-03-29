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
        else ''
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case
        when auprparc.ttl_nme like '%CP%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%PC%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%\CS%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%\LP%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%\PP%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%\PS%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%\RP%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%\SP%' then auprparc.ttl_nme
        when auprparc.ttl_nme like '%\TP%' then auprparc.ttl_nme
        else ''
    end as internal_spi,
    case
        when auprparc.ttl_cde > 10 and auprparc.ttl_cde < 20 then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde in ( 1 , 12 ) then 'PS'
        when auprparc.ttl_cde in ( 2 , 13 ) then 'PC'
        when auprparc.ttl_cde in ( 3 , 4 ) then ''
        when auprparc.ttl_cde in ( 5 , 15 ) then 'TP'
        when auprparc.ttl_cde in ( 6 ) then 'CP'
        when auprparc.ttl_cde in ( 7 , 16 ) then 'RP'
        when auprparc.ttl_cde in ( 8 ) then 'SP'
        when auprparc.ttl_cde in ( 9 , 14 ) then 'CS'
        when auprparc.ttl_cde in ( 10 ) then 'LP'
        else ''
    end ||
        case
            when auprparc.ttl_cde in ( 3 , 4 ) then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde in ( 1 , 12 ) then 'PS'
        when auprparc.ttl_cde in ( 2 , 13 ) then 'PC'
        when auprparc.ttl_cde in ( 3 , 4 ) then ''
        when auprparc.ttl_cde in ( 5 , 15 ) then 'TP'
        when auprparc.ttl_cde in ( 6 ) then 'CP'
        when auprparc.ttl_cde in ( 7 , 16 ) then 'RP'
        when auprparc.ttl_cde in ( 8 ) then 'SP'
        when auprparc.ttl_cde in ( 9 , 14 ) then 'CS'
        when auprparc.ttl_cde in ( 10 ) then 'LP'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 3 , 4 ) then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde not in ( 3 , 4 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_cde in ( 3 , 4 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde in ( 3 , 4 ) then ifnull ( ttl_no3 , '' )
        else ''
    end as sec,
    case
        when auprparc.ttl_cde in ( 3 , 4 ) then ifnull ( ttl_no4 , '' )
        else ''
    end as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde in ( 9 , 19 , 24 , 99 ) then
            case
                when auprparc.udn_cd1 = 3102 and cast ( ttl_no3 as integer ) <> 0 then '3102A'
                else ifnull ( auprparc.udn_cd1 , '' )
            end
        else ''
    end as parish_code,
    case
        when auprparc.ttl_cde in ( 9 , 19 , 24 , 99 ) and auprparc.udn_cd4 like '5%' then ifnull ( auprparc.udn_cd4 , '' )
        else ''
    end as township_code,
    ifnull ( auprparc.fmt_ttl , '' ) as summary,
    '370' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' , 'U' ) and
    auprparc.ass_num is not null
)
)