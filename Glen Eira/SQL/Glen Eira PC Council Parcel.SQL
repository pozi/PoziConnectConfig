select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
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
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_numeral
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
    cast ( cast ( lraassm.assmnumber as integer ) as varchar ) as propnum,
    lpaparc.status as status,
    '' as crefno,
    ifnull ( lpaparc.fmtparcel , '' ) as summary,
    case
        when lpaparc.plannum is null then cast (null as varchar)
        else cast ( trim (lpaparc.plancode ) ||
            case
                when substr ( trim ( lpaparc.plannum ) , -1 ) > '9' and substr ( trim ( lpaparc.plannum ) , 1 ) <> '0' then substr ( lpaparc.plannum , 1 , ( length ( trim ( plannum ) ) -1 ) )
                when substr ( trim ( lpaparc.plannum ) , 2 ) = '00'  then substr ( lpaparc.plannum , 3 , 99 )
                when substr ( trim ( lpaparc.plannum ) , 1 ) = '0'  then substr ( lpaparc.plannum , 2 , 99 )
                else trim ( lpaparc.plannum )
            end as varchar)
    end as plan_number,
    ifnull ( lpaparc.plancode , '' ) as plan_prefix,
    case
        when substr ( trim ( lpaparc.plannum ) , -1 ) > '9' and substr ( trim ( lpaparc.plannum ) , 1 ) <> '0' then substr ( lpaparc.plannum , 1 , ( length ( trim ( plannum ) ) -1 ) )
        when substr ( trim ( lpaparc.plannum ) , 2 ) = '00'  then substr ( lpaparc.plannum , 3 , 99 )
        when substr ( trim ( lpaparc.plannum ) , 1 ) = '0'  then substr ( lpaparc.plannum , 2 , 99 )
        else trim ( lpaparc.plannum )
    end as plan_numeral,
    ifnull ( lpaparc.parcelnum , '' ) as lot_number,
    ifnull ( lpaparc.parcelnum , '' ) as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    '' as parish_code,
    '' as township_code,
    '322' as lga_code
from
   pathway_lpaprop as lpaprop left outer join
   pathway_lpaprti as lpaprti on lpaprop.tpklpaprop = lpaprti.tfklpaprop left outer join
   pathway_lpatipa as lpatipa on lpaprti.tfklpatitl = lpatipa.tfklpatitl left outer join
   pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left outer join
   pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left outer join
   pathway_lparole as lparole on lpaprop.tpklpaprop = lparole.tfklocl left outer join
   pathway_lraassm as lraassm on lparole.tfkappl = lraassm.tpklraassm  
where
   lpaparc.status <> 'H' and   
   lraassm.applicatn = 'R' and
   lpaprop.tfklpacncl = 13
)