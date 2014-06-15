select
    cp.*,
    vp.geometry as geometry
from
    pc_council_parcel cp left join pc_vicmap_parcel vp on cp.spi = vp.spi and vp.spi <> ''
group by
    cp.rowid
