select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when internal_spi not in ( '' , 'NIL' ) then internal_spi
        else constructed_spi
    end as spi,
    case
        when internal_spi not in ( '' , 'NIL' ) then 'council_spi'
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
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    ifnull ( auprparc.ttl_nme , '' ) as internal_spi,
    case
        when auprparc.ttl_no1 like '%PT%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then ''
        when auprparc.ttl_cde = 2 then 'PS'
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 5 then
            case
                when fmt_ttl like '%SP%' then 'SP'
                else 'RP'
            end
        when auprparc.ttl_cde = 7 then 'TP'
        when auprparc.ttl_cde = 8 then ''
        when auprparc.ttl_cde = 9 then ''
        when auprparc.ttl_cde = 10 then 'PC'
    end ||
        case
            when auprparc.ttl_cde in ( 1 , 8 , 9 ) then ''
            else ifnull ( cast ( auprparc.ttl_in5 as varchar ) , '' )
        end as plan_number,
    case
        when auprparc.ttl_cde = 1 then ''
        when auprparc.ttl_cde = 2 then 'PS'
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 5 then
            case
                when fmt_ttl like '%SP%' then 'SP'
                else 'RP'
            end
        when auprparc.ttl_cde = 7 then 'TP'
        when auprparc.ttl_cde = 8 then ''
        when auprparc.ttl_cde = 9 then ''
        when auprparc.ttl_cde = 10 then 'PC'
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 1 , 8 , 9 ) then ''
        else ifnull ( cast ( auprparc.ttl_in5 as varchar ) , '' )
    end as plan_numeral,
    case
        when auprparc.ttl_cde = 3 and length ( ttl_no1 ) > 1 and substr ( ttl_no1 , 1 , 1 ) in ( 'A' , 'B' ) then substr ( ttl_no1 , 2 , 99 )
        when auprparc.ttl_cde not in ( 1 , 8 , 9 ) then ifnull ( upper ( replace ( ttl_no1 , 'RES ' , 'RES' ) ) , '' )
        else ''
    end as lot_number,
    case when auprparc.ttl_cde in ( 1 , 9 ) then ifnull ( upper ( ttl_no1 ) , '' ) else '' end as allotment,
    ifnull ( ttl_no4 , '' ) as sec,
    case
        when auprparc.ttl_cde = 3 and length ( ttl_no1 ) > 1 and substr ( ttl_no1 , 1 , 1 ) in ( 'A' , 'B' ) then substr ( ttl_no1 , 1 , 1 )
        else ''
    end as block,
    case when auprparc.ttl_cde = 8 then ifnull ( upper ( ttl_no1 ) , '' ) else '' end as portion,
    '' as subdivision,
    case auprparc.udn_cd1
        when 5 then '2065'
        when 10 then '2074'
        when 15 then '2107'
        when 20 then '2108'
        when 30 then '2171'
        when 35 then '2204'
        when 40 then '2205'
        when 45 then '2182'
        when 50 then '2208'
        when 55 then '2257'
        when 60 then '2302'
        when 65 then '2306'
        when 70 then '2301'
        when 75 then '2321'
        when 80 then '2338'
        when 85 then '2339'
        when 90 then '2418'
        when 95 then '2419'
        when 102 then '2439'
        when 105 then '2468'
        when 110 then '2482'
        when 115 then '2490'
        when 120 then '2632'
        when 125 then '2682'
        when 130 then '2687'
        when 135 then '2695'
        when 140 then '2715'
        when 145 then '2725'
        when 150 then '2771'
        when 155 then '2806'
        when 160 then '2887'
        when 165 then '2890'
        when 170 then '2913'
        when 175 then '2915'
        when 180 then '2955'
        when 185 then '2963'
        when 190 then '2984'
        when 195 then '3040'
        when 200 then '3067'
        when 205 then '3140'
        when 210 then '3154'
        when 215 then '3193'
        when 220 then '3206'
        when 225 then '3287'
        when 230 then '3288'
        when 235 then '3443'
        when 237 then '3443'
        when 240 then '3449'
        when 245 then '3450'
        when 250 then '3451'
        when 255 then '3463'
        when 260 then '3499'
        when 265 then '3515'
        when 270 then '3637'
        when 275 then '3706'
        when 280 then '3743'
        when 285 then '3756'
        when 290 then '3754'
        when 295 then '3767'
        when 300 then '3768'
        when 305 then '3777'
        when 310 then '3822'
        when 315 then '3837'
        when 320 then '3839'
        when 325 then '3846'
        else ifnull ( cast ( auprparc.udn_cd1 as varchar ) , '' )
    end as parish_code,
    case auprparc.udn_cd2
        when 10 then '5041'
        when 15 then '5059'
        when 25 then '5142'
        when 30 then '5151'
        when 35 then '5194'
        when 45 then '5281'
        when 50 then '5326'
        when 55 then '5336'
        when 60 then '5343'
        when 65 then '5355'
        when 70 then '5351'
        when 85 then '5374'
        when 95 then '5480'
        when 105 then '5581'
        when 110 then '5692'
        when 115 then '5730'
        when 120 then '5742'
        else ifnull ( cast ( auprparc.udn_cd2 as varchar ) , '' )
    end as township_code,
    fmt_ttl as summary,
    '357' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num
where
    auprparc.pcl_flg in ( 'M' , 'R' , 'P' ) and
    auprparc.ttl_cde not in ( 6 , 50 ) and
    auprparc.ass_num not in ( 2233289 , 2234543 )
)
)
)
