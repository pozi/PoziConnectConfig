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
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as crefno,
    ifnull ( lpaparc.plancode || ': ' , '' ) || ifnull ( trim ( lpaparc.fmtparcel ) , '' ) as summary,
    case
        when lpaparc.plancode is null or lpaparc.plancode in ( 'PT-CA' , 'PP' ) then ''
        else ifnull ( replace ( lpaparc.plancode , 'PT-' , '' ) , '' ) || ifnull ( lpaparc.plannum , '' )
    end as plan_number,
    case
        when lpaparc.plancode is null or lpaparc.plancode in ( 'PT-CA' , 'PP' ) then ''
        else ifnull ( replace ( lpaparc.plancode , 'PT-' , '' ) , '' )
    end as plan_prefix,
    case
        when lpaparc.plancode is null or lpaparc.plancode in ( 'PT-CA' , 'PP' ) then ''
        else ifnull ( lpaparc.plannum , '' )
    end as plan_numeral,
    case
        when lpaparc.plancode is null or lpaparc.plancode in ( 'PT-CA' , 'PP' ) then ''
        when lpaparc.parcelcode = 'COMM' then 'CM' || ifnull ( lpaparc.parcelnum , '' )
        when lpaparc.parcelcode = 'RES' then 'RES' || ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpaparc.parcelnum , '' )
    end as lot_number,
    case
        when lpaparc.plancode is null or lpaparc.plancode in ( 'PT-CA' , 'PP' ) then ifnull ( trim ( lpacrwn.crownallotr ) , '' )
        else ''
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when lpaparc.plancode is null or lpaparc.plancode in ( 'PT-CA' , 'PP' ) then
            case
                when substr ( plannum , 1 , 1 ) in ( '2' , '3' ) then plannum
                when lpaparc.fmtparcel like '%PSH BURGOYNE%' then '2292'
                when lpaparc.fmtparcel like '%PSH BURGOYNE%' then '2292'
                when lpaparc.fmtparcel like '%PSH GREENSBOROUGH%' then '2724'
                when lpaparc.fmtparcel like '%PSH KEELBUNDORA%' then '2856'
                when lpaparc.fmtparcel like '%PSH KINGLAKE%' then '2881'
                when lpaparc.fmtparcel like '%PSH LINTON%' then '3000'
                when lpaparc.fmtparcel like '%PSH MORANG%' then '3183'
                when lpaparc.fmtparcel like '%PSH NILLUMBIK%' then '3310'
                when lpaparc.fmtparcel like '%PSH QUEENSTOWN%' then '3437'
                when lpaparc.fmtparcel like '%PSH SUTTON%' then '3513'
                else ''
            end
        else ''
    end as parish_code,
    case
        when lpaparc.plancode is null or lpaparc.plancode in ( 'PT-CA' , 'PP' ) then
            case
                when substr ( plannum , 1 , 1 ) = '5' then plannum
                when lpaparc.fmtparcel like '%T/S WARRANDYTE NORTH%' then '5838'
                when lpaparc.fmtparcel like '%T/S SUTTON%' then '3513'
                when lpaparc.fmtparcel like '%T/S DIAMOND CREEK%' then '5242'
                when lpaparc.fmtparcel like '%T/S ELTHAM%' then '5279'
                when lpaparc.fmtparcel like '%T/S PANTON HILL%' then '5626'
                when lpaparc.fmtparcel like '%T/S QUEENSTOWN%' then '5662'
                when lpaparc.fmtparcel like '%T/S SMITHS GULLY%' then '5720'
                when lpaparc.fmtparcel like '%T/S WARRANDYTE%' then '5837'
                else ''
            end
        else ''
    end as township_code,
    '356' as lga_code
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
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc
where
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H' and
    lpaparc.fmtparcel <> 'Valuers Master Header'
)