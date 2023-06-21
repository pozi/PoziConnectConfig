select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when internal_spi <> '' then internal_spi
        else constructed_spi
    end as spi,
    case
        when internal_spi <> '' then 'council_spi'
        else 'council_attributes'
    end as spi_source
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
    cast ( P.prop_id as varchar ) as propnum,
    cast ( L.land_id as varchar ) as crefno,
    case
        when L.land_text_3 like '%CA' then ''
        else ifnull ( L.land_text_3 , '' )
    end as internal_spi,
    ifnull ( fmt_legal_desc , '' ) as summary,
    case L.land_status_ind
        when 'F' then 'P'
        else ''
    end as status,
    '' as part,
    case
	    when L.parcel_desc = 'CA' then ''
        else ifnull ( L.plan_desc , '' ) || ifnull ( L.plan_no , '' )
    end as plan_number,
    case
	    when L.parcel_desc = 'CA' then ''
        else ifnull ( L.plan_desc , '' )
    end as plan_prefix,
    case
	    when L.parcel_desc = 'CA' then ''
        else ifnull ( L.plan_no , '' )
    end as plan_numeral,
    case
	    when L.parcel_desc = 'CA' then ''
        else ifnull ( upper ( L.lot ) , '' )
	end as lot_number,
    case
	    when L.parcel_desc = 'LOT' then ''
        else ifnull ( upper ( L.lot ) , '' )
	end as allotment,
    ifnull ( upper ( L.section_for_lot ) , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case l.parish_desc
        when 'CORINELLA' then '2453'
        when 'DRUMDLEMAR' then '2551'
        when 'FRENCH ISL' then '2621'
        when 'JEETHO WES' then '2788'
        when 'JUMBUNNA' then '2809'
        when 'JUMBUNNA E' then '2810'
        when 'KIRRAK' then '2889'
        when 'KONGWAK' then '2901'
        when 'LANG LANGE' then '2969'
        when 'LANGLANG' then '2968'
        when 'PHILLIP IS' then '3389'
        when 'TARWIN' then '3563'
        when 'WONTHAGGI' then '3866'
        when 'WONTHAGGIN' then '3867'
        when 'WOOLAMAI' then '3878'
        else ''
	end as parish_code,
    case l.land_text_1
        when 'BASS' then '5053'
        when 'CORINELLA' then '5198'
        when 'COWES' then '5204'
        when 'COWES - AT' then '3389A'
        when 'GRANTVILLE' then '5348'
        when 'INVERLOCH' then '5393'
        when 'JAM JERRUP' then '5396'
        when 'KILCUNDA' then '5418'
        when 'NEWHAVEN' then '5590'
        when 'RHYLL' then '5674'
        when 'SAN REMO' then '5699'
        when 'VENTNOR' then '5814'
        when 'WONTHAGGI' then '5871'
        when 'WOOLAMAI' then '5880'
		else ''
	end as township_code,
    '304' as lga_code,
    ifnull ( vol , '' ) as volume,
    ifnull ( folio , '' ) as folio,
    cast ( P.prop_id as varchar ) as assnum
from
    techone_land L
    join techone_association A on L.land_id = A.entity_id2 and L.land_status_ind in ( 'C' , 'F')
    join techone_property P on A.entity_id1 = P.prop_id
where
    A.association_type = '$PROPLAND' and
    ifnull ( A.date_ended , '' ) in ( '' , '1899/12/31' ) and
    P.prop_status_ind in ( 'C' , 'F' )
)
)
)
