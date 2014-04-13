# Edit Code ‘A’

## DEPI

### Rule

Edit Code A is only used to add a property to either create a Multi Assessment or add a further multi assessment record.

### Q&A

##### Can we add a multi-assessment using the parcel’s SPI (not prop_pfi or parcel_pfi)?

Current M1 loading software doesn’t use SPI as a Mapbase Locator attribute. You can use the Lot and Plan numbers to add a multi assessment. The loading software will then identify the Parcel_PFI and its associated Property_PFI and add another property record.

##### In adding a multi-assessment using either a spi or parcel_pfi, and the parcel is already included in a multi-parcel property, is this a valid edit?

As I indicated earlier the current M1 loading software doesn’t use SPI but can locate the parcel using lot and plan details. Logic (not Logica) tells me that you should be able to use the lot on plan to identify the parcel_pfi and a related property_pfi. The the ‘A’ edit code should add a property record as a multi assessment on the shape of the identified property.

The only caution I have is that there is a load report message that says the following when using an edit code ‘A’:

> ‘Parcel is part of a mulit parcel property. Please remove all parcel identifiers to add to whole property’

I am not sure what Logica are referring to here but there is a chance that what you are suggesting will be returned in the load report.

## Logic

Selecting all multi-property council parcels where the parcel description matches a Vicmap parcel that is not already associated with the Council's propnum.

## SQL

[M1 A Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20A%20Edits.sql)

Include only parcels that have a valid property number.

```sql
cp.propnum not in ( '' , 'NCPR' )
```

Include only parcels whose property number has a corresponding record in the council property table. (Ideally the council data extract would include only these parcels anyway.)

```sql
cp.propnum in ( select propnum from pc_council_property_address )
```

Include only parcels that have a valid parcel description.

```sql
cp.spi <> ''
```

Include only parcels where the Council has more than one property associated with it (otherwise it needs to be submitted as a P edit.)

```sql
( select cppc.num_props from pc_council_parcel_property_count cppc where cppc.spi = cp.spi ) > 1
```

Exclude parcels that are associated with multiple properties but NOT classed as multi-assessments in Vicmap. These parcels have custom properties and we should not attempt to add to them. Eg 2\PS400861 at Stonnington.

```sql
cp.spi in ( select vp.spi from pc_vicmap_parcel vp where not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from pc_vicmap_parcel_property_count vppc where vppc.num_props > 1 ) ) )
```

Include only parcels where the existing `propnum` value in Vicmap actually exists in Council.

```sql
cp.spi in ( select vp.spi from pc_vicmap_parcel vp where vp.propnum in ( select propnum from pc_council_parcel ) )
```

Exclude any parcels where the `propnum` value is already the same in Vicmap.

```sql
cp.propnum not in ( select vp.propnum from pc_vicmap_parcel vp where vp.spi = cp.spi )
```

Include only parcels from Vicmap that are already correctly matched.

```sql
cp.spi in ( select vp.spi from pc_vicmap_parcel vp where vp.spi in ( select cpy.spi from pc_council_parcel cpy where cpy.spi = vp.spi and cpy.propnum = vp.propnum ) )
```

## Old

This section shows the previous logic and SQL used to solve the A edits.

I couldn't find the fault in the query, but it returned too many results (> 500,000) for the Stonnington sample data.

We will keep a record of it for a while in case we need to revert back to it.

### Logic

Comparing Vicmap Parcel against Council Parcel based on a common `spi` value:

* where Vicmap `propnum` is null or doesn't exist in any Council Parcel, and more than one Council parcels have a populated `propnum`, then update with the _second and subsequent_ Council `propnum` values

### SQL

[M1 A Edits.sql at 26 Aug 2013](https://github.com/groundtruth/PoziConnectConfig/blob/cd27392f9b25ed644bc80417f1ab4394f349414e/~Shared/SQL/M1%20A%20Edits.sql)

Include only parcels that have a valid parcel description.

```sql
vp.spi <> ''
```

Include only Council parcel records that have a valid `propnum` value.

```sql
cp.propnum not in ( '' , 'NCPR' )
```

Join Vicmap and Council parcels by parcel description.

```sql
vp.spi = cp.spi
```

Include only parcels where the `propnum` value doesn't already match the Council `propnum` value.

```sql
vp.propnum <> cp.propnum
```

Exclude 'custom' properties (where they are not classed as multi-assessments but there are multiple properties associated to the parcel).

```sql
not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from pc_vicmap_parcel_property_count vppc where vppc.num_props > 1 ) )
```

Include only parcels where any the existing property number is exists in Council (or otherwise we'd just replace it instead of adding to it).

```sql
vp.propnum in ( select t.propnum from pc_council_parcel t )
```

Include only Council parcel record if the Council has multiple properties associated to that parcel.

```sql
( select cppc.num_props from pc_council_parcel_property_count cppc where cppc.spi = cp.spi ) > 1
```

Exclude parcels that are associated with multiple properties but NOT classed as multi-assessments in Vicmap. These parcels have custom properties and we should not attempt to them. Eg 2\PS400861 at Stonnington.

```sql
not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from pc_vicmap_parcel_property_count vppc where vppc.num_props > 1 ) )
```

Exclude parcels with only crown descriptions (ie, do not have a plan number). Crown descriptions are notoriously poor parcel identifiers, and are unlikely to be involved in multi-assessments anyway. Eliminating crown parcels from this query reduced the number of A edits at Swan Hill from 227 to 45.

```sql
cp.plan_number <> ''
```