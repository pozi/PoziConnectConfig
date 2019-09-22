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
    cast ( cast ( lpaprop.tpklpaprop as integer ) as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    cast ( lpaparc.tpklpaparc as varchar ) as crefno,
    '' as internal_spi,
    case
        when lpaparc.parcelcode in ( 'PT' , 'PT L' ) then 'P'
        else ''
    end as part,
    ifnull ( lpaparc.plancode || ': ' , '' ) || ifnull ( trim ( lpaparc.fmtparcel ) , '' ) as summary,
    ifnull ( lpaparc.plancode || lpaparc.plannum , '' ) as plan_number,
    ifnull ( lpaparc.plancode , '' ) as plan_prefix,
    ifnull ( lpaparc.plannum , '' ) as plan_numeral,
    ifnull ( lpaparc.parcelnum , '' ) as lot_number,
    ifnull ( lpacrwn.crownallot , '' ) as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    case
        when lpaparc.fmtparcel like '%Block %' then substr ( lpaparc.fmtparcel , -1 , 1 )
        else ''
    end as block,
    '' as portion,
    '' as subdivision,
    case upper ( lpadesc.descr )
        when 'FRANKSTON' then '2619'
        when 'LANGWARRIN' then '2972'
        when 'LYNDHURST' then '3025'
        else ''
    end as parish_code,
    case upper ( lpadesc.descr )
        when 'FRANKSTON TOWNSHIP' then '5301'
        when 'SKYE TOWNSHIP' then '5718'
        else ''
    end as township_code,
    '320' as lga_code,
    cast ( cast ( lpaprop.tpklpaprop as integer ) as varchar ) as assnum
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
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc left join
    pathway_lpadesc as lpadesc on lpadepa.tfklpadesc = lpadesc.tpklpadesc
where
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H'
)
)
