select
    *
from
    PC_Vicmap_Parcel
where
    spi not in ( select spi from PC_Council_Parcel where spi is not null ) 