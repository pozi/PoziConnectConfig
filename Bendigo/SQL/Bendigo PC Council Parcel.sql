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
select distinct
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    '' as status,
    cast ( lpaparc.tpklpaparc as varchar ) as crefno,
    ifnull ( lpaparc.fmtparcel , '' ) as summary,
    ifnull ( lpaparc.plancode , '' ) ||
        case
            when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then lpaparc.plannum
            when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 )
            else ''
        end as plan_number,
    ifnull ( lpaparc.plancode , '' ) as plan_prefix,
    case
        when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then lpaparc.plannum
        when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 )
        else ''
    end as plan_numeral,
    case
        when lpaparc.parcelcode = 'RES' then 'RES' || ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpaparc.parcelnum , '' )
    end as lot_number,
    ifnull ( lpaparc.parcelnum , '' ) as allotment,
    ifnull ( replace ( lpasect.parcelsect , 'NO' , '' ) , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case ( select x.tfklpadesc from pathway_lpadepa x where x.tfklpaparc = lpaparc.tpklpaparc and x.tfklpadetp = 20 )
        when 59 then '2034'
        when 60 then '2039'
        when 63 then '2458'
        when 64 then '2467'
        when 65 then '2488'
        when 67 then '2523'
        when 68 then '2578'
        when 69 then '2585'
        when 70 then '2588'
        when 71 then '2596'
        when 72 then '2706'
        when 73 then '2750'
        when 74 then '2770'
        when 75 then '2825'
        when 76 then '2893'
        when 77 then '2879'
        when 78 then '2892'
        when 80 then '2986'
        when 81 then '3006'
        when 82 then '2973'
        when 83 then '3023'
        when 84 then '3116'
        when 85 then '3051'
        when 86 then '3068'
        when 87 then '3171'
        when 88 then '3294'
        when 89 then '3316'
        when 90 then '3301'
        when 91 then '3442'
        when 92 then '3445'
        when 93 then '3446'
        when 94 then '3473'
        when 95 then '3480'
        when 96 then '3483'
        when 98 then '3496'
        when 99 then '3506'
        when 101 then '3611'
        when 102 then '3801'
        when 103 then '3789'
        when 104 then '3747'
        when 105 then '3806'
        when 106 then '3875'
        when 107 then '3961'
        when 108 then '3936'
        else ''
    end as parish_code,
    case ( select x.tfklpadesc from pathway_lpadepa x where x.tfklpaparc = lpaparc.tpklpaparc and x.tfklpadetp = 21 )
        when 110 then '5020'
        when 112 then '5473'
        when 113 then '5505'
        when 114 then '5583'
        when 116 then '5665'
        when 117 then '5667'
        when 118 then '5706'
        when 119 then '5403'
        when 120 then '5854'
        when 121 then '5277'
        when 122 then '5297'
        when 124 then '5201'
        when 125 then '5373'
        when 126 then '5527'
        when 127 then '5669'
        when 129 then '5670'
        when 130 then '5284'
        when 131 then '5335'
        when 132 then '5389'
        when 133 then '5024'
        when 134 then '5497'
        when 135 then '5740'
        when 138 then '3473A'
        when 137 then
            case ( select x.tfklpadesc from pathway_lpadepa x where x.tfklpaparc = lpaparc.tpklpaparc and x.tfklpadetp = 20 )
                when 90 then '3301A'
                when 94 then '3473B'
                else ''
            end
        else ''
    end as township_code,
    '325' as lga_code,
    case
        when lraassm.status = 'C' and lraassm.applicatn = 'R' then cast ( cast ( lraassm.assmnumber as integer ) as varchar )
        else ''
    end as assnum
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    pathway_cnacomp as cnacomp on lpaaddr.tfkcnacomp = cnacomp.tpkcnacomp left join
    pathway_lpaprti as lpaprti on lpaprop.tpklpaprop = lpaprti.tfklpaprop left join
    pathway_lpatitl as lpatitl on lpaprti.tfklpatitl = lpatitl.tpklpatitl left join
    pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left join
    pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    pathway_lparole as lparole on lpaprop.tpklpaprop = lparole.tfklocl left join
    pathway_lraassm as lraassm on lparole.tfkappl = lraassm.tpklraassm
where
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H' and
    ifnull ( lpaparc.plancode , '' ) in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' )
)
)