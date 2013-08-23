select
    'Vicmap parcel ' || vicmap_parcel.spi || ' may be recorded in Council property system as ' || council_parcel.spi as comments,
    vicmap_parcel.propnum as vicmap_propnum,       
    vicmap_parcel.crefno as vicmap_crefno,       
    vicmap_parcel.plan_number as vicmap_plan_number,       
    vicmap_parcel.lot_number as vicmap_lot_number
from
    PC_Vicmap_Parcel vicmap_parcel,    
    PC_Council_Parcel council_parcel
where
    vicmap_parcel.propnum = council_parcel.propnum and    
    ( vicmap_parcel.crefno <> '' or vicmap_parcel.spi in ( select spi from PC_Vicmap_Parcel_Property_Parcel_Count where num_parcels_in_prop = 1 ) ) and 
    vicmap_parcel.crefno = council_parcel.crefno and 
    vicmap_parcel.simple_spi <> council_parcel.simple_spi and    
    vicmap_parcel.plan_number is not null