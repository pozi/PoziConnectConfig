select
    propnum as propnum,
    status as status,
    num_road_address as address,
    locality_name as locality,
    summary as summary,
    case
        when status not in ('','A','P') then 'Invalid: status (' || status || ')'
        when is_primary not in ('','Y','N') then 'Invalid: is_primary (' || is_primary || ')'
        when distance_related_flag not in ('','Y','N') then 'Invalid: distance_related_flag (' || distance_related_flag || ')'
        when building_name in ('ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then 'Invalid: building_name (' || building_name || ') cannot be a building unit type'
        when location_descriptor not in ('','ABOVE','ADJACENT','BELOW','BETWEEN','CORNER','EAST','FRONT','NORTH','OFF','OPPOSITE','PART','REAR','ROOFTOP','SOUTH','WEST') then 'Invalid: location_descriptor (' || location_descriptor || ')'
        when blg_unit_type <> '' and blg_unit_id_1 = '' then 'Invalid: blg_unit_type (' || blg_unit_type || ') when blg_unit_id_1 is not supplied'
        when blg_unit_type not in ('','ANT','APT','ATM','BBOX','BBQ','BERT','BLDG','BNGW','BTSD','CAGE','CARP','CARS','CARW','CHAL','CLUB','COOL','CTGE','CTYD','DUPL','FCTY','FLAT','GATE','GRGE','HALL','HELI','HNGR','HOST','HSE','JETY','KSK','LBBY','LOFT','LOT','LSE','MBTH','MSNT','OFFC','PSWY','PTHS','REST','RESV','ROOM','RPTN','SAPT','SE','SHCS','SHED','SHOP','SHRM','SIGN','SITE','STLL','STOR','STR','STU','SUBS','TNCY','TNHS','TWR','UNIT','VLLA','VLT','WARD','WC','WHSE','WKSH') then 'Invalid: blg_unit_type (' || blg_unit_type || ')'
        when hsa_flag not in ('','Y','N') then 'Invalid: hsa_flag (' || hsa_flag || ')'
        when blg_unit_prefix_1 like '%&%' or blg_unit_prefix_1 like '% %' or blg_unit_prefix_1 like '%-%' or length ( blg_unit_prefix_1 ) > 2 then 'Invalid: blg_unit_prefix_1 (' || blg_unit_prefix_1 || ')'
        when blg_unit_id_1 <> '' and house_number_1 = '' then 'Invalid: house_number_1 must be present for blg_unit_id_1 (' || blg_unit_id_1 || ')'
        when blg_unit_id_1 like '%&%' or blg_unit_id_1 like '% %' or blg_unit_id_1 like '%-%' or ( blg_unit_id_1 <> '' and cast ( blg_unit_id_1 as integer ) not between 1 and 99999 ) then 'Invalid: blg_unit_id_1 (' || blg_unit_id_1 || ')'
        when blg_unit_suffix_1 like '%&%' or blg_unit_suffix_1 like '% %' or blg_unit_suffix_1 like '%-%' or length ( blg_unit_suffix_1 ) > 2 then 'Invalid: blg_unit_suffix_1 (' || blg_unit_suffix_1 || ')'
        when blg_unit_suffix_1 <> '' and blg_unit_id_1 = '' then 'Invalid: blg_unit_id_1 must be present for blg_unit_suffix_1 (' || blg_unit_suffix_1 || ')'
        when blg_unit_prefix_2 like '%&%' or blg_unit_prefix_2 like '% %' or blg_unit_prefix_2 like '%-%' or length ( blg_unit_prefix_2 ) > 2 then 'Invalid: blg_unit_prefix_2 (' || blg_unit_prefix_2 || ')'
        when blg_unit_id_2 like '%&%' or blg_unit_id_2 like '% %' or blg_unit_id_2 like '%-%' or ( blg_unit_id_2 <> '' and cast ( blg_unit_id_2 as integer ) not between 1 and 99999 ) then 'Invalid: blg_unit_id_2 (' || blg_unit_id_1 || ')'
        when blg_unit_id_2 <> '' and blg_unit_id_1 = '' then 'Invalid: blg_unit_id_1 must be present for blg_unit_id_2 (' || blg_unit_id_2 || ')'
        when blg_unit_suffix_2 like '%&%' or blg_unit_suffix_2 like '% %' or blg_unit_suffix_2 like '%-%' or length ( blg_unit_suffix_2 ) > 2 then 'Invalid: blg_unit_suffix_2 (' || blg_unit_suffix_2 || ')'
        when floor_type not in ('','B','FL','G','L','LB','LG','LL','M','OD','P','PD','PF','RT','SB','UG') then 'Invalid: floor_type (' || floor_type || ')'
        when floor_type = '' and floor_no_1 <> '' then 'Invalid: floor_type value required'
        when floor_prefix_1 like '%&%' or floor_prefix_1 like '% %' or floor_prefix_1 like '%-%' or length ( floor_prefix_1 ) > 2 then 'Invalid: floor_prefix_1 (' || floor_prefix_1 || ')'
        when floor_no_1 like '%&%' or floor_no_1 like '% %' or floor_no_1 like '%-%' or ( floor_no_1 <> '' and cast ( floor_no_1 as integer ) not between 1 and 99 ) then 'Invalid: floor_no_1 (' || floor_no_1 || ')'
        when floor_suffix_1 like '%&%' or floor_suffix_1 like '% %' or floor_suffix_1 like '%-%' or length ( floor_suffix_1 ) > 2 then 'Invalid: floor_suffix_1 (' || floor_suffix_1 || ')'
        when floor_prefix_2 like '%&%' or floor_prefix_2 like '% %' or floor_prefix_2 like '%-%' or length ( floor_prefix_2 ) > 2 then 'Invalid: floor_prefix_2 (' || floor_prefix_2 || ')'
        when floor_no_2 like '%&%' or floor_no_2 like '% %' or floor_no_2 like '%-%' or ( floor_no_2 <> '' and cast ( floor_no_2 as integer ) not between 1 and 99 ) then 'Invalid: floor_no_2 (' || floor_no_2 || ')'
        when floor_suffix_2 like '%&%' or floor_suffix_2 like '% %' or floor_suffix_2 like '%-%' or length ( floor_suffix_2 ) > 2 then 'Invalid: floor_suffix_2 (' || floor_suffix_2 || ')'
        when house_prefix_1 like '%&%' or house_prefix_1 like '% %' or house_prefix_1 like '%-%' or length ( house_prefix_1 ) > 2 then 'Invalid: house_prefix_1 (' || house_prefix_1 || ')'
        when house_number_1 <> '' and cast ( house_number_1 as integer ) not between 1 and 99999 then 'Invalid: house_number_1 (' || house_number_1 || ')'
        when house_suffix_1 like '%&%' or house_suffix_1 like '% %' or house_suffix_1 like '%-%' or length ( house_suffix_1 ) > 2 then 'Invalid: house_suffix_1 (' || house_suffix_1 || ')'
        when house_prefix_2 like '%&%' or house_prefix_2 like '% %' or house_prefix_2 like '%-%' or length ( house_prefix_2 ) > 2 then 'Invalid: house_prefix_2 (' || house_prefix_2 || ')'
        when house_number_2 like '%&%' or house_number_2 like '% %' or house_number_2 like '%-%' or house_number_2 <> '' and cast ( house_number_2 as integer ) not between 1 and 99999 then 'Invalid: house_number_2 (' || house_number_2 || ')'
        when house_number_2 <> '' and house_number_1 = '' then 'Invalid: house_number_1 must be present for house_number_2 (' || house_number_2 || ')'
        when house_suffix_2 like '%&%' or house_suffix_2 like '% %' or house_suffix_2 like '%-%' or length ( house_suffix_2 ) > 2 then 'Invalid: house_suffix_2 (' || house_suffix_2 || ')'
        when road_name = '' or road_name like '%&%' then 'Invalid: road_name (' || road_name || ')'
        when road_type not in ('','ACCESS','ALLEY','AMBLE','APPROACH','ARCADE','ARTERIAL','AVENUE','BAY','BEND','BOARDWALK','BOULEVARD','BOULEVARDE','BOWL','BRAE','BREAK','BRIDGE','BYPASS','CAUSEWAY','CENTRE','CENTREWAY','CHASE','CIRCLE','CIRCUIT','CIRCUS','CLOSE','CLUSTER','COMMON','CONCOURSE','CONNECTION','CORNER','COURSE','COURT','COVE','CRESCENT','CREST','CROOK','CROSS','CROSSING','CRUISEWAY','CUTTING','DALE','DASH','DELL','DENE','DEVIATION','DIP','DIVIDE','DOMAIN','DRIVE','EDGE','ELBOW','END','ENTRANCE','ESPLANADE','EXTENSION','FAIRWAY','FIREBREAK','FIRELINE','FIRETRAIL','FLATS','FORD','FORK','FREEWAY','GARDEN','GARDENS','GATE','GATEWAY','GLADE','GLEN','GRANGE','GREEN','GROVE','GULLY','HEATH','HEIGHTS','HIGHWAY','HILL','HOLLOW','HUB','INTERSECTI','ISLAND','JUNCTION','KEY','KEYS','LANDING','LANE','LANEWAY','LINE','LINK','LOOP','MALL','MANOR','MAZE','MEWS','NOOK','OUTLET','OUTLOOK','PARADE','PARK','PARKWAY','PASS','PASSAGE','PATH','PATHWAY','PLACE','PLAZA','POCKET','POINT','PROMENADE','PURSUIT','QUADRANT','QUAY','QUAYS','RAMP','REACH','RESERVE','REST','RETREAT','RETURN','RIDE','RIDGE','RISE','RISING','ROAD','ROUND','ROUTE','ROW','RUN','SLOPE','SPUR','SQUARE','STEPS','STREET','STRIP','SUBWAY','TERRACE','THROUGHWAY','TOLLWAY','TOP','TRACK','TRAIL','TRAVERSE','TUNNEL','TURN','TWIST','UNDERPASS','VALE','VALLEY','VIEW','VIEWS','VISTA','WALK','WALKWAY','WATERS','WAY','WHARF','WOOD','WOODS','WYND') then 'Invalid: road_type (' || road_type || ')'
        when road_suffix not in ('','N','S','E','W','CN','DV','EX','ML') then 'Invalid: road_suffix (' || road_suffix || ')'
        when access_type not in ('','L','W','I') then 'Invalid: access_type (' || access_type || ')'
        when outside_property not in ('','Y','N') then 'Invalid: outside_property (' || outside_property || ')'
        when building_name <> '' and house_number_1 = '' then 'Invalid: house_number_1 must be present for building_name (' || building_name || ')'
        else ''
    end as address_validity,
    ifnull ( ( select cppc.num_parcels from pc_council_property_parcel_count cppc where cppc.propnum = cpa.propnum ) , 0 ) as parcels_in_council,
    substr ( ifnull ( ( select group_concat ( spi , ';' ) from pc_council_parcel cp where cp.propnum = cpa.propnum ) , '' ) , 1 , 99 ) as council_parcels,
    ifnull ( ( select vppc.num_parcels from pc_vicmap_property_parcel_count vppc where vppc.propnum = cpa.propnum ) , 0 ) as parcels_in_vicmap,
    substr ( ifnull ( ( select group_concat ( spi , ';' ) from pc_vicmap_parcel vp where vp.propnum = cpa.propnum ) , '' ) , 1 , 99 ) as vicmap_parcels,
    ifnull ( ( select vpa.num_road_address from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) , '' ) as vicmap_address,
    ifnull ( ( select vpa.locality_name from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) , '' ) as vicmap_locality,
    case
        when propnum in ( select vpa.propnum from pc_vicmap_property_address vpa ) then 'Y'
        else 'N'
    end as propnum_in_vicmap,
    case
        when propnum not in ( select vpa.propnum from pc_vicmap_property_address vpa ) then ''
        when replace ( replace ( num_road_address , '-' , ' ' ) , '''' , '' ) = ( select replace ( num_road_address , '-' , ' ' ) from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) then 'Y'
        else 'N'
    end as address_match_in_vicmap,
    case
        when propnum not in ( select vpa.propnum from pc_vicmap_property_address vpa ) then ''
        when locality_name = ( select vpa.locality_name from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) then 'Y'
        when ( select vpa.locality_name from pc_vicmap_property_address vpa where vpa.propnum = cpa.propnum limit 1 ) like locality_name || ' (%)' then 'Y'
        else 'N'
    end as locality_match_in_vicmap,
    case
        when replace ( replace ( road_locality , '-' , ' ' ) , '''' , '' ) in ( select replace ( road_locality , '-' , ' ' ) from pc_vicmap_property_address ) then 'Y'
        else 'N'
    end as road_locality_in_vicmap,
    ifnull ( ( select edit_code from m1 where m1.propnum = cpa.propnum limit 1 ) , '' ) as current_m1_edit_code,
    ifnull ( ( select comments from m1 where m1.propnum = cpa.propnum limit 1 ) , '' ) as current_m1_comments,
    cpa.*,
    ( select st_multi ( st_union ( vp.geometry ) ) from pc_vicmap_parcel vp where vp.propnum = cpa.propnum and vp.propnum <> 'NCPR' group by vp.propnum limit 1 ) as geometry
from pc_council_property_address cpa
