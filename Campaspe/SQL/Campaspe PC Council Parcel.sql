select
    *,
    case
        when summary <> '' then summary
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
        when summary <> '' then case
            when substr ( summary , 2 , 1 ) = '\' then substr ( summary , 1 , 1 ) || '\' || substr ( summary , 5 , 99 )
            when substr ( summary , 3 , 1 ) = '\' then substr ( summary , 1 , 2 ) || '\' || substr ( summary , 6 , 99 )
            when substr ( summary , 4 , 1 ) = '\' then substr ( summary , 1 , 3 ) || '\' || substr ( summary , 7 , 99 )
            when substr ( summary , 5 , 1 ) = '\' then substr ( summary , 1 , 4 ) || '\' || substr ( summary , 8 , 99 )
            when substr ( summary , 6 , 1 ) = '\' then substr ( summary , 1 , 5 ) || '\' || substr ( summary , 9 , 99 )
            when substr ( summary , 7 , 1 ) = '\' then substr ( summary , 1 , 6 ) || '\' || substr ( summary , 10 , 99 )
            when substr ( summary , 8 , 1 ) = '\' then substr ( summary , 1 , 7 ) || '\' || substr ( summary , 11 , 99 )
            else summary end
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
    cast ( cast ( P.ASS_INTERNAL_ID as integer ) as varchar ) as propnum,
    '' as status,
    '' as crefno,
    ifnull ( upper ( L.SPI_REF ) , '' ) as summary,
    ifnull ( upper ( L.PART_PARCEL ) , '' ) as part,
    case
        when substr ( L.PLAN_REF , 1 , 4 ) = '0000' then ifnull ( trim ( L.PLAN_TYPE_CODE) , '' ) || substr ( L.PLAN_REF , 5 , 99 )
        when substr ( L.PLAN_REF , 1 , 3 ) = '000' then ifnull ( trim ( L.PLAN_TYPE_CODE) , '' ) || substr ( L.PLAN_REF , 4 , 99 )
        when substr ( L.PLAN_REF , 1 , 2 ) = '00' then ifnull ( trim ( L.PLAN_TYPE_CODE) , '' ) || substr ( L.PLAN_REF , 3 , 99 )
        when substr ( L.PLAN_REF , 1 , 1 ) = '0' then ifnull ( trim ( L.PLAN_TYPE_CODE) , '' ) || substr ( L.PLAN_REF , 2 , 99 )
        when substr ( trim ( L.PLAN_REF ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then ifnull ( trim ( L.PLAN_TYPE_CODE ) , '' ) || L.PLAN_REF
        else ifnull ( trim ( L.PLAN_TYPE_CODE) || substr ( trim ( L.PLAN_REF ) , 1 , length ( trim ( L.PLAN_REF ) ) - 1 ) , '' )
    end as plan_number,
    ifnull ( L.PLAN_TYPE_CODE , '' ) as plan_prefix,
    case
        when substr ( L.PLAN_REF , 1 , 4 ) = '0000' then substr ( L.PLAN_REF , 5 , 99 )
        when substr ( L.PLAN_REF , 1 , 3 ) = '000' then substr ( L.PLAN_REF , 4 , 99 )
        when substr ( L.PLAN_REF , 1 , 2 ) = '00' then substr ( L.PLAN_REF , 3 , 99 )
        when substr ( L.PLAN_REF , 1 , 1 ) = '0' then substr ( L.PLAN_REF , 2 , 99 )
        when substr ( trim ( L.PLAN_REF ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then ifnull ( L.PLAN_REF , '' )
        else ifnull ( substr ( trim ( L.PLAN_REF ) , 1 , length ( trim ( L.PLAN_REF ) ) - 1 ) , '' )
    end as plan_numeral,
    case
        when L.PARCEL_TYPE_CODE = 'RES' then 'RES' || ifnull ( L.PARCEL_REF , '' )
        else replace ( ifnull ( L.PARCEL_REF , '' ) , ' ' , '' )
    end as lot_number,
    ifnull ( L.ALLOTMENT_REF , '' ) as allotment,
    case
        when L.PLAN_TYPE_CODE in ( 'CS' , 'CP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        else ifnull ( L.SECTION_REF , '' )
    end as sec,
    case
        when L.PLAN_TYPE_CODE in ( 'CS' , 'CP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        else ifnull ( L.BLOCK_REF , '' )
    end as block,
    ifnull ( L.PORTION_REF , '' ) as portion,
    '' as subdivision,
    ifnull ( cast ( cast ( L.PARISH_CODE as integer ) as varchar ) , '' ) as parish_code,
    ifnull ( cast ( cast ( L.TOWNSHIP_CODE as integer ) as varchar ) , '' ) as township_code,
    '310' as lga_code
from
    fujitsu_pr_parcel L
    join fujitsu_pr_parcel_xref A on L.PARCEL_ID = A.PARCEL_ID
    join fujitsu_pr_assessment P on A.ASS_INTERNAL_ID = P.ASS_INTERNAL_ID and
    P.DELETE_FLAG is null
where
    ifnull ( L.FORMER_TITLE , '' ) <> 'Y'
)
order by propnum, crefno
