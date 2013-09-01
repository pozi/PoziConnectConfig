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

Include only records where parcels have a valid parcel description.

```sql
spi <> ''
```

Retire only records where the parcels that don't have a corresponding matching property number and simplified parcel description in Council. The use of the *simplified* parcel description `simple_spi` (as opposed to the standard `spi`) means that if the council has the wrong plan prefix recorded, it will not be included in the results to be retired.

```sql
propnum not in ( select cp.propnum from PC_Council_Parcel cp where cp.simple_spi = vp.simple_spi )
```

Exclude from retirement the last record in the multi-assessment. This will ensure that the not all the records can be retired at once. Unfortunately this prevents us from targeting the last record for retirement.

```sql
property_pfi not in ( select max ( t.property_pfi ) from PC_Vicmap_Parcel t group by t.parcel_pfi )
```

Retire only records where the parcel description exists in Council (because we don't want to remove the record if there is nothing to replace it) or where propnum doesn't exist in Council.

```sql
( spi in ( select cp.spi from PC_Council_Parcel cp ) or propnum not in ( select cpa.propnum from PC_Council_Property_Address cpa ) )
```

## Development notes:

### Old Logic (probably no longer relevant)

Looking at all _multi-assessment_ Vicmap Parcels where Vicmap `propnum` doesn't exist in Council Parcel with the same `spi`:

* when Parcel is a single-parcel property, then null the _second and any subsequent_ `propnum` values
* when Parcel is part of a multi-parcel property, and none of the parcels match any Council Parcel `propnum` values based on any of the `spi` values in the multi-parcel property, then null the _second and any subsequent_ `propnum` values