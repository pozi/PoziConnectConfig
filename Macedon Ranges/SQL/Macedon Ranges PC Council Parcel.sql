select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi,
    case
        when plan_numeral <> '' and lot_number = '' then plan_numeral
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_numeral
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select distinct
    lpaprop.tpklpaprop as propnum,
    '' as status,
    '' as crefno,
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
        when lpaparc.parcelcode in ( 'CA' , 'PTCA' ) then ''
        when lpaparc.parcelcode = 'RES' then 'RES' || ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpaparc.parcelnum , '' )     
    end as lot_number,
    case    
        when lpaparc.parcelcode = 'CA' and lpaparc.fmtparcel like 'CA%' then trim ( substr ( replace ( replace ( lpaparc.fmtparcel , ' ' , '     ' ) , 'CA' , '' ) , 1, 10 ) )
        when lpaparc.parcelcode = 'PTCA' and lpaparc.fmtparcel like 'PTCA%' then trim ( substr ( replace ( replace ( lpaparc.fmtparcel , ' ' , '     ' ) , 'PTCA' , '' ) , 1, 10 ) )
        else ''
    end as allotment,    
    ifnull ( lpasect.parcelsect , '' ) as sec,
    ifnull ( cnacomp.descrsrch , '' ) as parish_code,
    '' as township_code,
    '339' as lga_code
from
    Pathway_lpaprop as lpaprop left join
    Pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    Pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    Pathway_cnacomp as cnacomp on lpaaddr.tfkcnacomp = cnacomp.tpkcnacomp left join
    Pathway_lpaprti_mod as lpaprti_mod on lpaprop.tpklpaprop = lpaprti_mod.tfklpaprop left join
    Pathway_lpatitl as lpatitl on lpaprti_mod.tfklpatitl = lpatitl.tpklpatitl left join
    Pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    Pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    Pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left join
    Pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    Pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc
where
   lpaprop.status = 'C' and
   lpaparc.status = 'C' and
   lpatipa.status = 'C' and
   lpaprti_mod.status = 'C' and
   lpatitl.status = 'C'
)