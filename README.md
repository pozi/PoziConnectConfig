# Pozi Connect Config

Pozi Connect, developed by Groundtruth, is a utility for translating and processing spatial and non-spatial data.

This repository contains the configuration files used by Pozi Connect for many of Groundtruth's clients. The projects include PIQA, M1s and Vicmap data loading.

## Change History

*For a complete history with every change, see [here](https://github.com/groundtruth/PoziConnectConfig/commits/master/~Shared).*

#### December 2013
* include PIQA exports in all M1 configs
* improve comments for M1 A edits
* improve logic for P edits
* enable S edits to take into account multiple council addresses

## Client Instructions

**IMPORTANT**: All instructions for installing, updating and running Pozi Connect for M1s are now available at the Groundtruth website:

[http://www.groundtruth.com.au/pozi-connect-for-m1s-setup-guide](http://www.groundtruth.com.au/pozi-connect-for-m1s-setup-guide)

If it's your first time doing an update, it is recommended you visit the webpage for the complete instructions.

If you've already done it before, you can follow the summarised instructions below.

#### Summary

To install the latest configuration into an existing installation of Pozi Connect:

1. download [this zip file](https://github.com/groundtruth/PoziConnectConfig/archive/master.zip)
2. unzip the zip file, and rename the output folder `PoziConnectConfig-master` to `Tasks`
3. move this Tasks folder into your PoziConnect folder (overwriting the existing Tasks folder.)

Tips:

* To preserve any existing configuration, move or rename your existing Tasks folder before downloading the latest configuration
* You may delete unneeded Tasks subfolders, leaving only your folder and the `~Shared` folder. For instance, if your organisation's name is Melton, delete all folders with the Tasks folder except for `~Shared` and `Melton`.

## Development Notes

### To Dos

- [ ] write Pozi Connect task for importing table to PostGIS
- [ ] update `~\Shared\Reference\Vicmap Property Field LUT.md` with new format Vicmap
- [ ] create Planning Scheme style
- [ ] add blank column to Sampler audit table so email recipient can check off/flag records

### Notes

#### Config for Updating

Sample code for importing to PostGIS:

```
[User Settings]
PostGIS_host:localhost
PostGIS_port:5432
PostGIS_DB:test
PostGIS_DB_username: opengeo
PostGIS_DB_password: opengeo

[General Settings]
Description: Load vector data from files (MapInfo TAB, Shapefile, ...) into a PostGIS database.
PostGIS_Connection: PG:host='{PostGIS_host}' port='{PostGIS_port}' dbname='{PostGIS_DB}' user='{PostGIS_DB_username}' password='{PostGIS_DB_password}'

[Updating]
OGRInfoOnly: true
Destination: {PostGIS_Connection},dummy
Sql: update open_space set area=ST_Area(ST_Transform(the_geom,3111))
```