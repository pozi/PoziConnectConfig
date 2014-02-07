select
    spi as council_spi,
    summary as council_summary,
    status as council_status,
    crefno as council_crefno,
    case
        when spi like '\%' then 'N'
        when length ( spi ) < 6 then 'N'        
        when plan_numeral like '0%' then 'N'
        when plan_numeral <> '' and substr ( plan_numeral , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then 'N'
        when lot_number like '%&%' or lot_number like '% %' or lot_number like '%-%' then 'N'
        when not ( spi like 'CP%' or spi like '%\CS%' or spi like '%\LP%' or spi like 'PC%' or spi like '%\PP%' or spi like '%\PS%' or spi like '%\SP%' or spi like '%\TP%' ) then 'N'
        when plan_prefix = 'CP' and not ( ( 100000 <= plan_numeral <= 109999 ) or ( 150000 <= plan_numeral <= 199999 ) ) then 'N'
        when plan_prefix = 'CS' and not ( 1000 <= plan_numeral <= 10000 ) then 'N'        
        when plan_prefix = 'LP' and not ( ( 1 <= plan_numeral <= 99999 ) or ( 110000 <= plan_numeral <= 149999 ) or ( 200000 <= plan_numeral <= 299999 ) ) then 'N'
        when plan_prefix = 'PC' and not ( ( 350001 <= plan_numeral <= 400000 ) or ( 450001 <= plan_numeral <= 500000 ) or ( 550001 <= plan_numeral <= 600000 ) or ( 600001 <= plan_numeral <= 650000 ) ) then 'N'
        when plan_prefix = 'PS' and not ( ( 300001 <= plan_numeral <= 350000 ) or ( 400001 <= plan_numeral <= 450000 ) or ( 500001 <= plan_numeral <= 550000 ) or ( 600001 <= plan_numeral <= 650000 ) ) then 'N'
        when plan_prefix = 'RP' and not ( plan_numeral <= 19926 ) then 'N'        
        when plan_prefix = 'SP' and not ( 19927 <= plan_numeral <= 40000 ) then 'N'        
        else 'Y'        
   end as council_spi_valid_format,
   ifnull ( ( select num_props from PC_Council_Parcel_Property_Count cppc where cppc.spi = cp.spi ) , 0 ) as num_council_props,
    propnum as council_propnum,
    '' spi_match_in_vicmap,
    '' partial_spi_match_in_vicmap,
    case ( select count(*) from pc_vicmap_parcel vp where vp.further_description = cp.spi and cp.spi <> '' )
        when 0 then 'N'
        when 1 then 'Y'
        else '(multiple)'
    end as alternative_spi_match_in_vicmap,
    ifnull ( ( select num_props from PC_Vicmap_Parcel_Property_Count vppc where vppc.spi = cp.spi ) , 0 ) as num_vicmap_props,
    ifnull ( ( select crefno from PC_Vicmap_Parcel vp where vp.spi = cp.spi ) , '' ) as vicmap_crefno,
    case ( select num_props from PC_Vicmap_Parcel_Property_Count vppc where vppc.spi = cp.spi )
        when 0 then '(none)'
        when 1 then ( select propnum from PC_Vicmap_Parcel vp where vp.spi = cp.spi )
        else '(multiple)'
    end as vicmap_propnum,
    ifnull ( ( select edit_code from M1 where m1.spi = cp.spi limit 1 ) , '' ) as current_m1
from PC_Council_Parcel cp
where spi <> ''
order by ( case plan_number when '' then 'zzz' else plan_number end ) , parish_code, township_code, sec, lot_number, allotment

