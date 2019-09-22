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
select
    cast ( cast ( lraassm.assmnumber as integer ) as varchar ) as propnum,
    '' as status,
    cast ( lpaparc.tpklpaparc as varchar ) as crefno,
    '' as internal_spi,
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
        when lpaparc.fmtparcel like '%CA%' then ''
        else ifnull ( replace ( lpaparc.parcelnum , ' ' , '' ) , '' )
    end as lot_number,
    case
        when lpaparc.plancode in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        when ifnull ( lpaparc.parcelnum , '' ) <> '' then replace ( lpaparc.parcelnum , ' ' , '' )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ? *' then substr ( lpaparc.fmtparcel , 9 , 1 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ?? *' then substr ( lpaparc.fmtparcel , 9 , 2 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ??? *' then substr ( lpaparc.fmtparcel , 9 , 3 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ???? *' then substr ( lpaparc.fmtparcel , 9 , 4 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ????? *' then substr ( lpaparc.fmtparcel , 9 , 5 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ?' then substr ( lpaparc.fmtparcel , 9 , 1 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ??' then substr ( lpaparc.fmtparcel , 9 , 2 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ???' then substr ( lpaparc.fmtparcel , 9 , 3 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ????' then substr ( lpaparc.fmtparcel , 9 , 4 )
        when upper ( lpaparc.fmtparcel ) glob 'CA PART ?????' then substr ( lpaparc.fmtparcel , 9 , 5 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ? *' then substr ( lpaparc.fmtparcel , 9 , 1 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ?? *' then substr ( lpaparc.fmtparcel , 9 , 2 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ??? *' then substr ( lpaparc.fmtparcel , 9 , 3 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ???? *' then substr ( lpaparc.fmtparcel , 9 , 4 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ????? *' then substr ( lpaparc.fmtparcel , 9 , 5 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ?' then substr ( lpaparc.fmtparcel , 9 , 1 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ??' then substr ( lpaparc.fmtparcel , 9 , 2 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ???' then substr ( lpaparc.fmtparcel , 9 , 3 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ????' then substr ( lpaparc.fmtparcel , 9 , 4 )
        when upper ( lpaparc.fmtparcel ) glob 'PART CA ?????' then substr ( lpaparc.fmtparcel , 9 , 5 )
        when upper ( lpaparc.fmtparcel ) glob 'CA ? *' then substr ( lpaparc.fmtparcel , 4 , 1 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ?? *' then substr ( lpaparc.fmtparcel , 4 , 2 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ??? *' then substr ( lpaparc.fmtparcel , 4 , 3 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ???? *' then substr ( lpaparc.fmtparcel , 4 , 4 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ????? *' then substr ( lpaparc.fmtparcel , 4 , 5 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ?' then substr ( lpaparc.fmtparcel , 4 , 1 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ??' then substr ( lpaparc.fmtparcel , 4 , 2 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ???' then substr ( lpaparc.fmtparcel , 4 , 3 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ????' then substr ( lpaparc.fmtparcel , 4 , 4 )    
        when upper ( lpaparc.fmtparcel ) glob 'CA ?????' then substr ( lpaparc.fmtparcel , 4 , 5 )    
        else ''    
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case upper ( lpadesc.descr )
        when 'ANGORA' then '2016'
        when 'BAAWANG' then '2036'
        when 'BAIRNSDALE' then '2042'
        when 'BARGA' then '2070'
        when 'BELOKA' then '2109'
        when 'BEMM' then '2112'
        when 'BENDOCK' then '2116'
        when 'BENGWORDEN' then '2118'
        when 'BERRMARR' then '2129'
        when 'BETE BELONG NORTH' then '2134'
        when 'BETE BELONG SOUTH' then '2135'
        when 'BETKA' then '2136'
        when 'BIDWELL' then '2139'
        when 'BINDI' then '2148'
        when 'BINGO-MUNJIE' then '2150'
        when 'BINGO-MUNJIE NORTH' then '2151'
        when 'BINGO-MUNJIE SOUTH' then '2152'
        when 'BINNICAN' then '2153'
        when 'BONANG' then '2176'
        when 'BONDI' then '2177'
        when 'BOOLE POOLE' then '2184'
        when 'BOONDEROOT' then '2189'
        when 'BOORPUK' then '2199'
        when 'BRALAK' then '2217'
        when 'BRAMBY' then '2219'
        when 'BRINDAT' then '2232'
        when 'BROADLANDS' then '2236'
        when 'BUCHAN' then '2244'
        when 'BULLAMALK' then '2259'
        when 'BULLUMWAAL' then '2267'
        when 'BUMBERRAH' then '2270'
        when 'BUNDARA-MUNJIE' then '2273'
        when 'BUNGYWARR' then '2286'
        when 'CABANANDRA' then '2319'
        when 'CHILPIN' then '2380'
        when 'COBBANNAH' then '2393'
        when 'COBON' then '2395'
        when 'COBUNGRA' then '2398'
        when 'COLQUHOUN' then '2412'
        when 'COLQUHOUN EAST' then '2413'
        when 'COLQUHOUN NORTH' then '2414'
        when 'COMBIENBAR' then '2416'
        when 'COOAGGALAH' then '2428'
        when 'COONGULMERANG' then '2436'
        when 'COOPRACAMBRA' then '2440'
        when 'CURLIP' then '2473'
        when 'DEDDICK' then '2504'
        when 'DELLICKNORA' then '2507'
        when 'DERNDANG' then '2514'
        when 'DETARKA' then '2517'
        when 'DOODWUK' then '2533'
        when 'ENANO' then '2591'
        when 'ENSAY' then '2594'
        when 'ERRINUNDRA' then '2598'
        when 'EUCAMBENE' then '2601'
        when 'EUMANA' then '2602'
        when 'GABO' then '2626'
        when 'GELANTIPY EAST' then '2642'
        when 'GELANTIPY WEST' then '2643'
        when 'GILLINGAL' then '2654'
        when 'GLENALADALE' then '2663'
        when 'GLENMORE' then '2681'
        when 'GOOLENGOOK' then '2697'
        when 'GOON NURE' then '2702'
        when 'GOONGERAH' then '2701'
        when 'GUNGARLAN' then '2735'
        when 'GUTTAMURRA' then '2738'
        when 'HINNOMUNJIE' then '2759'
        when 'INGEEGOODBEE' then '2773'
        when 'JILWAIN' then '2799'
        when 'JINDERBOINE' then '2800'
        when 'JINGALLALA' then '2802'
        when 'JIRNKEE' then '2804'
        when 'JIRRAH' then '2805'
        when 'KAERWUT' then '2816'
        when 'KARAWAH' then '2838'
        when 'KARLO' then '2841'
        when 'KIANEEK' then '2873'
        when 'KIRKENONG' then '2888'
        when 'KOOLA' then '2905'
        when 'KOOMBERAR' then '2907'
        when 'KOORAGAN' then '2911'
        when 'KOOROON' then '2918'
        when 'KOWAT' then '2934'
        when 'KUARK' then '2937'
        when 'LOCHIEL' then '3005'
        when 'LOOMAT' then '3013'
        when 'LOONGELAAT' then '3014'
        when 'LUDRIK-MUNJIE' then '3021'
        when 'MALLACOOTA' then '3044'
        when 'MANEROO' then '3052'
        when 'MARAMINGO' then '3058'
        when 'MARLOO' then '3064'
        when 'MARROO' then '3070'
        when 'MELLICK-MUNJIE' then '3085'
        when 'MOONIP' then '3159'
        when 'MOONKAN' then '3160'
        when 'MOORMURNG' then '3172'
        when 'MOORNAPA' then '3173'
        when 'MOREKANA' then '3189'
        when 'MOWAMBA' then '3203'
        when 'MURRINDAL EAST' then '3235'
        when 'MURRINDAL WEST' then '3236'
        when 'MURRUNGOWER' then '3240'
        when 'NAPPA' then '3262'
        when 'NERRAN' then '3299'
        when 'NEWMERELLA' then '3306'
        when 'NINDOO' then '3311'
        when 'NINNIE' then '3313'
        when 'NOONGA' then '3319'
        when 'NOORINBEE' then '3321'
        when 'NOWA NOWA' then '3325'
        when 'NOWA NOWA SOUTH' then '3326'
        when 'NOWYEO' then '3329'
        when 'NOYONG' then '3330'
        when 'NUMBIE-MUNJIE' then '3335'
        when 'NUNGAL' then '3338'
        when 'NUNGATTA' then '3339'
        when 'NUNNIONG' then '3340'
        when 'NURONG' then '3344'
        when 'OMEO' then '3352'
        when 'ONYIM' then '3354'
        when 'ORBOST' then '3355'
        when 'ORBOST EAST' then '3356'
        when 'PINNAK' then '3398'
        when 'PURGAGOOLAH' then '3425'
        when 'SARSFIELD' then '3476'
        when 'SUGGAN BUGGAN' then '3510'
        when 'TABBARA' then '3518'
        when 'TABBERABERRA' then '3519'
        when 'TAMBO' then '3534'
        when 'TAMBOON' then '3535'
        when 'TERLITE-MUNJIE' then '3576'        
        when 'THEDDORA' then '3583'
        when 'THORKIDAAN' then '3585'
        when 'THURRA' then '3589'
        when 'TILDESLEY EAST' then '3591'
        when 'TILDESLEY WEST' then '3592'
        when 'TIMBARRA' then '3593'
        when 'TINGARINGY' then '3598'
        when 'TONGARO' then '3603'
        when 'TONGHI' then '3605'
        when 'TONGIO-MUNJIE EAST' then '3606'
        when 'TONGIO-MUNJIE WEST' then '3607'
        when 'TOONGINBOOKA' then '3628'
        when 'TOONYARAK' then '3629'
        when 'TUBBUT' then '3652'        
        when 'TYIRRA' then '3672'
        when 'WAMBA' then '3718'
        when 'WANGARABELL' then '3724'
        when 'WAT WAT' then '3778'
        when 'WAU WAUKA' then '3779'
        when 'WAU WAUKA WEST' then '3780'
        when 'WAYGARA' then '3781'
        when 'WEERAGUA' then '3785'
        when 'WENTWORTH' then '3794'
        when 'WIBENDUCK' then '3813'
        when 'WINDARRA' then '3833'
        when 'WINGAN' then '3835'
        when 'WINYAR' then '3844'
        when 'WOLLONABY' then '3856'
        when 'WULGULMERANG EAST' then '3882'
        when 'WULGULMERANG WEST' then '3883'
        when 'WOOYOOT' then '3897'
        when 'WUK WUK' then '3908'
        when 'WURRIN' then '3911'
        when 'WY YUNG' then '3925'
        when 'WYANGIL' then '3915'
        when 'YALMY' then '3938'
        when 'YAMBULLA' then '3943'
        when 'YARAK' then '3956'
        when 'YONDUK' then '3994'
        else ''
    end as parish_code,
    case upper ( trim ( lpadesc.descr ) )
        when 'BENAMBRA TOWNSHIP' then '5067'
        when 'BROOKVILLE TOWNSHIP' then '5116'
        when 'CASSILIS TOWNSHIP' then '5161'
        when 'ENSAY TOWNSHIP' then '5282'
        when 'GLEN WILLS TOWNSHIP' then '5329'
        when 'STIRLING TOWNSHIP' then '5732'
        when 'SUNNYSIDE TOWNSHIP' then '5745'
        when 'SWIFTS CREEK TOWNSHIP' then '5750'
        when 'TONGIO-MUNJIE TOWNSHIP' then '5787'
        when 'TONGIO-WEST TOWNSHIP' then '5788'        
        else ''
    end as township_code,
    '319' as lga_code,
    cast ( cast ( lraassm.assmnumber as integer ) as varchar ) as assnum
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaprti as lpaprti on lpaprop.tpklpaprop = lpaprti.tfklpaprop left join
    pathway_lpatitl as lpatitl on lpaprti.tfklpatitl = lpatitl.tpklpatitl left join
    pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc left join
    pathway_lpadesc as lpadesc on lpadepa.tfklpadesc = lpadesc.tpklpadesc left join
    pathway_lparole as lparole on lpaprop.tpklpaprop = lparole.tfklocl left join
    pathway_lraassm as lraassm on lparole.tfkappl = lraassm.tpklraassm
where
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H' and
    lraassm.applicatn = 'R' and
    lparole.fklparolta = 'LRA' and
    lparole.fklparoltn = 0 and
    ifnull ( lpaparc.plancode , '' ) in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' )
)
)