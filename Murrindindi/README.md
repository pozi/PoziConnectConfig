# Murrindindi

## Parcel Query

## Property Address Query

### Primary Address

Simone Elliott from Murrindindi says:

> from what I can ascertain the table is auprparc and if the field str_seq has a zero (0) it is the primary address to use.  In saying that I can see examples where there is multiple primary addresses on the one assessment.

Simon O'Keefe from Groundtruth says:

> I've looked at the auprparc.str_seq field, and I'm unsure if it can be used to identify the assessment's primary address. Some assessments have all zeros and some have no zeros.

Brian Hall from Civica says:

> The str_seq ‘0’ would only be used to override an address for an assessment. By default the lowest registered parcel number is used on an assessment but if the site wants to use a different parcel’s address they use the ‘Make Primary Parcel’ button to set the sequence zero on that higher numbered parcel.
 
> So in the majority of cases where the site is happy with the primary parcel being the one with the lowest parcel number (generally first one created) the sequence numbers are all null and so you need to take that into account.

#### Proposed Logic

For single-parcel properties:

* use that one parcel's address, regardless of its `str_seq` value

For multi-parcel properties, based on the number of parcels whose `str_seq` value is equal to '0':

* none: use the most frequently occurring address out of any of the parcels
* one: use that one parcel's address whose `str_seq` value is equal to '0'
* more than one: use the most frequently occurring address whose `str_seq` value is equal to '0'

# Notes from old README (most of this can be deleted)

Civica Authority uses 'assessment' in place of the Vicmap equivalent of 'property' We'll use the word 'assessment' here when talking about extracting this information from Authority.

## Property/Address Query

### Populating `is_primary`

Civica Authority has addresses for every parcel. In the majority of cases, these parcels will have the same address, and so when the 'distinct' operator is applied, we end up with a single address.

However, where the addresses are different, this results in multiple address records per property.

Murrindindi says that for records with a `auprparc.str_seq`of zero, this is the primary address.

In practice, we found that some assessments have all zeros and some have no zeros. We'll attempt to identify address as secondary only if the `str_seq` value is not zero and the address is different to other records in the same assessment. The desired result after the 'distinct' operator is applied is that properties get one record if all the addresses are the same (even if none of them have the zero value) or get at least one record that is not marked as secondary.

If it's not possible to get one record that is not a secondary, we might need to adjust the logic of the main 'M1 S Edit' SQL ensure it can use one of the secondary addresses if no primary address is present.

#### Logic (draft)

if `auprparc.str_seq` is not zero  
and `auprstad.hou_num` is different to any other assessment records with the same `ass_num`  
then populate `is_primary` with 'N'  
else null  

test on Murrindindi data to see if all properties have at least one non-secondary address

#### SQL (draft)

```sql
select * from table
```
#### Tidy Up

Send council a list of any assessment where all `str_seq` values are null and contain more than one unique address.
