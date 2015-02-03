select
    spi as spi,
    crefno as crefno,
    propnum as propnum,
    summary as summary,
    status as status,
    case
        when plan_number like '%&%' or plan_number like '% %' or plan_number like '%-%' or ( plan_numeral <> '' and substr ( plan_numeral , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) ) then 'Invalid: plan number contains invalid character (' || plan_number || ')'
        when lot_number like '%&%' or lot_number like '% %' or lot_number like '%-%' then 'Invalid: lot number contains invalid character (' || lot_number || ')'
        when allotment like '%&%' or allotment like '% %' or allotment like '%-%' then 'Invalid: allotment contains invalid character (' || allotment || ')'
        when sec like '%&%' or sec like '% %' or sec like '%-%' then 'Invalid: sec contains invalid character (' || sec || ')'
        when block like '%&%' or block like '% %' or block like '%-%' then 'Invalid: block contains invalid character (' || block || ')'
        when portion like '%&%' or portion like '% %' or portion like '%-%' then 'Invalid: portion contains invalid character (' || portion || ')'
        when subdivision like '%&%' or subdivision like '% %' or subdivision like '%-%' then 'Invalid: subdivision contains invalid character (' || subdivision || ')'
        when plan_prefix not in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then 'Invalid: plan prefix (' || plan_prefix || ')'
        when plan_prefix = '' and plan_numeral <> '' then 'Invalid: plan prefix missing for plan ' || plan_number
        when plan_prefix in ( 'CS' , 'LP' , 'PS' , 'RP' , 'SP' ) and lot_number = '' then 'Invalid: lot number missing for ' || plan_prefix
        when plan_prefix in ( 'CP' , 'PC' ) and lot_number <> '' then 'Invalid: lot number not valid for ' || plan_prefix
        when plan_prefix = 'CP' and not ( ( 100000 <= cast ( plan_numeral as integer ) <= 109999 ) or ( 150000 <= plan_numeral <= 199999 ) ) then 'Invalid: plan number not in valid range for CP (' || plan_number || ')'
        when plan_prefix = 'CS' and not ( 1000 <= cast ( plan_numeral as integer ) <= 10000 ) then 'Invalid: plan number not in valid range for CS (' || plan_number || ')'
        when plan_prefix = 'LP' and not ( ( 1 <= cast ( plan_numeral as integer ) <= 99999 ) or ( 110000 <= cast ( plan_numeral as integer ) <= 149999 ) or ( 200000 <= cast ( plan_numeral as integer ) <= 299999 ) ) then 'Invalid: plan number not in valid range for LP (' || plan_number || ')'
        when plan_prefix = 'PC' and not ( ( 350001 <= cast ( plan_numeral as integer ) <= 400000 ) or ( 450001 <= cast ( plan_numeral as integer ) <= 500000 ) or ( 550001 <= cast ( plan_numeral as integer ) <= 600000 ) or ( 600001 <= cast ( plan_numeral as integer ) <= 650000 ) ) then 'Invalid: plan number not in valid range for PC (' || plan_number || ')'
        when plan_prefix = 'PS' and not ( ( 300001 <= cast ( plan_numeral as integer ) <= 350000 ) or ( 400001 <= cast ( plan_numeral as integer ) <= 450000 ) or ( 500001 <= cast ( plan_numeral as integer ) <= 550000 ) or ( 600001 <= cast ( plan_numeral as integer ) <= 650000 ) ) then 'Invalid: plan number not in valid range for PS (' || plan_number || ')'
        when plan_prefix = 'RP' and not ( cast ( plan_numeral as integer ) <= 19926 ) then 'Invalid: plan number not in valid range for RP (' || plan_number || ')'
        when plan_prefix = 'SP' and not ( 19927 <= cast ( plan_numeral as integer ) <= 40000 ) then 'Invalid: plan number not in valid range for SP (' || plan_number || ')'
        when parish_code <> '' and ( cast ( parish_code as integer ) < 2000 or cast ( parish_code as integer ) > 3999 ) then 'Invalid: parish number not in valid range (' || parish_code || ')'
        when township_code not in ( '' , '9999' ) and not ( substr ( township_code , 1 , 1 ) in ('2','3') and substr ( township_code , -1 ) in ('A','B','C','D','E','F','G','H','I','J','K') ) and ( cast ( township_code as integer ) < 5000 or cast ( township_code as integer ) > 5999 ) then 'Invalid: township number not in valid range (' || township_code || ')'
        when plan_numeral like '0%' then 'Invalid: plan number contains leading zero (' || plan_number || ')'
        when spi like '\PP%' or spi like '~%\PP%' then 'Invalid: allotment missing for crown description'
        when spi like '\%' or length ( spi ) < 5 then 'Invalid: parcel description not recognised'
        else ''
    end as spi_validity,
    ifnull ( ( select count(*) from pc_council_parcel x where x.spi = cp.spi and length ( cp.spi ) >= 5 ) , '' ) as spi_in_council,
    substr ( ifnull ( ( select group_concat ( propnum , ';' ) from pc_council_parcel x where x.spi = cp.spi and length ( cp.spi ) >= 5 ) , '' ) , 1 , 99 ) as council_propnums,
    ifnull ( ( select count(*) from pc_vicmap_parcel vp where vp.spi = cp.spi and length ( cp.spi ) >= 5 ) , 0 ) as spi_in_vicmap,
    ifnull ( ( select count(*) from pc_vicmap_parcel vp where vp.spi = cp.spi and vp.propnum = cp.propnum and length ( cp.spi ) >= 5 ) , 0 ) as spi_propnum_in_vicmap,
    substr ( ifnull ( ( select group_concat ( propnum , ';' ) from pc_vicmap_parcel vpx where vpx.spi = cp.spi and length ( cp.spi ) >= 5 ) , 0 ) , 1 , 99 ) as vicmap_propnums,
    ifnull ( ( select count(*) from pc_vicmap_parcel vp where vp.simple_spi = cp.simple_spi and vp.spi <> cp.spi and length ( cp.spi ) >= 5 ) , 0 ) as partial_spi_in_vicmap,
    ifnull ( ( select count(*) from pc_vicmap_parcel vp where vp.further_description = cp.spi and length ( cp.spi ) >= 5 ) , 0 ) as alt_spi_in_vicmap,
    case
        when cp.spi not in ( select spi from pc_vicmap_parcel ) then
            case
                when cp.simple_spi in ( select simple_spi from pc_vicmap_parcel ) then ( select spi from pc_vicmap_parcel vp where vp.simple_spi = cp.simple_spi )
                when cp.crefno <> '' and cp.crefno in ( select crefno from pc_vicmap_parcel ) then ( select spi from pc_vicmap_parcel vp where vp.crefno = cp.crefno )
                when ( select num_parcels from pc_vicmap_property_parcel_count vpppc where vpppc.propnum = cp.propnum ) = 1 then ( select spi from pc_vicmap_parcel vp where vp.propnum = cp.propnum )
                else ''
            end
        else ''
    end as suggested_spi,
    ifnull ( ( select num_parcels from pc_council_property_parcel_count cppc where cppc.propnum = cp.propnum ) , 0 ) as propnum_in_council,
    ifnull ( ( select num_parcels from pc_vicmap_property_parcel_count vppc where vppc.propnum = cp.propnum ) , 0 ) as propnum_in_vicmap,
    case cp.crefno
        when '' then ''
        else ifnull ( ( select count(*) from ( select distinct spi from pc_vicmap_parcel vp where vp.crefno = cp.crefno  ) ) , 0 )
    end as crefno_in_vicmap,
    ifnull ( ( select edit_code from M1 where ( m1.spi = cp.spi and length ( cp.spi ) >= 5 ) or m1.propnum = cp.propnum limit 1 ) , '' ) as m1_edit_code,
    ifnull ( ( select comments from M1 where ( m1.spi = cp.spi and length ( cp.spi ) >= 5 ) or m1.propnum = cp.propnum limit 1 ) , '' ) as m1_comments,
    cp.*,
    ifnull ( ( select ezi_address from pc_council_property_address cpa where cpa.propnum = cp.propnum and cpa.is_primary <> 'N' limit 1 ) , '' ) as council_address,
    ( select vp.geometry from pc_vicmap_parcel vp where vp.spi = cp.spi limit 1 ) as geometry
from pc_council_parcel cp

