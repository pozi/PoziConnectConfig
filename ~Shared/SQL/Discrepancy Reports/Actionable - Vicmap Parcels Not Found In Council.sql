select
    'Vicmap parcel ' || spi || ' is not found in the Council property system' as comments,
    *
from
    PC_Vicmap_Parcel
where
    spi <> '' and
    simple_spi not in ( select PC_Council_Parcel.simple_spi from PC_Council_Parcel where PC_Council_Parcel.simple_spi <> '' ) and
    propnum <> 'NCPR'    
order by propnum desc, plan_number, lot_number