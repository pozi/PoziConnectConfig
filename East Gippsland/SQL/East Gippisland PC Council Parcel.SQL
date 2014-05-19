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

select
    lpaprop.tpklpaprop as propnum,
    '' as status,
--    cast ( lpaprac.tpklpaprop as varchar ) as crefno,
    ifnull ( lpaparc.fmtparcel , '' ) as summary,

--   cast (lpatitl.tpklpatitl as varchar ) as TITLEREF,
--   cast (lpaparc.parcelcode as varchar ) as PARCELCODE,
--   case
--      when trim(lpaparc.parcelcode) = 'L' THEN 
--          cast(lpaparc.parcelnum as varchar(8)) 
--      else cast(lpacrwn.crownallot as varchar ) + '~' + cast(lpasect.parcelsect as varchar(2)) 
--   end as PARCEL,
--   case
--      when trim(lpaparc.parcelcode) = 'L' THEN 
--          cast(lpaparc.plancode as varchar(2)) + cast(lpaparc.plannum as varchar(8))
--      else ''
--   end as PLAN,

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
        when lpaparc.parcelcode = 'RES' then 'RES' || ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpaparc.parcelnum , '' )
    end as lot_number,
    ifnull ( lpaparc.parcelnum , '' ) as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case trim ( lpadesc.tpklpadesc )
        when 'ANGORA' then 'PP2016'
        when 'BAAWANG' then 'PP2036'
        when 'BAIRNSDALE' then 'PP2042'
        when 'BARGA' then 'PP2070'
        when 'BELOKA' then 'PP2109'
        when 'BEMM' then 'PP2112'
        when 'BENDOCK' then 'PP2116'
        when 'BENGWORDEN' then 'PP2118'
        when 'BERRMARR' then 'PP2129'
        when 'BETE BOLONG NORTH' then 'PP2134'
        when 'BETE BOLONG SOUTH' then 'PP2135'
        when 'BETKA' then 'PP2136'
        when 'BIDWELL' then 'PP2139'
        when 'BINDI' then 'PP2148'
        when 'BINGO MUNJIE' then 'PP2150'
        when 'BINGO MUNJIE NORTH' then 'PP2151'
        when 'BINGO MUNJIE SOUTH' then 'PP2152'
        when 'BINNICAN' then 'PP2153'
        when 'BONANG' then 'PP2176'
        when 'BONDI' then 'PP2177'
        when 'BOOLE POOLE' then 'PP2184'
        when 'BOONDEROOT' then 'PP2189'
        when 'BOORPUK' then 'PP2199'
        when 'BRALAK' then 'PP2217'
        when 'BRAMBY' then 'PP2219'
        when 'BRINDAT' then 'PP2232'
        when 'BROADLANDS' then 'PP2236'
        when 'BUCHAN' then 'PP2244'
        when 'BULLAMALK' then 'PP2259'
        when 'BULLUMWAAL' then 'PP2267'
        when 'BUMBERRAH' then 'PP2270'
        when 'BUNDARA MUNJIE' then 'PP2273'
        when 'BUNGYWARR' then 'PP2286'
        when 'CABANNANDRA' then 'PP2319'
        when 'CHILPIN' then 'PP2380'
        when 'COBBANNAH' then 'PP2393'
        when 'COBON' then 'PP2395'
        when 'COBUNGRA' then 'PP2398'
        when 'COLQUHOUN' then 'PP2412'
        when 'COLQUHOUN EAST' then 'PP2413'
        when 'COLQUHOUN NORTH' then 'PP2414'
        when 'COMBIENBAR' then 'PP2416'
        when 'COOAGGALAH' then 'PP2428'
        when 'COONGULMERANG' then 'PP2436'
        when 'COOPRACAMBRA' then 'PP2440'
        when 'CURLIP' then 'PP2473'
        when 'DEDDICK' then 'PP2504'
        when 'DELLICKNORA' then 'PP2507'
        when 'DERNDANG' then 'PP2514'
        when 'DETARKA' then 'PP2517'
        when 'DOODWUK' then 'PP2533'
        when 'ENANO' then 'PP2591'
        when 'ENSAY' then 'PP2594'
        when 'ERRINUNDRA' then 'PP2598'
        when 'EUCAMBENE' then 'PP2601'
        when 'EUMANA' then 'PP2602'
        when 'GABO' then 'PP2626'
        when 'GELANTIPY EAST' then 'PP2642'
        when 'GELANTIPY WEST' then 'PP2643'
        when 'GILLINGALL' then 'PP2654'
        when 'GLENALADALE' then 'PP2663'
        when 'GLENMORE' then 'PP2681'
        when 'GOOLENGOOK' then 'PP2697'
        when 'GOON NURE' then 'PP2702'
        when 'GOONGERAH' then 'PP2701'
        when 'GUNGARLAN' then 'PP2735'
        when 'GUTTAMURRA' then 'PP2738'
        when 'HINNO MUNJIE' then 'PP2759'
        when 'INGEEGOODBEE' then 'PP2773'
        when 'JILWAIN' then 'PP2799'
        when 'JINDERBOINE' then 'PP2800'
        when 'JINGALLALA' then 'PP2802'
        when 'JIRNKEE' then 'PP2804'
        when 'JIRRAH' then 'PP2805'
        when 'KAERWUT' then 'PP2816'
        when 'KARAWAH' then 'PP2838'
        when 'KARLO' then 'PP2841'
        when 'KIANEEK' then 'PP2873'
        when 'KIRKENONG' then 'PP2888'
        when 'KOOLA' then 'PP2905'
        when 'KOOMBERAR' then 'PP2907'
        when 'KOORAGAN' then 'PP2911'
        when 'KOOROON' then 'PP2918'
        when 'KOWAT' then 'PP2934'
        when 'KUARK' then 'PP2937'
        when 'LOCHIEL' then 'PP3005'
        when 'LOOMAT' then 'PP3013'
        when 'LOONGELAAT' then 'PP3014'
        when 'LUDRIK-MUNJIE' then 'PP3021'
        when 'MALLACOOTA' then 'PP3044'
        when 'MANEROO' then 'PP3052'
        when 'MARAMINGO' then 'PP3058'
        when 'MARLOOH' then 'PP3064'
        when 'MARROO' then 'PP3070'
        when 'MELLICK MUNJIE' then 'PP3085'
        when 'MOONIP' then 'PP3159'
        when 'MOONKAN' then 'PP3160'
        when 'MOORMURNG' then 'PP3172'
        when 'MOREKANA' then 'PP3189'
        when 'MOWAMBA' then 'PP3203'
        when 'MURRINDAL EAST' then 'PP3235'
        when 'MURRINDAL WEST' then 'PP3236'
        when 'MURRUNGOWAR' then 'PP3240'
        when 'NAPPA' then 'PP3262'
        when 'NERRAN' then 'PP3299'
        when 'NEWMERELLA' then 'PP3306'
        when 'NINDOO' then 'PP3311'
        when 'NINNIE' then 'PP3313'
        when 'NOONGA' then 'PP3319'
        when 'NOORINBEE' then 'PP3321'
        when 'NOWA NOWA' then 'PP3325'
        when 'NOWA NOWA SOUTH' then 'PP3326'
        when 'NOWYEO' then 'PP3329'
        when 'NOYONG' then 'PP3330'
        when 'NUMBIE MUNJIE' then 'PP3335'
        when 'NUNGAL' then 'PP3338'
        when 'NUNGATTA' then 'PP3339'
        when 'NUNNIONG' then 'PP3340'
        when 'NURONG' then 'PP3344'
        when 'OMEO' then 'PP3352'
        when 'ONYIM' then 'PP3354'
        when 'ORBOST' then 'PP3355'
        when 'ORBOST EAST' then 'PP3356'
        when 'PINNAK' then 'PP3398'
        when 'PURGAGOOLAH' then 'PP3425'
        when 'SARSFIELD' then 'PP3476'
        when 'SUGGAN BUGGAN' then 'PP3510'
        when 'TABBARA' then 'PP3518'
        when 'TABBERABBERA' then 'PP3519'
        when 'TAMBO' then 'PP3534'
        when 'TAMBOON' then 'PP3535'
        when 'TERLITE-MUNJIE' then 'PP3576'
        when 'THORKIDAAN' then 'PP3585'
        when 'THURRA' then 'PP3589'
        when 'TILDESLEY EAST' then 'PP3591'
        when 'TILDESLEY WEST' then 'PP3592'
        when 'TIMBARRA' then 'PP3593'
        when 'TINGARINGY' then 'PP3598'
        when 'TONGARO' then 'PP3603'
        when 'TONGHI' then 'PP3605'
        when 'TONGIO-MUNJIE-EAST' then 'PP3606'
        when 'TONGIO-MUNJIE-WEST' then 'PP3607'
        when 'TOONGINBOOKA' then 'PP3628'
        when 'TOONYARAK' then 'PP3629'
        when 'TUBBUT' then 'PP3652'
        when 'WAMBA' then 'PP3718'
        when 'WANGARABELL' then 'PP3724'
        when 'WAT WAT' then 'PP3778'
        when 'WAU WAUKA' then 'PP3779'
        when 'WAU WAUKA WEST' then 'PP3780'
        when 'WAYGARA' then 'PP3781'
        when 'WEERAGUA' then 'PP3785'
        when 'WENTWORTH' then 'PP3794'
        when 'WIBENDUCK' then 'PP3813'
        when 'WINDARRA' then 'PP3833'
        when 'WINGAN' then 'PP3835'
        when 'WINYAR' then 'PP3844'
        when 'WOLLONABY' then 'PP3856'
        when 'WOONGULMERANG EAST' then 'PP3882'
        when 'WOONGULMERANG WEST' then 'PP3883'
        when 'WOOYOOT' then 'PP3897'
        when 'WUK WUK' then 'PP3908'
        when 'WURRIN' then 'PP3911'
        when 'WY-YUNG' then 'PP3925'
        when 'WYANGIL' then 'PP3915'
        when 'YALMY' then 'PP3938'
        when 'YAMBULLA' then 'PP3943'
        when 'YARAK' then 'PP3956'
        when 'YONDUK' then 'PP3994'
        else ''
    end as parish_code,
    '' as township_code,
    '319' as lga_code
from
   pathway_lpaprop as lpaprop left join 
   pathway_lpaprti as lpaprti on lpaprop.tpklpaprop = lpaprti.tfklpaprop left join 
   pathway_lpatitl as lpatitl on lpaprti.tfklpatitl = lpatitl.tpklpatitl left join 
   pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join 
   pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join 
   pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpatipa.tfklpaparc left join 
   pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join 
   pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc left join
   pathway_lpadesc as lpadesc on lpadepa.tfklpadesc = lpadesc.tpklpadesc 
where
   lpaprop.status = 'C' and 
   lpaparc.status = 'C' and
   lpatipa.status = 'C' and
   lpaprti.status = 'C' and
   lpatitl.status = 'C'
)
