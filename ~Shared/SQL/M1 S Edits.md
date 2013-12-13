# Edit Code ‘S’

## DEPI

### Rule

Edit Code S updates address details for a given record. It requires that the Address – Road and Locality Information columns are populated as required including the Address – Location attributes for creating spatially located address points.

### Q&A

##### Can we update the address of an existing property using the existing propnum (not prop_pfi)?

It is my understanding that an existing propnum can be used as the mapbase locator for a street address update.

## Logic

### Part 1

select from Council Property Address where the property number doesn't match a property in Vicmap with the same address (and it's not in the R batch)

### Part 2

This part adds addresses for proposed parcels where the council uses the same property number for both the approved and proposed parcels. These properties are prevented from appearing in the P edits to avoid the properties being merged and potentially losing any address information submitted via SPEAR. This part of the query enables these addresses to be submitted as S edits, without using the property number.

## SQL

[M1 S Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20S%20Edits.sql)

### Part 1

Exclude records whose property number has a Council address that already matches the Vicmap address with the same property number:

*Note: this has been introduced to cater for Property.Gov systems where the council property can have multiple addresses, one of which may already match, and would not warrant being updated.*

```sql
propnum not in (
    select propnum
        from PC_Council_Property_Address
        where num_road_address in (
            select num_road_address from PC_Vicmap_Property_Address where propnum = cpa.propnum ) )
```

Exclude properties that will be retired.

```sql
propnum not in (
    select vpa.propnum
        from PC_Vicmap_Property_Address vpa, M1_R_Edits r
        where vpa.property_pfi = r.property_pfi )
```

Include only properties that 1) already exist in Vicmap; 2) will appear in a P edit; or 3) will appear in an A edit.

```sql
( propnum in ( select propnum from PC_Vicmap_Property_Address ) or
  propnum in ( select propnum from M1_P_Edits ) or
  propnum in ( select propnum from M1_A_Edits ) ) 
```

Exclude properties where the only difference between the Council and Vicmap address is a hyphen or an apostrophe.

```sql
not replace ( replace ( cpa.num_road_address , '-' , ' ' ) , '''' , '' ) = replace ( replace ( ( select vpa.num_road_address from PC_Vicmap_Property_Address vpa where vpa.propnum = cpa.propnum ) , '-' , ' ' ) , '''' , '' )
```

Generate only one record per property.

```sql
group by propnum
```

#### Field `new_road`

Populate `new_road` with 'Y' if property is new and if the Council road name/type/locality combination doesn't already exist in Vicmap.

```sql
case
    when cpa.propnum not in ( select vpa.propnum from PC_Vicmap_Property_Address vpa ) and ( cpa.road_name || ' ' || cpa.road_type || ' ' || cpa.locality_name ) not in ( select vpa.road_name || ' ' || vpa.road_type || ' ' || vpa.locality_name from PC_Vicmap_Property_Address vpa ) then 'Y'
    else ''
end as new_road,
```

### Part 2

Join the respective property/address and parcel tables to include records for proposed parcels.

```sql
cpa.propnum not in ( '' , 'NCPR' ) and
cpa.propnum = cp.propnum and
cp.spi = vp.spi and    
vp.property_pfi = vpa.property_pfi and
vp.status = 'P' and
vpa.propnum = '' and
```

Include only addresses where the Council address contains more information (such as house number) than Vicmap address to ensure that we're not overwriting addresses that may have been submitted by SPEAR with addresses from the Council system that may not be as good.

```sql
cpa.num_address <> '' and
vpa.num_address = ''
```

If the Council address has a `crefno` value (such as in Authority and Property.Gov systems), match the addresses using this value.

```sql
( cpa.crefno = cp.crefno or cpa.crefno = '' )
```

Generate a record per plan/lot combination.

```sql
group by cpa.propnum, vp.plan_number, vp.lot_number
```

## Developer Notes

At Hobsons Bay, there are multiple addresses per property (possibly one per parcel), none of which is considered the primary address. To prevent good addresses in Vicmap being overwritten with one of the parcel addresses, we could introduce a filter to only overwrite an existing Vicmap address that already contains both `house_number_1` and `house_number_2` if there is only a single primary Council address for that property.

This will prevent good addresses being overwritten with bad ones, but it won't solve the problem of getting good address information submitted for new properties. This will need to solved specifically for the Hobsons Bay property address query.
