# Edit Code ‘R’

DEPI:
>Edit Code R is only used to remove a property from a Multi Assessment. The last record on a multi assessment cannot be retired.

Looking at all _multi-assessment_ Vicmap Parcels:

* where Vicmap `propnum` doesn't exist in Council Parcel with the same `spi`, and...
  * Parcel is a single-parcel property, then null the _second and any subsequent_ `propnum` values
  * Parcel is part of a multi-parcel property, and none of the parcels match any Council Parcel `propnum` values based on any of the `spi` values in the multi-parcel property, then null the _second and any subsequent_ `propnum` values

## Q&A with DEPI

If a multi-assessment contains five properties, and we submit R edits records for all five, will the first four succeed (or will they all fail)?

> The current M1 loading software will identify that you are trying to retire all instances which fails validation rules and therefore no edits will occur ie all five edits will fail.

## Development notes:

- in the multi-parcel multi-assessment scenario, eliminate duplicate records retiring the same property (group by `propnum`?), while retaining useful comments
- submit `property_pfi`
- ensure only top ( num_props -1 ) records get submitted

