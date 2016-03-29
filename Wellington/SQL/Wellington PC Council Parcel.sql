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
    case auprparc.udn_cd2
        when 1 then '2007'
        when 2 then '2008'
        when 3 then '2050'
        when 4 then '2149'
        when 5 then '2181'
        when 6 then '2190'
        when 7 then '2242'
        when 8 then '2255'
        when 9 then '2322'
        when 10 then '2356'
        when 11 then '2431'
        when 12 then '2497'
        when 13 then '2520'
        when 14 then '2558'
        when 15 then '2653'
        when 16 then '2668'
        when 17 then '2669'
        when 18 then '2736'
        when 19 then '2762'
        when 20 then '2808'
        when 21 then '3010'
        when 22 then '3217'
        when 23 then '3457'
        when 24 then '3479'
        when 25 then '3492'
        when 26 then '3467'
        when 27 then '3502'
        when 28 then '3511'
        when 29 then '3557'
        when 30 then '3604'
        when 31 then '3830'
        when 32 then '3869'
        when 33 then '3870'
        when 34 then '3874'
        when 35 then '3885'
        when 36 then '3899'
        when 37 then '3909'
        when 38 then '3963'
        when 41 then '2084'
        when 42 then '2111'
        when 43 then '2155'
        when 44 then '2350'
        when 45 then '2459'
        when 46 then '2489'
        when 47 then '2821'
        when 48 then '3432'
        when 49 then '3549'
        when 51 then '3672'
        when 52 then '3864'
        when 61 then '2119'
        when 62 then '2184'
        when 63 then '2215'
        when 64 then '2225'
        when 65 then '2271'
        when 66 then '2310'
        when 67 then '2508'
        when 68 then '2655'
        when 69 then '2679'
        when 70 then '2916'
        when 71 then '3029'
        when 72 then '3064'
        when 73 then '3082'
        when 74 then '3152'
        when 75 then '3173'
        when 76 then '3261'
        when 77 then '3275'
        when 78 then '3281'
        when 79 then '3282'
        when 80 then '3336'
        when 81 then '3341'
        when 82 then '3468'
        when 83 then '3475'
        when 84 then '3479'
        when 85 then '3504'
        when 86 then '3597'
        when 87 then '3618'
        when 88 then '3626'
        when 89 then '3627'
        when 90 then '3695'
        when 91 then '3702'
        when 92 then '3703'
        when 93 then '3841'
        when 94 then '3879'
        when 96 then '3896'
        when 97 then '3906'
        when 98 then '3907'
        when 99 then '3913'
        when 100 then '3914'
        when 101 then '3951'
        when 103 then '3982'
        when 104 then '2435'
        when 113 then '2170'
        when 115 then '2249'
        when 116 then '2291'
        when 117 then '2393'
        when 118 then '2466'
        when 119 then '2530'
        when 120 then '2767'
        when 121 then '2991'
        when 122 then '2992'
        when 123 then '3031'
        when 124 then '3117'
        when 125 then '3192'
        when 126 then '3448'
        when 128 then '3497'
        when 129 then '3865'
        when 130 then '3904'
        when 131 then '2533'
        when 158 then '3536'
        when 160 then '3981'
        when 161 then '2021'
        when 162 then '2143'
        when 163 then '2245'
        when 164 then '2370'
        when 165 then '3030'
        when 167 then '3790'
        else ''
    end as parish_code,
    case auprparc.udn_cd4
        when 0 then ''
        else ifnull ( cast ( auprparc.udn_cd4 as varchar ) , '' )
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