# Edit Code ‘R’

## DEPI

### Rule

Edit Code R is only used to remove a property from a Multi Assessment. The last record on a multi assessment cannot be retired.

#### Question to DEPI: If a multi-assessment contains five properties, and we submit R edits records for all five, will the first four succeed (or will they all fail)?

The current M1 loading software will identify that you are trying to retire all instances which fails validation rules and therefore no edits will occur ie all five edits will fail.

## Logic

Retire any multi-assessment associated with Vicmap Parcels where Vicmap `propnum` doesn't exist in Council Parcel with the same `spi`, except the last one.

## SQL

[M1 R Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20R%20Edits.sql)

Include only parcels that are actually multi-assessments.

```sql
multi_assessment = 'Y'
```

Include only parcels that have a valid parcel description.

```sql
spi <> ''
```

Include only parcels that don't have corresponding `propnum` and `spi` values in Council.

```sql
propnum not in ( select cp.propnum from PC_Council_Parcel cp where cp.spi = vp.spi )
```

Exclude the last record in the multi-assessment. This will ensure that the not all the records can be retired at once. Unfortunately this prevents us from targeting the last record for retirement.

```sql
property_pfi not in ( select max ( t.property_pfi ) from PC_Vicmap_Parcel t group by t.parcel_pfi )
```

## Development notes:

### Old Logic (probably no longer relevant)

Looking at all _multi-assessment_ Vicmap Parcels where Vicmap `propnum` doesn't exist in Council Parcel with the same `spi`:

* when Parcel is a single-parcel property, then null the _second and any subsequent_ `propnum` values
* when Parcel is part of a multi-parcel property, and none of the parcels match any Council Parcel `propnum` values based on any of the `spi` values in the multi-parcel property, then null the _second and any subsequent_ `propnum` values