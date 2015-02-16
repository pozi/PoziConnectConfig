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
    end as spi,
    case
        when plan_numeral <> '' and lot_number = '' then plan_numeral
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_numeral
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_numeral
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
    end as status,
    '' as crefno,
    case
        when auprparc.ttl_cde = 4 then 'P'
        when auprparc.ttl_cde = 6 then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'TP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 3 then 'PS' || auprparc.ttl_no5
        when auprparc.ttl_cde = 4 then 'PS' || auprparc.ttl_no5
        when auprparc.ttl_cde = 5 then 'LP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 6 then 'LP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 7 then ''
        when auprparc.ttl_cde = 8 then ''
        when auprparc.ttl_cde = 9 then 'CP'
    end as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'TP'
        when auprparc.ttl_cde = 3 then 'PS'
        when auprparc.ttl_cde = 4 then 'PS'
        when auprparc.ttl_cde = 5 then 'LP'
        when auprparc.ttl_cde = 6 then 'LP'
        when auprparc.ttl_cde = 7 then ''
        when auprparc.ttl_cde = 8 then ''
        when auprparc.ttl_cde = 9 then 'CP'
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 7 , 8 ) then ''
        else auprparc.ttl_no5
    end as plan_numeral,
    case
        when auprparc.ttl_cde not in ( 7 , 8 ) then ifnull ( upper ( ttl_no1 ) , '' )
        else ''
    end as lot_number,
    case when auprparc.ttl_cde in ( 7 , 8 ) then ifnull ( upper ( ttl_no1 ) , '' ) else '' end as allotment,
    ifnull ( ttl_no3 , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case auprparc.uda_cd1
        when 'AWO' then '2033'
        when 'BAM' then '2058'
        when 'BEE' then '2104'
        when 'BEN' then '2115'
        when 'BOG' then '2163'
        when 'BOI' then '2168'
        when 'BOO' then '2197'
        when 'BRI' then '2228'
        when 'CHA' then '2371'
        when 'CON' then '2426'
        when 'COO' then '2427'
        when 'CUR' then '2476'
        when 'DAD' then '2481'
        when 'DER' then '2512'
        when 'DIN' then '2525'
        when 'DOP' then '2538'
        when 'DRG' then '2570'
        when 'DUR' then '2569'
        when 'EDE' then '2575'
        when 'GAN' then '2634'
        when 'GOR' then '2708'
        when 'GYM' then '2739'
        when 'HAR' then '2745'
        when 'JAL' then '2777'
        when 'JUN' then '2812'
        when 'KAD' then '2815'
        when 'KAL' then '2818'
        when 'KAN' then '2833'
        when 'KAR' then '2842'
        when 'KNW' then '2827'
        when 'KON' then '2902'
        when 'KOO' then '2906'
        when 'KOU' then '2933'
        when 'LAN' then '2967'
        when 'LAW' then '2981'
        when 'LEE' then '2985'
        when 'LIL' then '2995'
        when 'MAG' then '3032'
        when 'MAH' then '3036'
        when 'MEE' then '3079'
        when 'MIN' then '3111'
        when 'MIR' then '3118'
        when 'MOO' then '3169'
        when 'MOR' then '3187'
        when 'MRD' then '3233'
        when 'MRT' then '3194'
        when 'MUR' then '3234'
        when 'NAT' then '3284'
        when 'NEU' then '3303'
        when 'NUR' then '3342'
        when 'ROS' then '3458'
        when 'TAL' then '3526'
        when 'TLG' then '3620'
        when 'TOO' then '3625'
        when 'TUR' then '3659'
        when 'WAL' then '3710'
        when 'WIL' then '3827'
        when 'WOM' then '3858'
        when 'WYT' then '3923'
        when 'YAL' then '3933'
        when 'YAN' then '3952'
        when 'YAR' then '3969'
        when 'YEA' then '3980'
        when 'YGK' then '3965'
        when 'YOU' then '3998'
        else ''
    end as parish_code,
    '' as township_code,
    fmt_ttl as summary,
    '371' as lga_code
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ttl_cde not in ( 99 , 999 )
)