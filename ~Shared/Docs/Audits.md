
<img src="http://i.imgur.com/TLMFPUa.png" alt="Groundtruth" width="200">

# Pozi Connect: Victorian Council Data Audits

Pozi Connect generates parcel and property/address audits when it creates an M1. Use these audit reports to uncover anomalies in your council's data.

Described below are techniques for filtering the audits to narrow down the records to show only the ones that require further attention.

### Opening Audit

When opening a spreadsheet:

##### split window to freeze column headings

* place cursor in A2 cell, then `ALT` + `W` + `S` (doesn't work on all versions of Excel)
  or
* manually drag split pane control down past the first row

##### set autofilter on/off

* keyboard shortcut `ALT` + `D` + `F` + `F`

##### expand columns

* click top left corner to highlight all rows, then double-click on any column divider)

### Filtering Audit

*Example filter to select only `0` values*

![](http://i.imgur.com/rjvYdGt.png)


## Parcel

Audit file: `Audit - Council Parcels.csv`

### Structure

Column|Description|Usage
:--|:--|:--
`spi`|council parcel description (in SPI format) constructed from council parcel attributes|
`crefno`|council parcel id|
`propnum`|council property number|
`summary`|council-maintained combined address (council reference only)
`status`|council parcel status
`spi_validity`|description of any detected instances of SPI not meeting Vicmap rules|filter on `NOT (Blank)` to list non-compliant parcel descriptions
`spi_in_council`|number of properties in Council that share this SPI
`council_propnums`|list of property numbers in Council that share this SPI
`spi_in_vicmap`|number of parcels in Vicmap that match this SPI|filter on `0` to list Council parcel descriptions that don't exist in Vicmap
`spi_propnum_in_vicmap`|number of parcels in Vicmap that match this SPI and property number
`vicmap_propnums`|list of property numbers in Vicmap that share this SPI
`partial_spi_in_vicmap`|number of parcels in Vicmap that match on `plan_numeral` but not `plan_prefix`|filter on `NOT 0` to list parcels with potentially incorrect plan prefix
`alt_spi_in_vicmap`|number of parcels in Vicmap that match on `further_description` field instead of `spi`|filter by `NOT 0` to list parcels with potentially incorrect plan prefix
`suggested_spi`|Vicmap SPI that matches closely to Council parcel based on existing `crefno` or partial SPI match|filter on `NOT (Blank)` to list potential easy fixes for invalid parcel descriptions
`propnum_in_council`|number of Council parcel records that share this `propnum`
`propnum_in_vicmap`|number of Vicmap parcel records that matched to this `propnum`|**filter on `0` to list unmatched properties, ie, CRITICAL**
`vicmap_crefno`|`crefno` value in Vicmap for this SPI
`m1_edit_code`|update pending for this parcel|filter on `(Blank)` to list records not already flagged for update in current M1
`m1_comments`|comments for pending update


### Examples

#### Unmatched parcels, with suggested parcel description fixes (critical, easy)

Filter

* `propnum_in_vicmap`: 0
* `suggested_spi`: NOT (Blank)

#### Plan Prefix Anomalies

Filter

* `partial_spi_in_vicmap`: 1
* `spi_in_vicmap`: 0

## Property Address

Audit file: `Audit - Council Property Address.csv`

#### Locality Anomalies

Filter

* `locality_match_in_vicmap`: N