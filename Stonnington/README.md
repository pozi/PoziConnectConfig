# Stonnington

Starting with these existing SQL files on which to base the PC_Council_Parcel and PC_Council_Property_Address queries:

* [Stonnington\SQL\PIQA Address Export - Stonnington.SQL](https://github.com/groundtruth/PoziConnectConfig/blob/549edea8481806b921648e18f83471af5739326a/Stonnington/SQL/PIQA%20Address%20Export%20-%20Stonnington.SQL)
* [Stonnington\SQL\PIQA Parcel Export - Stonnington.SQL](https://github.com/groundtruth/PoziConnectConfig/blob/d8569eafbf4a579795bb303a9e78cfcf09feb4bc/Stonnington/SQL/PIQA%20Parcel%20Export%20-%20Stonnington.SQL)

## Progress

- [x] copy INI
- [x] update INI
- [x] copy SQL
- [x] update SQL
- [x] compensate for potential new inclusion of 'TransPRLD' association type
- [x] config supplied to council for review

## Notes

* changed 'Proclaim' references to 'TechOne'
* expanded on nucAssocation filter from `association_type = 'PropLand'` to `association_type in ( 'PropLand' , 'TransPRLD' )`
