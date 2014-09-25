create view view_vmfeat_poi_admin_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'admin facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_admin_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_agricultural_area as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'agricultural area';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_agricultural_area', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_building as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'building';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_building', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_cableway as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'cableway';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_cableway', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_care_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'care facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_care_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_commercial_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'commercial facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_commercial_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_communication_service as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'communication service';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_communication_service', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_community_space as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'community space';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_community_space', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_community_venue as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'community venue';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_community_venue', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_control_point as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'control point';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_control_point', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_cultural_centre as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'cultural centre';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_cultural_centre', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_defence_site as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'defence site';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_defence_site', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_dumping_ground as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'dumping ground';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_dumping_ground', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_education_centre as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'education centre';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_education_centre', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_emergency_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'emergency facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_emergency_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_excavation_site as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'excavation site';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_excavation_site', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_health_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'health facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_health_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_hospital as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'hospital';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_hospital', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_industrial_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'industrial facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_industrial_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_landmark as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'landmark';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_landmark', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_pipeline_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'pipeline facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_pipeline_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_place as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'place';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_place', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_place_of_worship as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'place of worship';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_place_of_worship', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_power_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'power facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_power_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_recreational_resource as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'recreational resource';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_recreational_resource', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_reserve as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'reserve';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_reserve', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_residential_building as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'residential building';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_residential_building', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_sign as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'sign';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_sign', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_sport_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'sport facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_sport_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_stockpile as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'stockpile';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_stockpile', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');


create view view_vmfeat_poi_storage_facility as
Select PFI as ROWID, *
from vmfeat_foi_point
where FEATURE_TYPE = 'storage facility';

insert into views_geometry_columns
VALUES ('view_vmfeat_poi_storage_facility', 'GEOMETRY', 'ROWID', 'vmfeat_foi_point', 'GEOMETRY');