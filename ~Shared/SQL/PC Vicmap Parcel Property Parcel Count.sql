select
    spi,  
    vicmap_property_parcel_count.num_parcels as num_parcels_in_prop
from
    PC_Vicmap_Parcel vicmap_parcel,    
    PC_Vicmap_Property_Parcel_Count vicmap_property_parcel_count
where
    spi is not null and    
    vicmap_parcel.propnum = vicmap_property_parcel_count.propnum
order by plan_number, lot_number