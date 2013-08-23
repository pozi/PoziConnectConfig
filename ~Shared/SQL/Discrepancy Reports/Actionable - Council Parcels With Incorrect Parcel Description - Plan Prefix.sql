select
    'Council''s parcel description uses plan prefix ' || council_parcel.plan_prefix || ' but the corrent plan prefix in Vicmap is ' || vicmap_parcel.plan_prefix as comments,
    council_parcel.propnum as council_propnum,
    council_parcel.crefno as council_crefno,
    council_parcel.spi as council_spi,    
    council_parcel.plan_prefix as council_plan_prefix,
    vicmap_parcel.plan_prefix as vicmap_plan_prefix,
    vicmap_parcel.spi as vicmap_spi,
    vicmap_parcel.propnum as vicmap_propnum,
    vicmap_parcel.crefno as vicmap_crefno
from
    PC_Council_Parcel council_parcel,
    PC_Vicmap_Parcel vicmap_parcel
where
    council_parcel.simple_spi = vicmap_parcel.simple_spi and    
    council_parcel.spi <> vicmap_parcel.spi and
    council_parcel.spi not in ( select spi from PC_Vicmap_Parcel where spi <> '' )
