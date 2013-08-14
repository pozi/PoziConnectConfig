# Murrindindi

Civica Authority uses 'assessment' in place of the Vicmap equivalent of 'property' We'll use the word 'assessment' here when talking about extracting this information from Authority.

## Property/Address Query


### Populating `is_primary`

Civica Authority has addresses for every parcel. In the majority of cases, these parcels will have the same address, and so when the 'distinct' operator is applied, we end up with a single address.

However, where the addresses are different, this results in multiple address records per property.

Murrindindi says that for records with a `auprparc.str_seq`of zero, this is the primary address.

In practice, we found that some assessments have all zeros and some have no zeros. We'll attempt to identify address as secondary only if the `str_seq` value is not zero and the address is different to other records in the same assessment. The desired result after the 'distinct' operator is applied is that properties get one record if all the addresses are the same (even if none of them have the zero value) or get at least one record that is not marked as secondary.

#### Logic (draft)

if `auprparc.str_seq` is not zero  
and `auprstad.hou_num` is different to any other assessment records with the same `ass_num`  
then populate `is_primary` with 'N'  
else null  

test on Murrindindi data to see if all properties have at least one non-secondary address

#### Tidy Up

Send council a list of any assessment where all str_seq values are null and contain more than one unique address.