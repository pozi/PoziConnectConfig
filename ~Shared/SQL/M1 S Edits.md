# Edit Code ‘S’

DEPI Rule:
>Edit Code S updates address details for a given record. It requires that the Address – Road and Locality Information columns are populated as required including the Address – Location attributes for creating spatially located address points.

Question to DEPI: Can we update the address of an existing property using the existing propnum (not prop_pfi)?

> It is my understanding that an existing propnum can be used as the mapbase locator for a street address update.


## Logic

select from Council Property Address where the property number doesn't match a property in Vicmap with the same address (and it's not in the R batch)

## SQL

Exlude properties where the property already exists in Vicmap with the same address:

```
propnum not in ( select t.propnum from PC_Vicmap_Property_Address t where council_address.num_road_address = t.num_road_address and t.is_primary <> 'N' ) and    
```

Exclude properties that will be retired.

```
propnum not in ( select propnum from M1_R_Edits ) and
```

Include only properties that 1) already exist in Vicmap; 2) will appear in a P edit; or 3) will appear in an A edit.

```
    ( propnum in ( select propnum from PC_Vicmap_Property_Address ) or    
      propnum in ( select propnum from M1_P_Edits ) or    
      propnum in ( select propnum from M1_A_Edits ) )    
```




