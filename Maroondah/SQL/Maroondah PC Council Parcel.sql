select distinct
    lpaprop.tpklpaprop as propnum,
    '' as status,
    case
        when lpaparc.parcelnum is not null and lpaparc.parcelcode <> 'C/A' then trim (  lpaparc.parcelnum) || '\'
        when lpaparc.parcelcode = 'C/A' and trim ( lpasect.parcelsect ) is not null then trim ( lpaparc.parcelnum ) || '~' || trim ( lpasect.parcelsect ) || '\'
        when lpaparc.parcelcode = 'C/A' and trim ( lpasect.parcelsect ) is null then trim ( lpaparc.parcelnum ) || '\'
        else ''
    end ||
        case
            when lpaparc.plannum is not null then cast ( trim ( lpaparc.plancode ) || trim ( lpaparc.plannum ) as varchar )
            when lpaparc.plannum is null and lpaparc.parcelcode = 'C/A' then cast ( 'PP' || cnacomp.descrsrch as varchar )
            else ''
        end as spi,
    case
        when lpaparc.parcelnum is not null and lpaparc.parcelcode <> 'C/A' then trim (  lpaparc.parcelnum) || '\'
        when lpaparc.parcelcode = 'C/A' and trim ( lpasect.parcelsect ) is not null then trim ( lpaparc.parcelnum ) || '~' || trim ( lpasect.parcelsect ) || '\'
        when lpaparc.parcelcode = 'C/A' and trim ( lpasect.parcelsect ) is null then trim ( lpaparc.parcelnum ) || '\'
        else ''
    end ||
        case
            when lpaparc.plannum is not null then trim ( lpaparc.plannum )
            when lpaparc.plannum is null and lpaparc.parcelcode = 'C/A' then cast ( cnacomp.descrsrch as varchar )
            else ''
        end as simple_spi,
    '' as crefno,
    ifnull ( lpaparc.fmtparcel , '' ) as summary,
    ifnull ( lpaparc.plancode , '' ) || ifnull ( lpaparc.plannum , '' ) as plan_number,
    ifnull ( lpaparc.plancode , '' ) as plan_prefix,
    ifnull ( lpaparc.plannum , '' ) as plan_numeral,
    ifnull ( lpaparc.parcelnum , '' ) as lot_number,
    '' as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    ifnull ( cnacomp.descrsrch , '' ) as parish_code,
    '342' as lga_code
from
    PATHWAY_lpaprop as lpaprop left join
    PATHWAY_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    PATHWAY_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    PATHWAY_cnacomp as cnacomp on lpaaddr.tfkcnacomp = cnacomp.tpkcnacomp left join
    PATHWAY_lpaprti_mod as lpaprti_mod on lpaprop.tpklpaprop = lpaprti_mod.tfklpaprop left join
    PATHWAY_lpatitl as lpatitl on lpaprti_mod.tfklpatitl = lpatitl.tpklpatitl left join
    PATHWAY_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    PATHWAY_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    PATHWAY_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left join
    PATHWAY_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    PATHWAY_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc
where
   lpaprop.status = 'C' and
   lpaparc.status = 'C' and
   lpatipa.status = 'C' and
   lpaprti_mod.status = 'C' and
   lpatitl.status = 'C'
