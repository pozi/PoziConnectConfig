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
select distinct
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
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
        when lpaparc.plancode is not null then replace ( ifnull ( lpaparc.parcelnum , '' ) , ' ' , '' )
        else ''
    end as lot_number,
    case
        when lpaparc.plancode is null then ifnull ( lpaparc.parcelnum , '' )
        else ''
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case ( select x.tfklpadesc from pathway_lpadepa x where x.tfklpaparc = lpaparc.tpklpaparc and x.tfklpadetp = 21 )
        when 60 then '2002'
        when 61 then '2028'
        when 62 then '2046'
        when 63 then '2224'
        when 64 then '2279'
        when 65 then '2287'
        when 66 then '2305'
        when 67 then '2344'
        when 68 then '2387'
        when 69 then '2391'
        when 70 then '2464'
        when 71 then '2542'
        when 72 then '2592'
        when 73 then '2597'
        when 74 then '2671'
        when 75 then '2740'
        when 76 then '3495'
        when 77 then '3638'
        when 78 then '3760'
        when 79 then '3832'
        when 80 then '3971'
        else ''
    end as parish_code,
    case ( select x.tfklpadesc from pathway_lpadepa x where x.tfklpaparc = lpaparc.tpklpaparc and x.tfklpadetp = 22 )
        when 81 then '5030'
        when 82 then '5031'
        when 83 then '5032'
        when 84 then '5531'
        when 85 then '5457'
        when 86 then '5134'
        when 87 then '5259'
        when 88 then '5362'
        when 89 then '5585'
        when 90 then '5707'
        when 91 then '5840'
        when 92 then '2287A'
        else ''
    end as township_code,
    '302' as lga_code,
    cast ( lpaprop.tpklpaprop as varchar ) as assnum
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    pathway_lpaprti_mod as lpaprti_mod on lpaprop.tpklpaprop = lpaprti_mod.tfklpaprop left join
    pathway_lpatitl as lpatitl on lpaprti_mod.tfklpatitl = lpatitl.tpklpatitl left join
    pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left join
    pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc
where
   lpaprop.status <> 'H' and
   lpaparc.status <> 'H' and
   lpatipa.status <> 'H' and
   lpaprti_mod.status <> 'H' and
   lpatitl.status <> 'H'
)
)