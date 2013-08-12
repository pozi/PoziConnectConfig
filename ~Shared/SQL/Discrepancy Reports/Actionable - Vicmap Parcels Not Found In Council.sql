select
    *
from
    PC_Vicmap_Parcel
where
    simple_spi not in ( select PC_Council_Parcel.simple_spi as council_parcels from PC_Council_Parcel where PC_Council_Parcel.simple_spi is not null ) 