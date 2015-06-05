# Edit Code ‘S’ (Proposed)

### Rule

Edit Code S updates address details for a given record. It requires that the Address – Road and Locality Information columns are populated as required including the Address – Location attributes for creating spatially located address points.

## SQL

[M1 S Proposed Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20S%20Proposed%20Edits.sql)

Limit results to only one per property number. If there is more than one property that matches, give preference to the one whose address doesn't already appear in Vicmap. (This query has been written to avoid using 'order by' due to a syntax error that's specific to Pozi Connect.)

```sql
cpa.propnum in
    ( select propnum from
        ( select cpx.propnum,
            max ( case
                when cpax.ezi_address not in ( select ezi_address from pc_vicmap_property_address ) then 1
                else 0
            end )
        from
            pc_council_parcel cpx,
            pc_council_property_address cpax
        where
            cpx.propnum = cpax.propnum and
            cpx.spi = vp.spi
        )
    )
```

## Developer Notes

The limiting of one record per property number was introduced because Baw Baw observed multiple address updates per parcel. We wanted to exclude the address that belongs to the 'parent' property, which is already in Vicmap.