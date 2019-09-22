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
        when auprparc.ttl_no2 is null and auprparc.ttl_no3 not null then 'P'
        when auprparc.ttl_no1 like 'PT%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'LP'
        when auprparc.ttl_cde = 2 then 'CP'
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 9 then 'TP'
        when auprparc.ttl_cde = 10 then 'PS'
        when auprparc.ttl_cde = 11 then 'CS'
        when auprparc.ttl_cde = 12 then 'PC'
        else ''
    end ||
        case
            when auprparc.ttl_cde = 4 then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'LP'
        when auprparc.ttl_cde = 2 then 'CP'
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 9 then 'TP'
        when auprparc.ttl_cde = 10 then 'PS'
        when auprparc.ttl_cde = 11 then 'CS'
        when auprparc.ttl_cde = 12 then 'PC'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde = 4 then ''
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
        when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde <> 4 then replace ( replace ( ifnull ( upper ( ttl_no1 ) , '' ) , 'PT ' , '' ) , 'RES NO ' , 'RES' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_cde = 4 and ttl_no2 is not null and ttl_no3 is not null and cast ( cast ( ttl_no3 as integer ) as varchar ) <> ttl_no3 then upper ( ttl_no2 || ttl_no3 )
        when auprparc.ttl_cde = 4 and ttl_no2 is not null then upper ( ttl_no2 )
        when auprparc.ttl_cde = 4 and ttl_no3 is not null then upper ( ttl_no3 )
        when auprparc.ttl_cde = 4 and ttl_no1 is not null then upper ( ttl_no1 )
        else ''
    end as allotment,
    ifnull ( ttl_no4 , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde = 4 then
            case auprparc.uda_cd1
                when 'AA' then '2006'
                when 'BO' then '2037'
                when 'BA' then '2056'
                when 'BT' then '2063'
                when 'BK' then '2091'
                when 'BE' then '2124'
                when 'CA' then '2367'
                when 'CF' then '2383'
                when 'CO' then '2460'
                when 'DW' then '2481'
                when 'DA' then '2524'
                when 'GG' then '2648'
                when 'HH' then '2758'
                when 'JT' then '2793'
                when 'JP' then '2807'
                when 'KL' then '2853'
                when 'KE' then '2860'
                when 'KA' then '2874'
                when 'KI' then '2883'
                when 'KN' then '2943'
                when 'LQ' then '3016'
                when 'ML' then '3161'
                when 'MM' then '3105'
                when 'NE' then '3259'
                when 'NI' then '3312'
                when 'PC' then '3382'
                when 'PE' then '3387'
                when 'PK' then '3395'
                when 'PO' then '3409'
                when 'PR' then '3419'
                when 'PT' then '3422'
                when 'TG' then '3554'
                when 'TK' then '3556'
                when 'TA' then '3656'
                when 'TY' then '3669'
                when 'WR' then '3755'
                when 'WA' then '3770'
                when 'WP' then '3796'
                when 'WY' then '3827'
                when 'WI' then '3838'
                when 'WL' then '3849'
                when 'WO' then '3884'
                when 'WM' then '3898'
                when 'YN' then '3944'
                else ''
            end
        else ''
    end as parish_code,
    case
        when auprparc.uda_cd3 = 'AB' then '5004'
        when auprparc.uda_cd3 = 'AW' then '5013'
        when auprparc.uda_cd3 = 'BK' then '5028'
        when auprparc.uda_cd3 = 'BR' then '5118'
        when auprparc.uda_cd3 = 'DA' then '5245'
        when auprparc.uda_cd3 = 'DP' then '5243'
        when auprparc.uda_cd3 = 'EM' then '5274'
        when auprparc.uda_cd3 = 'GG' then '5315'
        when auprparc.uda_cd3 = 'KA' then '5417'
        when auprparc.uda_cd3 = 'LQ' then '5479'
        when auprparc.uda_cd3 = 'NB' then '5586'
        when auprparc.uda_cd3 = 'NH' then '5595'
        when auprparc.uda_cd3 = 'NI' then '5597'
        when auprparc.uda_cd3 = 'PT' then '5655'
        when auprparc.uda_cd3 = 'RB' then '5664'
        when auprparc.uda_cd3 = 'SB' then '5696'
        when auprparc.uda_cd3 = 'TG' then '5766'
        when auprparc.uda_cd3 = 'YS' then '5895'
        else ''
    end as township_code,
    case
        when auprparc.ttl_cde = 4 then auprparc.uda_cd1 || ': ' || fmt_ttl
        else fmt_ttl
    end as summary,
    '330' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num is not null and
    aurtmast.rte_zne <> 'DA'
)
)
