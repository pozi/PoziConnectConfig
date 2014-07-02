select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            allotment || portion ||
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
            allotment || portion ||
            case when sec <> '' then '~' || sec else '' end ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select 
    P.ASSESSMENT_ID as propnum,
    P.PROPERTY_TYPE as status,
    '' as crefno,
    ifnull ( L.DESCRIPTION_1 || '; ' , '' ) || P.ASSESS_DESCRIPTION as summary,
    ifnull ( upper ( L.PART_PARCEL ) , '' ) as part,
    case
        when substr ( trim ( L.PLAN_REF ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( L.PLAN_TYPE_CODE ) || L.PLAN_REF
        else trim ( L.PLAN_TYPE_CODE) || substr ( trim ( L.PLAN_REF ) , 1 , length ( trim ( L.PLAN_REF ) ) - 1 )
    end as plan_number,
    ifnull ( L.PLAN_TYPE_CODE , '' ) as plan_prefix,
    case
        when substr ( trim ( L.PLAN_REF ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.PLAN_REF
        else substr ( trim ( L.PLAN_REF ) , 1 , length ( trim ( L.PLAN_REF ) ) - 1 )
    end as plan_numeral,
    case
        when L.PARCEL_TYPE_CODE = 'RES' then 'RES' || L.PARCEL_REF
        else ifnull ( L.PARCEL_REF , '' )
    end as lot_number,
    ifnull ( L.ALLOTMENT_REF , '' ) as allotment,
    ifnull ( L.SECTION_REF , '' ) as sec,
    ifnull ( L.BLOCK_REF , '' ) as block,
    ifnull ( L.PORTION_REF , '' ) as portion,
    '' as subdivision,
    '' as parish_code,
    '' as township_code,
    '341' as lga_code
from
    fujitsu_pr_parcel L
    join fujitsu_pr_parcel_xref A on L.PARCEL_ID = A.PARCEL_ID
    join fujitsu_pr_assessment P on A.ASS_INTERNAL_ID = P.ASS_INTERNAL_ID 
where
    trim ( L.PLAN_TYPE_CODE in ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' , 'RP' , 'CG' ) ) and
    ifnull ( L.FORMER_TITLE , '' ) <> 'Y' and
    P.RATING_ZONE in ( '1' , '4' , '5' , '9' )
)
order by propnum, crefno
