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
    '' as part,
    case
        when auprparc.ttl_cde = 3 then ''
        else case
            when auprparc.ttl_cde = 1 then 'PS'
            when auprparc.ttl_cde = 2 then 'PC'
            when auprparc.ttl_cde = 4 then 'CP'
            when auprparc.ttl_cde = 5 then 'SP'
            when auprparc.ttl_cde = 6 then 'LP'
            when auprparc.ttl_cde = 7 then 'RP'
            when auprparc.ttl_cde = 8 then 'CS'
            when auprparc.ttl_cde = 10 then 'PS'
            when auprparc.ttl_cde = 15 then 'TP'
            when auprparc.ttl_cde = 20 then 'PS'
        end || auprparc.ttl_no5
    end as plan_number,
    case
        when auprparc.ttl_cde = 3 then ''
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 6 then 'LP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 8 then 'CS'
        when auprparc.ttl_cde = 10 then 'PS'
        when auprparc.ttl_cde = 15 then 'TP'
        when auprparc.ttl_cde = 20 then 'PS'
    end as plan_prefix,
    case
        when auprparc.ttl_cde = 3 then ''
        else auprparc.ttl_no5
    end as plan_numeral,
    case
        when auprparc.ttl_cde = 3 then ''
        else ifnull ( auprparc.ttl_no1 , '' )
    end as lot_number,
    case
        when auprparc.ttl_cde = 3 then auprparc.ttl_no5
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde <> 3 then ''
        else ifnull ( ttl_no4 , '' )
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde <> 3 then ''
        else
            case auprparc.ttl_no6
                when 'BARROWORN' then '2084'
                when 'BARWIDGEE' then '2085'
                when 'BRIGHT' then '2227'
                when 'BRUARONG' then '2239'
                when 'BUCKLAND' then '2247'
                when 'BULGABACK' then '2256'
                when 'BUNGAMERO' then '2277'
                when 'CARRUNO' then '2361'
                when 'COOLUMBOOKA' then '2430'
                when 'COOMA' then '2433'
                when 'DANDONGADALE' then '2484'
                when 'DARBALANG' then '2486'
                when 'DEDERANG' then '2505'
                when 'EURANDELONG' then '2606'
                when 'FREEBURGH' then '2620'
                when 'GUNDOWRING' then '2734'
                when 'HARRIETVILLE' then '2744'
                when 'HOTHAM' then '2765'
                when 'KERGUNYAH' then '2863'
                when 'MAHARATTA' then '3034'
                when 'MATONG NORTH' then '3075'
                when 'MOROCKDONG' then '3191'
                when 'MUDGEGONGA' then '3210'
                when 'MULLAGONG' then '3213'
                when 'MULLAWYE' then '3214'
                when 'MULLINDOLINGONG' then '3215'
                when 'MURMUNGEE' then '3227'
                when 'MYRTLEFORD' then '3249'
                when 'PANBULLA' then '3366'
                when 'POREPUNKAH' then '3413'
                when 'TAWANGA' then '3568'
                when 'THEDDORA' then '3583'
                when 'TOWAMBA' then '3639'
                when 'WANDILIGONG' then '3720'
                when 'WERMATONG' then '3795'
                when 'WHOROULY' then '3810'
                when 'WINTERIGA' then '3842'
                when 'YERTOO' then '3989'
                else ''
            end
    end as parish_code,
    case
        when auprparc.ttl_cde <> 3 then ''
        else
            case auprparc.ttl_no6
                when 'BRIGHT (T)' then '5110'
                when 'DEDERANG (T)' then '5234'
                when 'FREEBURGH (T)' then '5302'
                when 'HARRIETVILLE (T)' then '5367'
                when 'MUDGEGONGA (T)' then '5558'
                when 'MYRTLEFORD (T)' then '5568'
                when 'POREPUNKAH (T)' then '5645'
                when 'WANDILIGONG (T)' then '5826'
                else ''
            end
    end as township_code,
    fmt_ttl as summary,
    '300' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num join
    authority_auprstad auprstad on auprparc.pcl_num = auprstad.pcl_num
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    upper ( auprstad.sbr_nme ) not in ( 'HOTHAM HEIGHTS' , 'FALLS CREEK' )
)
)