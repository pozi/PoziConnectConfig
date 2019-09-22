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
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    '' as internal_spi,
    case
        when auprparc.ttl_cde in ( 2 , 4 , 6 , 8 , 10 ) then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde in ( 1 , 2 ) then 'PS'
        when auprparc.ttl_cde in ( 3 , 4 ) then 'TP'
        when auprparc.ttl_cde in ( 5 , 6 ) then 'LP'
        when auprparc.ttl_cde in ( 7 , 8 ) then ''
        when auprparc.ttl_cde in ( 9 , 10 ) then 'PC'
        when auprparc.ttl_cde in ( 11 , 17 ) then 'SP'
        when auprparc.ttl_cde = 12 then 'RP'
        when auprparc.ttl_cde = 13 then 'CS'
        when auprparc.ttl_cde in ( 14 , 15 ) then 'CP'
        else ''
    end ||
        case
            when auprparc.ttl_cde in ( 7 , 8 ) then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde in ( 1 , 2 ) then 'PS'
        when auprparc.ttl_cde in ( 3 , 4 ) then 'TP'
        when auprparc.ttl_cde in ( 5 , 6 ) then 'LP'
        when auprparc.ttl_cde in ( 7 , 8 ) then ''
        when auprparc.ttl_cde in ( 9 , 10 ) then 'PC'
        when auprparc.ttl_cde in ( 11 , 17 ) then 'SP'
        when auprparc.ttl_cde = 12 then 'RP'
        when auprparc.ttl_cde = 13 then 'CS'
        when auprparc.ttl_cde in ( 14 , 15 ) then 'CP'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 7 , 8 ) then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde in ( 7 , 8 ) then ''
        when auprparc.ttl_cde = 5 and ttl_no1 like '%BLK%' then trim ( substr ( ttl_no1 , 1 , 2 ) )
        else ifnull ( replace ( upper ( ttl_no1 ) , ' ' , '' ) , '' )
    end as lot_number,
    case
        when auprparc.ttl_cde in ( 7 , 8 ) then ifnull ( replace ( upper ( ttl_no1 ) , ' ' , '' ) , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde in ( 5 , 6 , 7 , 8 ) then ifnull ( ttl_no3 , '' )
        else ''
    end as sec,
    case
        when auprparc.ttl_cde = 5 and ttl_no1 like '%BLK%' then substr ( ttl_no1 , -1 , 1 )
        when length ( auprparc.ttl_no4 ) < 4 and auprparc.ttl_no4 <> '\' then ifnull ( auprparc.ttl_no4 , '' )
        else ''
    end as block,
    '' as portion,
    '' as subdivision,
    case when auprparc.ttl_cde in ( 7 , 8 ) then
        case upper ( auprparc.uda_cd2 )
            when 'BA' then '2075'
            when 'BR' then '2087'
            when 'BK' then '2092'
            when 'BH' then '2186'
            when 'BO' then '2201'
            when 'BW' then '2214'
            when 'BU' then '2272'
            when 'BM' then '2300'
            when 'CO' then '2397'
            when 'DR' then '2549'
            when 'DU' then '2560'
            when 'KA' then '2814'
            when 'KY' then '2834'
            when 'KR' then '2844'
            when 'KM' then '2849'
            when 'KG' then '2852'
            when 'KO' then '2932'
            when 'MO' then '3138'
            when 'MU' then '3220'
            when 'NG' then '3267'
            when 'NA' then '3270'
            when 'PC' then '3381'
            when 'PE' then '3383'
            when 'PI' then '3393'
            when 'SJ' then '3466'
            when 'ST' then '3507'
            when 'TH' then '3582'
            when 'UL' then '3680'
            when 'WA' then '3688'
            when 'WG' then '3697'
            when 'YA' then '3928'
            when 'YL' then '3930'
            when 'YG' then '3967'
            when 'YW' then '3972'
            when 'YI' then '3992'
            when 'YU' then '3995'
            when 'YO' then '3996'
            else ifnull ( auprparc.uda_cd2 , '' )
        end
        else ''
    end as parish_code,
    ifnull ( replace ( auprparc.uda_cd3 , '9999' , '' ) , '' ) as township_code,
    fmt_ttl as summary,
    '347' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ttl_cde not in ( 50 , 99 )
)
)