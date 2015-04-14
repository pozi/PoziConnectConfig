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
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case
        when auprparc.ttl_no2 is null and auprparc.ttl_no3 not null then 'P'
        when auprparc.ttl_no1 like 'PT%' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'LP'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 4 then ''
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 9 then 'TP'
    end ||
        case
            when auprparc.ttl_cde = 4 then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 ) )
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'LP'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 4 then ''
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 9 then 'TP'
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
                when 'NE' then '3259'
                when 'NI' then '3312'
                when 'PC' then '3382'
                when 'PE' then '3387'
                when 'PK' then '3395'
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
        when auprparc.ttl_cde = 4 then
            case auprparc.uda_cd1
                when 'WP' then '5664'
                else ''
            end
        else ''
    end as township_code,
    case
        when auprparc.ttl_cde = 4 then auprparc.uda_cd1 || ': ' || fmt_ttl
        else fmt_ttl
    end as summary,
    '330' as lga_code
from
    authority_auprparc as auprparc
where
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num is not null
)