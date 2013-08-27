select 
    vicmap_parcel.spi as spi,
    vicmap_parcel.status as status,
    max ( vicmap_property_parcel_count.num_parcels ) as num_parcels_in_prop
from
    PC_Vicmap_Parcel vicmap_parcel,
    PC_Vicmap_Property_Parcel_Count vicmap_property_parcel_count
where
    vicmap_parcel.propnum <> '' and
    vicmap_parcel.propnum = vicmap_property_parcel_count.propnum
group by spi
order by spi