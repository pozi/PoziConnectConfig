select spi, crefno, 'C'
from PC_Council_Parcel
where
    spi in ( select spi from PC_Vicmap_Parcel where crefno is null ) and    
    crefno <> ''