# Audit - Vicmap Property Address
I noted once that this audit query may take a long time to run.

Below is an attempt to make the query more efficient. However, in testing in Spatialite-GUI, it's actually slower than the original query.

There may be other potential improvements, including reprojecting the table before querying it.

```
select
    *,
    property_area / property_mbr_area as cohesion
from
(
select
    *,
    area ( geometry ) as property_area,
    area ( envelope ( geometry ) ) as property_mbr_area
from
(
select
    property_pfi,
    propnum,
    multi_assessment,
    status,
    address_pfi,
    ezi_address,
    ifnull ( ( select edit_code from m1 where m1.propnum = vpa.propnum and vpa.propnum <> '' limit 1 ) , '' ) as m1_edit_code,
    ifnull ( ( select comments from m1 where m1.propnum = vpa.propnum and vpa.propnum <> '' limit 1 ) , '' ) as m1_comments,
    st_transform ( geometry , 3111 ) as geometry
from pc_vicmap_property_address vpa
)
)
```
