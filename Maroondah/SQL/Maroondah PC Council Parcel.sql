select
    *,
    spi as constructed_spi,
    'council_attributes' as spi_source,
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
    '' as crefno,
    '' as internal_spi,
    ifnull ( lpaparc.fmtparcel , '' ) as summary,
    case
        when lpaparc.plancode = 'PP' then ''
        else ifnull ( lpaparc.plancode , '' )
    end ||
        case
            when lpaparc.plancode = 'PP' then ''
            when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then lpaparc.plannum
            when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 ) 
            else ''
        end as plan_number,
    case
        when lpaparc.plancode = 'PP' then ''  
        else ifnull ( lpaparc.plancode , '' )
    end as plan_prefix,
    case
        when lpaparc.plancode = 'PP' then ''
        when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then lpaparc.plannum
        when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 )
        else ''
    end as plan_numeral,
    case
        when lpaparc.plancode = 'PP' then ''
        else ifnull ( lpaparc.parcelnum , '' ) 
    end as lot_number,
    case
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum not like '%~%' then  ifnull (lpaparc.parcelnum , '' )              
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,2,1) = '~' then substr (lpaparc.parcelnum,2,-9)    
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,3,1) = '~' then substr (lpaparc.parcelnum,3,-9)        
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,4,1) = '~' then substr (lpaparc.parcelnum,4,-9)        
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,5,1) = '~' then substr (lpaparc.parcelnum,5,-9)        
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,6,1) = '~' then substr (lpaparc.parcelnum,6,-9)
        else '' 
    end as allotment,    
    case    
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,1,1) = '~' then substr (lpaparc.parcelnum,2,9) 
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,2,1) = '~' then substr (lpaparc.parcelnum,3,9)    
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,3,1) = '~' then substr (lpaparc.parcelnum,4,9)        
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,4,1) = '~' then substr (lpaparc.parcelnum,5,9)        
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,5,1) = '~' then substr (lpaparc.parcelnum,6,9)        
        when lpaparc.plancode = 'PP' and lpaparc.parcelnum like '%~%' and substr (lpaparc.parcelnum,6,1) = '~' then substr (lpaparc.parcelnum,7,9)
        else ''
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when lpaparc.plancode = 'PP' and substr (lpaparc.plannum , 1 , 1 ) in ( '2', '3', '4')  then lpaparc.plannum
        else ''
    end as parish_code,
    case
        when lpaparc.plancode = 'PP' and substr (lpaparc.plannum , 1 , 1 ) in ( '5' ) then lpaparc.plannum
        else ''
    end as township_code,
    '342' as lga_code,
    cast ( lpaprop.tpklpaprop as varchar ) as assnum
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    pathway_cnacomp as cnacomp on lpaaddr.tfkcnacomp = cnacomp.tpkcnacomp left join
    pathway_lpaprti_mod as lpaprti_mod on lpaprop.tpklpaprop = lpaprti_mod.tfklpaprop left join
    pathway_lpatitl as lpatitl on lpaprti_mod.tfklpatitl = lpatitl.tpklpatitl left join
    pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left join
    pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc
where
   lpaprop.status in ( 'A' , 'C' ) and
   lpaparc.status in ( 'A' , 'C' ) and
   lpatipa.status in ( 'A' , 'C' ) and
   lpaprti_mod.status in ( 'A' , 'C' ) and
   lpatitl.status in ( 'A' , 'C' )
)
)