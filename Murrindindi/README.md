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
