# Dandenong

### Parcel query

Copied from Stonnington, with minor variations based on Dandenong's existing PIQA query.

Also remove parts of the query that had not bearing on the end result:

```sql
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
--    left join techone_nucassociation T on A.key1 = T.key1 and A.key2 = t.key2 and
--    T.association_type = 'TransPRLD' and A.date_ended is null
where
    A.association_type = 'PropLand' and
    A.date_ended is null and
--    L.plan_desc in ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' , 'RP' , 'CG' )
--    and t.key1 is null and
    P.status in ( 'C' , 'F' )
```

### Property Address query

Copied from Stonnington, with variations based on Dandenong's existing PIQA query.

