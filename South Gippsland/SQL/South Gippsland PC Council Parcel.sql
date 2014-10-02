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
    cast ( lpaparc.tpklpaparc as varchar ) as crefno,
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
    case 
        when ifnull ( lpaparc.parcelnum , '' ) = '' and lpaparc.parcelcode = 'CM' then 'CM'
        when ifnull ( lpaparc.parcelnum , '' ) <> '' and ifnull ( lpaparc.plannum , '' ) = '' then ''
        else ifnull ( lpaparc.parcelnum , '' )
    end as lot_number,
    case 
        when ifnull ( lpaparc.parcelnum , '' ) <> '' and ifnull ( lpaparc.plannum , '' ) = '' then ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpacrwn.crownallot , '' ) 
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case    
        when lpadesc.descr = 'Allambee' then '2010'
        when lpadesc.descr = 'Allambee East' then '2011'
        when lpadesc.descr = 'Beek Beek' then '2100'
        when lpadesc.descr = 'Doomburrim' then '2537'
        when lpadesc.descr = 'Drumdlemara' then '2551'
        when lpadesc.descr = 'Dumbalk' then '2559'
        when lpadesc.descr = 'Gunyah Gunyah' then '2736'
        when lpadesc.descr = 'Jeetho' then '2787'
        when lpadesc.descr = 'Jeetho West' then '2788'
        when lpadesc.descr = 'Jumbunna' then '2809'
        when lpadesc.descr = 'Jumbunna East' then '2810'
        when lpadesc.descr = 'Kirrak' then '2889'
        when lpadesc.descr = 'Kongwak' then '2901'
        when lpadesc.descr = 'Koorooman' then '2917'
        when lpadesc.descr = 'Korumburra' then '2929'
        when lpadesc.descr = 'Kulk' then '2938'
        when lpadesc.descr = 'Lang Lang' then '2968'
        when lpadesc.descr = 'Lang Lang East' then '2969'
        when lpadesc.descr = 'Leongatha' then '2987'
        when lpadesc.descr = 'Longwarry' then '3011'
        when lpadesc.descr = 'Mardan' then '3059'
        when lpadesc.descr = 'Meeniyan' then '3077'
        when lpadesc.descr = 'Mirboo' then '3119'
        when lpadesc.descr = 'Mirboo South' then '3120'
        when lpadesc.descr = 'Narracan South' then '3273'
        when lpadesc.descr = 'Nerrena' then '3300'
        when lpadesc.descr = 'Poowong' then '3411'
        when lpadesc.descr = 'Poowong East' then '3412'
        when lpadesc.descr = 'Tallang' then '3528'
        when lpadesc.descr = 'Tarwin' then '3563'
        when lpadesc.descr = 'Tarwin Sth' then '3564'
        when lpadesc.descr = 'Toora' then '3630'
        when lpadesc.descr = 'Waratah' then '3736'
        when lpadesc.descr = 'Waratah North' then '3737'
        when lpadesc.descr = 'Warreen' then '3758'
        when lpadesc.descr = 'Welshpool' then '3790'
        when lpadesc.descr = 'Wonga Wonga' then '3862'
        when lpadesc.descr = 'Wonga Wonga South' then '3863'
        when lpadesc.descr = 'Woorarra' then '3885'
        when lpadesc.descr = 'Yanakie' then '3945'
        when lpadesc.descr = 'Yanakie South' then '3946'    
        else ''
    end as parish_code,    
    case    
        when lpadesc.descr = 'Bennison Township' then '5072'
        when lpadesc.descr = 'Darlimurla Township' then '5224'
        when lpadesc.descr = 'Foster Township' then '5296'
        when lpadesc.descr = 'Hedley Township' then '5375'
        when lpadesc.descr = 'Koonwarra Township' then '5429'
        when lpadesc.descr = 'Korumburra Township' then '5434'
        when lpadesc.descr = 'Leongatha Township' then '5460'
        when lpadesc.descr = 'Meeniyan Township' then '5513'
        when lpadesc.descr = 'Mirboo North Township' then '5537'
        when lpadesc.descr = 'Poowong Township' then '5644'
        when lpadesc.descr = 'Port Welshpool Township' then '5652'
        when lpadesc.descr = 'Stony Creek Township' then '5734'
        when lpadesc.descr = 'Tarwin Lower Township' then '5770'
        when lpadesc.descr = 'Walkerville Township' then '5820'
        when lpadesc.descr = 'Nyora Township' then '5613'       
        else ''
    end as township_code,
    '361' as lga_code
from
    pathway_lpaprop as lpaprop left outer join
    pathway_lpaprti as lpaprti on lpaprop.tpklpaprop = lpaprti.tfklpaprop left outer join
    pathway_lpatipa as lpatipa on lpaprti.tfklpatitl = lpatipa.tfklpatitl left outer join
    pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left outer join
    pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left outer join    
    pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left outer join    
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc left outer join    
    pathway_lpadesc as lpadesc on lpadepa.tfklpadesc = lpadesc.tpklpadesc

where
    lpaprop.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaparc.status <> 'H' and
    lpaprop.tfklpacncl = 13 and
    ifnull ( lpaparc.plancode , '' ) <> 'AG'
)