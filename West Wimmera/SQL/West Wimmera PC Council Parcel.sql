select
    *,
    case
        when internal_spi <> '' and internal_spi not like '% %' then 'internal_spi'
        else 'attributes'
    end as spi_mode,
    case
        when internal_spi <> '' and internal_spi not like '% %' then internal_spi
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
        when internal_spi <> '' and internal_spi not like '% %' then replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( internal_spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' )
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
    cast ( auprparc.pcl_num as varchar ) as crefno,
    ifnull ( auprparc.ttl_nme , '' ) as internal_spi,
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
        when auprparc.ttl_cde = 9 then 'CP' || auprparc.ttl_no5
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
        when 'BRI' then '2233'
        when 'CHA' then '2371'
        when 'CON' then '2426'
        when 'COO' then '2427'
        when 'CUR' then '2476'
        when 'DAD' then '2525'
        when 'DER' then '2512'
        when 'DIN' then '2527'
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
        when 'KOO' then '2910'
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
        else
            case
                when substr ( auprparc.uda_cd1 , 1 , 3 ) = 'COO' then '2427'
                else ''
            end
    end as parish_code,
    case
        when mem_txt like '%APSLEY%T%SHIP%' or mem_txt like '%T%SHIP%APSLEY%' then '5015'
        when mem_txt like '%CHETWYND%T%SHIP%' or mem_txt like '%T%SHIP%CHETWYND%' then '5171'
        when mem_txt like '%EDENHOPE%T%SHIP%' or mem_txt like '%T%SHIP%EDENHOPE%' then '5266'
        when mem_txt like '%GOROKE%T%SHIP%' or mem_txt like '%T%SHIP%GOROKE%' then '5339'
        when mem_txt like '%HARROW%T%SHIP%' or mem_txt like '%T%SHIP%HARROW%' then '5368'
        when mem_txt like '%KANIVA%T%SHIP%' or mem_txt like '%T%SHIP%KANIVA%' then '5404'
        when mem_txt like '%KONNEPRA%T%SHIP%' or mem_txt like '%T%SHIP%KONNEPRA%' then '5870'
        when mem_txt like '%SERVICETON%T%SHIP%' or mem_txt like '%T%SHIP%SERVICETON%' then '5709'
        when mem_txt like '%SOUTH%LILLIMUR%T%SHIP%' or mem_txt like '%T%SHIP%SOUTH LILLIMUR%' then '5464'
        when mem_txt like '%LILLIMUR%T%SHIP%' or mem_txt like '%T%SHIP%LILLIMUR%' then '5463'
        else ''
    end as township_code,
    fmt_ttl as summary,
    ifnull ( mem_txt , '' ) as memo,
    '371' as lga_code
from
    authority_auprparc as auprparc left join
    authority_aumememo as aumememo on
        auprparc.ass_num = aumememo.mdu_acc and
        aumememo.mem_typ = 1 and
        aumememo.seq_num = 1 and
        aumememo.mem_txt is not null join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ttl_cde not in ( 99 , 999 ) and
    auprparc.ass_num is not null and
    aurtmast.rte_cls <> 'CA'
group by auprparc.pcl_num
)