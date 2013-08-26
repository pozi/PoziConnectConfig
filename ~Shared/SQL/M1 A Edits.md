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

Comparing Vicmap Parcel against Council Parcel based on a common `spi` value:

* where Vicmap `propnum` is null or doesn't exist in any Council Parcel, and more than one Council parcels have a populated `propnum`, then update with the _second and subsequent_ Council `propnum` values

## SQL

[M1 A Edits.sql](https://raw.github.com/groundtruth/PoziConnectConfig/master/~Shared/SQL/M1%20A%20Edits.sql)

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
not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from PC_Vicmap_Parcel_Property_Count vppc where vppc.num_props > 1 ) )
```

Include only parcels where any the existing property number is exists in Council (or otherwise we'd just replace it instead of adding to it).

```sql
vp.propnum in ( select t.propnum from PC_Council_Parcel t )
```

Include only Council parcel record if the Council has multiple properties associated to that parcel.

```sql
( select cppc.num_props from PC_Council_Parcel_Property_Count cppc where cppc.spi = cp.spi ) > 1
```

Exclude parcels that are associated with multiple properties but NOT classed as multi-assessments in Vicmap. These parcels have custom properties and we should not attempt to them. Eg 2\PS400861 at Stonnington.

```sql
not ( vp.multi_assessment = 'N' and vp.spi in ( select vppc.spi from PC_Vicmap_Parcel_Property_Count vppc where vppc.num_props > 1 ) )
```

## Developer Notes

I can't find the fault in the above query, but it is currently returning too many results for the Stonnington sample data.

### Potential New Logic

Selecting all multi-property council parcels where the parcel description matches a Vicmap parcel that is not already associated with the Council's propnum

### Potential New SQL

Work in progress...

```sql
select
    *    
from
    PC_Council_Parcel cp    
where
    cp.spi in ( select cppc.spi from PC_Council_Parcel_Property_Count cppc where cppc.num_props > 1 ) and    
    cp.spi in ( select vp.spi from PC_Vicmap_Parcel vp where vp.spi = cp.spi and vp.propnum <> cp.propnum )
```
