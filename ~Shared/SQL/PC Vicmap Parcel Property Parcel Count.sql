select 
    vicmap_parcel.spi as spi,
    vicmap_parcel.status as status,
    max ( vicmap_property_parcel_count.num_parcels ) as num_parcels_in_prop
from
    pc_vicmap_parcel vicmap_parcel,
    pc_vicmap_property_parcel_count vicmap_property_parcel_count
where
    vicmap_parcel.propnum <> '' and
    vicmap_parcel.propnum = vicmap_property_parcel_count.propnum
group by spi
order by spi