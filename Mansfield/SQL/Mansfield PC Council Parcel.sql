select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when constructed_spi <> '' then 'council_attributes'
        when internal_spi <> '' then 'council_spi'
        else ''
    end as source,
    case
        when constructed_spi <> '' then constructed_spi
        when internal_spi <> '' then internal_spi
        else ''
    end as spi
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
    end as constructed_spi
from
(
select
    parcels.assess_no as propnum,
    ifnull ( dolapins.pin , '' ) as crefno,
    ifnull ( parcels.survey_no , '' ) as internal_spi,
    parcels.land_parcel as summary,
    '' as status,
    case
        when parcels.lot_no like '%PT%' then 'P'
        else ''
    end as part,
    case
        when substr ( part_location , 1 , 2 ) in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then substr ( replace ( part_location , ' ' , '' ) , 1 , 8 )
        else ''
    end as plan_number,
    case
        when substr ( part_location , 1 , 2 ) in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then substr ( part_location , 1 , 2 )
        else ''
    end as plan_prefix,
    case
        when substr ( part_location , 1 , 2 ) in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then substr ( replace ( part_location , ' ' , '' ) , 3 , 6 )
        else ''
    end as plan_numeral,
    case
        when substr ( part_location , 1 , 2 ) in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then
            case
                when parcels.lot_no like '%RESERVE%' then replace ( replace ( parcels.lot_no , 'RESERVE' , 'RES' ) , ' ' , '' )
                when parcels.lot_no like '%RES%' then replace ( upper ( parcels.lot_no ) , ' ' , '' )
                else ifnull ( trim ( replace ( parcels.lot_no , 'PT' , '' ) ) , '' )
            end
        else ''
    end as lot_number,
    case
        when substr ( upper ( part_location ) , 1 , 2 ) in ( 'CA' , 'PP' ) then ifnull ( trim ( replace ( parcels.lot_no , 'PT' , '' ) ) , '' )
        when part_location is null then ifnull ( trim ( replace ( replace ( parcels.lot_no , 'CA' , '' ) , 'PT' , '' ) ) , '' )
        else ''
    end as allotment,
    case
        when location = 'NO SEC' then ''
        when location like 'BL%' then ''
  		  when substr ( upper ( part_location ) , 1 , 2 ) in ( 'CA' , 'PP' , 'LP' ) then ifnull ( location , '' )
       else ''
  	end as sec,
    case
        when location like 'BL%' then replace ( location , 'BL' , '' )
        when parcels.part_lot like 'BL%' then replace ( parcels.part_lot , 'BL' , '' )
        else ''
    end as block,
    '' as portion,
    '' as subdivision,
    case district
        when 'BARWITE' then '2086'
        when 'BEOLITE' then '2121'
        when 'BINNUC' then '2154'
        when 'BOOROLITE' then '2194'
        when 'BORODOMANIN' then '2207'
        when 'BRANKEET' then '2221'
        when 'CAMBATONG' then '2324'
        when 'CHANGUE' then '2369'
        when 'CHANGUE EAST' then '2370'
        when 'DARLINGFORD' then '2491'
        when 'DELATITE' then '2506'
        when 'DOOLAM' then '2536'
        when 'DUERAN' then '2556'
        when 'DUERAN EAST' then '2557'
        when 'EILDON' then '2580'
        when 'ENOCHS POINT' then '2593'
        when 'GARRATANBUNELL' then '2635'
        when 'GOBUR' then '2693'
        when 'GONZAGA' then '2696'
        when 'GOULBURN' then '2713'
        when 'HOWITT PLAINS' then '2767'
        when 'HOWQUA' then '2768'
        when 'HOWQUA WEST' then '2769'
        when 'JAMIESON' then '2780'
        when 'KEVINGTON' then '2868'
        when 'KNOCKWOOD' then '2891'
        when 'KOONIKA' then '2909'
        when 'LAURAVILLE' then '2978'
        when 'LAZARINI' then '2982'
        when 'LICOLA NORTH' then '2992'
        when 'LODGE PARK' then '3008'
        when 'LOYOLA' then '3019'
        when 'MAGDALA' then '3030'
        when 'MAGDALA SOUTH' then '3031'
        when 'MAINDAMPLE' then '3037'
        when 'MAINTONGOON' then '3038'
        when 'MANSFIELD' then '3056'
        when 'MATLOCK' then '3073'
        when 'MERRIJIG' then '3094'
        when 'MERTON' then '3098'
        when 'MIRIMBAH' then '3121'
        when 'MOOLPAH' then '3156'
        when 'MOORNGAG' then '3174'
        when 'NARBOURAC' then '3264'
        when 'NILLAHCOOTIE' then '3309'
        when 'ST. CLAIR' then '3464'
        when 'STANDER' then '3497'
        when 'TALLANGALLOOK' then '3529'
        when 'TARLDARN' then '3550'
        when 'THORNTON' then '3587'
        when 'TOOMBULLUP' then '3623'
        when 'TOO-ROUR' then '3633'
        when 'TOOROUR' then '3633'
        when 'WALLAGOOT' then '3705'
        when 'WAPPAN' then '3734'
        when 'WARRAMBAT' then '3751'
        when 'WONDOOMAROOK' then '3859'
        else ''
    end as parish_code,
    case district
        when 'BONNIE DOON T/SHIP' then '5096'
        when 'CASTLE POINT T/SHIP' then '5164'
        when 'DARLINGFORD T/SHIP' then '5225'
        when 'HOWQUA T/SHIP' then '5388'
        when 'JAMIESON T/SHIP' then '5395'
        when 'MAINDAMPLE T/SHIP' then '5491'
        when 'MANSFIELD T/SHIP' then '5500'
        when 'MATLOCK T/SHIP' then '5511'
        when 'MERRIJIG T/SHIP' then '5522'
        when 'MERTON T/SHIP' then '5524'
        when 'PIRIES T/SHIP' then '5638'
        when 'TALLANGALLOOK T/SHIP' then '5756'
        when 'TOLMIE T/SHIP' then '5785'
        when 'WOODS POINT T/SHIP' then '5878'
        when 'T/SHIP WOODS POINT' then '5878'
        else ''
    end as township_code,
    '382' as lga_code,
    parcels.assess_no as assnum
from
    synergysoft_vw_pozi_parcels_properties as parcels left join
    synergysoft_property_id_dolapins as dolapins on parcels.land_parcel = dolapins.land_parcel and dolapins.mv = 1 left join
    synergysoft_properties as properties on parcels.assess_no = properties.assess_no
where
    properties.rate_code not in ( '07' , '08' , '11' , '12' , '99' )
)
)
)
