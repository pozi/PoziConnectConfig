select
    spi as council_spi,
    summary as council_summary,
    status as council_status,
    crefno as council_crefno,
     case
        when length ( spi ) < 6 then 'N'        
        when plan_numeral like '0%' then 'N'
        when lot_number like '%&%' then 'N'
        when not ( spi like 'CP%' or spi like '%\CS%' or spi like '%\LP%' or spi like 'PC%' or spi like '%\PP%' or spi like '%\PS%' or spi like '%\SP%' or spi like '%\TP%' ) then 'N'
        else ''        
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

