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
select distinct
    cast ( cast ( lraassm.assmnumber as integer ) as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as crefno,
    case lpaparc.parcelcode
        when 'LOT PT' then 'P'
        else ''
    end as part,
    ifnull ( lpaparc.plancode || ': ' , '' ) || ifnull ( trim ( lpaparc.fmtparcel ) , '' ) as summary,
    case
        when lpaparc.plancode is null or lpaparc.plancode = 'CA' then ''
        when lpaparc.plannum like 'R%' then 'RP' || replace ( replace ( lpaparc.plannum , 'RP' , '' ) , 'R' , '' )
        when lpaparc.plannum like 'CS%' then 'CS' || replace ( lpaparc.plannum , 'CS' , '' )
        when substr ( plannum , 1 , 1 ) in ( '1','2','3','4','5','6','7','8','9' ) then ifnull ( lpaparc.plancode , '' ) || cast ( cast ( lpaparc.plannum as integer ) as varchar )
        else ifnull ( lpaparc.plancode , '' ) || ifnull ( lpaparc.plannum , '' )
    end as plan_number,
    case
        when lpaparc.plancode is null or lpaparc.plancode = 'CA' then ''
        when lpaparc.plannum like 'R%' then 'RP'
        when lpaparc.plannum like 'CS%' then 'CS'
        else ifnull ( lpaparc.plancode , '' )
    end as plan_prefix,
    case
        when lpaparc.plancode is null or lpaparc.plancode = 'CA' then ''
        when lpaparc.plannum like 'R%' then replace ( replace ( lpaparc.plannum , 'RP' , '' ) , 'R' , '' )
        when lpaparc.plannum like 'CS%' then replace ( lpaparc.plannum , 'CS' , '' )
        when substr ( plannum , 1 , 1 ) in ( '1','2','3','4','5','6','7','8','9' ) then cast ( cast ( lpaparc.plannum as integer ) as varchar )
        else ifnull ( lpaparc.plannum , '' )
    end as plan_numeral,
    case
        when lpaparc.plancode is null or lpaparc.plancode = 'CA' then ''
        else replace ( ifnull ( lpaparc.parcelnum , '' ) , 'UT' , '' )
    end as lot_number,
    case
        when ( lpaparc.plancode = 'CA' or lpaparc.parcelcode = 'CA' ) and lpaparc.parcelnum is not null then lpaparc.parcelnum
        when ( lpaparc.plancode = 'CA' or lpaparc.parcelcode = 'CA' ) and lpaparc.plannum is not null then lpaparc.plannum
        else ''
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when plancode = 'CA' and plannum like '%3279%' then '3279'
        when plancode = 'CA' and plannum like '%3478%' then '3478'
        else ''
    end as parish_code,
    '' as township_code,
    '336' as lga_code,
    cast ( lpaprop.tpklpaprop as varchar ) as assnum
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
    pathway_lpapabl as lpapabl on lpaparc.tpklpaparc = lpapabl.tfklpaparc left join
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc left join
    pathway_lparole as lparole on lpaprop.tpklpaprop = lparole.tfklocl left join
    pathway_lraassm as lraassm on lparole.tfkappl = lraassm.tpklraassm left join
    pathway_lpaprtp as lpaprtp on lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp
where
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H' and
    lraassm.assmnumber is not null and
    lpaprtp.abbrev <> 'OBSOLETE' and
    not ( lpaprtp.abbrev = 'HEADER' and lpaparc.parcelnum not like 'CM%' ) and
    not ( lpaprtp.abbrev = 'PARENT' and lpaparc.parcelnum not like 'CM%' ) and
    not ( lraassm.status = 'H' and lpaparc.parcelnum not like 'CM%' )
)