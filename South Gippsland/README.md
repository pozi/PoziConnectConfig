# South Gippsland

copied from Glen Erira

## Notes


#### Parish / Townships

Parish / townships that dont have a match in vicmap ref.


    when lpadesc.descr = 'Tidal River' then '????'
    when lpadesc.descr = 'Wilson Promontory' then '????
    when lpadesc.descr = 'Loch Township' then '????
    when lpadesc.descr = 'Bongurra Township' then '????
    when lpadesc.descr = 'Kongwak Township' then '????
    when lpadesc.descr = 'Bena Township' then '????

#### Parcel Desc 

Crown Allotments and sections are stored in separate tables from all other parcel info in LPAPARC.

* LPACRWN
* LPASECT


### Street Names

Directional suffix is normally in street type for all other streets. these 2 streets do not have a correct street type and are not stored the same as other directional streets.

* JAMES ROAD NORTH    
* MCPHEE STREET NORTH

### Units

Building unit type has unit for all small unit like houses. not all have a unit number some have there own number on private roads (common property).



### to fix

Street address of OFF, CNR in bulding name feild to be moved to location desc feild

Crown Portions fix

Lot numbers with no plan number to be moved over to allotment field

CM plancode in lpaparc table has CM for each CM but no lot number. make lot number = CM

Remove plan type of AG from council parcels


remove crefno value from M1 (leave blank)


Unit Suffix missing from address Building Unit Suffix 1










