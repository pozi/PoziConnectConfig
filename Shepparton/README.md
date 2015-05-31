# Shepparton

Property Address query adapted from Shepparton's Common Ground address query

Parcel query adapted from Ballarat Parcel query, substituting references to `pathway_lpaprti_mod` with `pathway_lpaprti`

# Onsite Consultation

## Match Statistics

* match rate: 96.4%
* 1137 properties out of 31,900 missing from Vicmap

## Initial M1

* A (add multi-assessment) 396
  * hold off on submitting any 'A' edits until parent/child issue is resolved
* C (crefno update) 2018
  * submit all
* E (retire property) 23
  * Rates checked a sample of these, and they are good to submit
* P (property number update) 783
  * any updates on 'blank' properties to be submitted straight away
  * Rates to review a sample of the remainder
* R (retire multi-assessment) 158
  * Rates checked a sample of these, and they are good to submit
* S (address update) 533
  * recommend to check all records with a `new_road` value of 'Y'
  * recommend to check a sample of the remainder

## Configuration Update

* update default Vicmap data location and set spatial output to TAB [[link]](https://github.com/groundtruth/PoziConnectConfig/commit/8c379ad723d2e71691d0de7b59d67a8b08f4c5b6)
* update configuration to recognise floor type values from Pathway [[link]](https://github.com/groundtruth/PoziConnectConfig/commit/b6ac439e7d8a4ebc9ada5f21a2b7842622a68669)

## Custom Reports

### Plan Prefix Discrepancy

Plan numbers have the wrong prefix (eg, LP instead of PS). 127 records identified, one of which is critical (ie, not currently matched to Vicmap).

* `spi_in_vicamp` = 0
* `partial_spi_in_vicamp` <> 0
* `propnum_in_vicmap` = 0 (critical ones only)

Nick to submit this to Rates as the first of many updates/reviews.

### Invalid SPI

Cannot generate a properly formatted spi due to missing parcel attributes from Pathway. 169 records identified, 16 of which are critical (ie, not currently matched to Vicmap).

* `spi_validity` not empty
* `propnum_in_vicmap` = 0 (critical ones only)

Mostly railway land, but would result in new matches if valid parcel descriptions can be populated in Pathway.

### SPI Not In Vicmap

This overlaps the 'invalid spi' list, but includes all parcels that can't be found in Vicmap (not just the ones that are not formatted properly). 3265 records identified,  22 of which are critical (ie, not currently matched to Vicmap).

* `spi_in_vicamp` = 0
* `suggested_spi` not blank
* `propnum_in_vicmap` = 0 (critical ones only)

### Check: 360 Willow Road Murchison

Pozi Connect is confirmed to be interpreting Pathway correctly and has generated an M1 entry to match parcel 41\PP3222 to property 199720 (previously 193341).

## Parent/Child Ambiguity

Last year, I started an update ([[link]](https://github.com/groundtruth/PoziConnectConfig/commit/0fe17975c78b8449707162ed2e60caca45755eeb) , [[link]](https://github.com/groundtruth/PoziConnectConfig/commit/c008ed9523f1ad32abbcd4096324972ac3a14e08)) to help Pozi Connect establish the correct relationship between parent and child properties. Today we reviewed the status of this update, and found that it was still awaiting feedback from Justin about the initial results.

After discussing with Rates, this is still an issue that will affect multi-assessments. I've re-sent the initial results to Nick to review and/or discuss with Rates. If all is OK, I'll continue with integrating the new logic into the main configuration.