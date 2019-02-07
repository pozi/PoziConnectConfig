select
    *,
    ltrim ( num_road_address ||
        rtrim ( ' ' || locality_name ) ) as ezi_address
from (

select
    *,
    ltrim ( road_name_combined ||
        rtrim ( ' ' || locality_name ) ) as road_locality,
    ltrim ( num_address ||
        rtrim ( ' ' || road_name_combined ) ) as num_road_address
from (

select
    *,
    blg_unit_prefix_1 || blg_unit_id_1 || blg_unit_suffix_1 ||
        case when ( blg_unit_id_2 <> '' or blg_unit_suffix_2 <> '' ) then '-' else '' end ||
        blg_unit_prefix_2 || blg_unit_id_2 || blg_unit_suffix_2 ||
        case when ( blg_unit_id_1 <> '' or blg_unit_suffix_1 <> '' ) then '/' else '' end ||
        case when hsa_flag = 'Y' then hsa_unit_id || '/' else '' end ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        case when ( house_number_2 <> '' or house_suffix_2 <> '' ) then '-' else '' end ||
        house_prefix_2 || house_number_2 || house_suffix_2 as num_address,
    ltrim ( road_name ||
        rtrim ( ' ' || road_type ) ||
        rtrim ( ' ' || road_suffix ) ) as road_name_combined
from (

select
    cast ( P.property_no as varchar ) as propnum,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when S.street_name like '% OFF %' then 'OFF'
        when upper ( A.modifier_desc ) = 'REAR' then 'REAR'
        when A.formatted_address like 'REAR %' then 'REAR'
    else ''
    end as location_descriptor,
    case
        when upper ( A.modifier_desc ) = 'BTSD' then 'BTSD'
        when upper ( A.unit_desc ) in ( 'FLAT' , 'SHOP' ) then upper ( A.unit_desc )
        when upper ( A.unit_desc ) = 'KIOSK' then 'KSK'
        when upper ( A.unit_desc ) = 'OFFICE' then 'OFFC'
        when upper ( A.unit_desc ) = 'SUITE' then 'SE'
        else ''
    end as blg_unit_type,
    case
        when upper ( A.unit_desc ) in ( 'FLAT' , 'KIOSK' , 'OFFICE' , 'REAR' , 'SHOP' , 'SUITE' ) then ''
        else ifnull ( A.unit_desc , '' )
    end  as blg_unit_prefix_1,
    case
        when A.modifier_desc = 'BTSD' then
            case
                when A.house_no = 0 then ''
                else cast ( ifnull ( A.house_no , '' ) as varchar )
            end
        when A.unit_no = 0 then ''
        else cast ( ifnull ( A.unit_no , '' ) as varchar )
    end as blg_unit_id_1,
    case
        when A.modifier_desc = 'BTSD' then upper ( ifnull ( A.house_no_suffix , '' ) )
        else upper ( ifnull ( A.unit_no_suffix , '' ) )
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when A.modifier_desc = 'BTSD' then
            case
                when A.house_no_to = 0 then ''
                else cast ( ifnull ( A.house_no_to , '' ) as varchar )
            end
        when A.unit_no_to = 0 then ''
        else cast ( ifnull ( A.unit_no_to , '' ) as varchar )
    end as blg_unit_id_2,
    upper ( ifnull ( A.unit_no_to_suffix , '' ) ) as blg_unit_suffix_2,
    '' as floor_type,
    '' as floor_prefix_1,
    case
        when A.floor_no = 0 then ''
        else cast ( ifnull ( A.floor_no , '' ) as varchar )
    end as floor_no_1,
    upper ( ifnull ( A.floor_suffix , '' ) ) as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when A.floor_no_to = 0 then ''
        else cast ( ifnull ( A.floor_no_to , '' ) as varchar )
    end as floor_no_2,
    upper ( ifnull ( A.floor_suffix_to , '' ) ) as floor_suffix_2,
    upper ( ifnull ( A.property_name , '' ) ) as building_name,
    case
        when upper ( S.street_name ) = 'TANKERTON ESTATE' then 'TANKERTON ESTATE'
        when upper ( A.formatted_address ) like '%CANADIAN BAY FORESHORE%' then 'CANADIAN BAY FORESHORE'
        when upper ( A.formatted_address ) like '%CAPEL SOUND FORESHORE%' then 'CAPEL SOUND FORESHORE'
        when upper ( A.formatted_address ) like '%DAVEYS BAY FORESHORE%' then 'DAVEYS BAY FORESHORE'
        when upper ( A.formatted_address ) like '%DROMANA FORESHORE%' then 'DROMANA FORESHORE'
        when upper ( A.formatted_address ) like '%EARIMIL BEACH NORTH%' then 'EARIMIL BEACH NORTH'
        when upper ( A.formatted_address ) like '%EARIMIL BEACH SOUTH%' then 'EARIMIL BEACH SOUTH'
        when upper ( A.formatted_address ) like '%FISHERMANS BEACH FORESHORE%' then 'FISHERMANS BEACH FORESHORE'
        when upper ( A.formatted_address ) like '%FISHERMANS BEACH%' then 'FISHERMANS BEACH'
        when upper ( A.formatted_address ) like '%HAWKER BEACH%' then 'HAWKER BEACH'
        when upper ( A.formatted_address ) like '%MILLS BEACH%' then 'MILLS BEACH'
        when upper ( A.formatted_address ) like '%MOONDAH BEACH%' then 'MOONDAH BEACH'
        when upper ( A.formatted_address ) like '%MOUNT MARTHA BEACH NORTH%' then 'MOUNT MARTHA BEACH NORTH'
        when upper ( A.formatted_address ) like '%MOUNT MARTHA BEACH SOUTH%' then 'MOUNT MARTHA BEACH SOUTH'
        when upper ( A.formatted_address ) like '%POINT KING FORESHORE%' then 'POINT KING FORESHORE'
        when upper ( A.formatted_address ) like '%PORTSEA FORESHORE%' then 'PORTSEA FORESHORE'
        when upper ( A.formatted_address ) like '%RANELAGH BEACH%' then 'RANELAGH BEACH'
        when upper ( A.formatted_address ) like '%ROSEBUD FORESHORE%' then 'ROSEBUD FORESHORE'
        when upper ( A.formatted_address ) like '%RYE FORESHORE%' then 'RYE FORESHORE'
        when upper ( A.formatted_address ) like '%SAFETY BEACH FORESHORE%' then 'SAFETY BEACH FORESHORE'
        when upper ( A.formatted_address ) like '%SCOUT BEACH%' then 'SCOUT BEACH'
        when upper ( A.formatted_address ) like '%SHELLEY BEACH FORESHORE%' then 'SHELLEY BEACH FORESHORE'
        when upper ( A.formatted_address ) like '%SHIRE HALL BEACH%' then 'SHIRE HALL BEACH'
        when upper ( A.formatted_address ) like '%SOMERS FORESHORE%' then 'SOMERS FORESHORE'
        when upper ( A.formatted_address ) like '%SORRENTO FORESHORE%' then 'SORRENTO FORESHORE'
        when upper ( A.formatted_address ) like '%TYRONE FORESHORE%' then 'TYRONE FORESHORE'
        when upper ( A.formatted_address ) like '%WESTERNPORT GARDENS RETIREMENT VILLAGE%' then 'WESTERNPORT GARDENS RETIREMENT VILLAGE'
        when upper ( A.formatted_address ) like '%WHITECLIFFS-CAMERONS BIGHT FORESHORE%' then 'WHITECLIFFS-CAMERONS BIGHT FORESHORE'
        else ''
    end as complex_name,
    '' as house_prefix_1,
    case
        when A.modifier_desc = 'BTSD' then ''
        when A.house_no = 0 then ''
        else cast ( ifnull ( A.house_no , '' ) as varchar )
    end as house_number_1,
    case
        when A.modifier_desc = 'BTSD' then ''
        else upper ( ifnull ( A.house_no_suffix , '' ) )
    end as house_suffix_1,
    '' as house_prefix_2,
    case
        when A.modifier_desc = 'BTSD' then ''
        when A.house_no_to = 0 then ''
        else cast ( ifnull ( A.house_no_to , '' ) as varchar )
    end as house_number_2,
    upper ( ifnull ( A.house_no_to_suffix , '' ) ) as house_suffix_2,
    case
        when upper ( S.street_name ) = 'A''BECKETT CLOSE' then 'ABECKETT'
        when upper ( S.street_name ) = 'TANKERTON ESTATE' then ''
        when S.street_name like 'THE %' then
            case upper ( S.street_name )
                when 'THE BITTERN BOULEVARD' then 'THE BITTERN'
                when 'THE CUPS DRIVE' then 'THE CUPS'
                when 'THE RIDGE ROAD' then 'THE RIDGE'
                when 'THE SHEEDY WAY' then 'THE SHEEDY'
                else upper ( S.street_name )
            end
        when S.street_name like '% OFF %' then
            case
                when S.street_name like '% OFF POINT NEPEAN ROAD' then 'POINT NEPEAN'
                when S.street_name like '% OFF PT NEPEAN RD' then 'POINT NEPEAN'
                when S.street_name like '% OFF ESPLANADE' then 'ESPLANADE'
                when S.street_name like '% OFF EARIMIL DRIVE' then 'EARIMIL'
                when S.street_name like '% OFF STURIO PARADE' then 'STURIO'
                when S.street_name like '% OFF POINT KING ROAD' then 'POINT KING'
                when S.street_name like '% OFF ROSSERDALE CRESCENT' then 'ROSSERDALE'
                when S.street_name like '% OFF MARINE DRIVE' then 'MARINE'
                when S.street_name like '% OFF SOUTH BEACH RD' then 'SOUTH BEACH'
                when S.street_name like '% OFF SUNNYSIDE ROAD' then 'SUNNYSIDE'
                when S.street_name like '% OFF FREEMANS ROAD' then 'FREEMANS'
                when S.street_name like '% OFF DAVEYS BAY ROAD' then 'DAVEYS BAY'
                when S.street_name like '% OFF THE ESPLANADE' then 'THE ESPLANADE'
                else upper ( S.street_name )
            end
        when upper ( substr ( S.street_name , -4 ) ) in ( ' END', ' ROW', ' RUN', ' KEY', ' WAY' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 4 ) )
        when upper ( substr ( S.street_name , -5 ) ) in ( ' BEND', ' BRAE', ' COVE' , ' EDGE' , ' LANE', ' LINK', ' MEWS', ' NOOK' , ' QUAY', ' RISE', ' ROAD', ' VIEW', ' WALK', ' WYND' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 5 ) )
        when upper ( substr ( S.street_name , -6 ) ) in ( ' BEACH', ' CLOSE' , ' COURT' , ' CREST' , ' DRIVE', ' GLADE', ' GREEN', ' GROVE', ' HEATH', ' PLACE', ' PLAZA', ' POINT', ' RIDGE', ' ROUND', ' SLOPE' , ' STRIP', ' TRACK', ' VISTA' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 6 ) )
        when upper ( substr ( S.street_name , -7 ) ) in ( ' ACCESS', ' ARCADE', ' AVENUE', ' CIRCLE', ' COURSE', ' DIVIDE', ' GRANGE', ' PARADE', ' SQUARE', ' STREET', ' WATERS' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 7 ) )
        when upper ( substr ( S.street_name , -8 ) ) in ( ' CIRCUIT', ' CUTTING', ' FREEWAY', ' GARDENS', ' HIGHWAY', ' PARKWAY', ' RETREAT', ' TERRACE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 8 ) )
        when upper ( substr ( S.street_name , -9 ) ) in ( ' CRESCENT', ' CROSSING', ' QUADRANT' , ' WATERWAY' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 9 ) )
        when upper ( substr ( S.street_name , -10 ) ) in ( ' BOULEVARD', ' ESPLANADE' , ' FORESHORE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 10 ) )
        when upper ( substr ( S.street_name , -11 ) ) in ( ' BOULEVARDE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 11 ) )
        when upper ( substr ( S.street_name , -10 ) ) in ( ' ROAD EAST', ' ROAD WEST', ' WAY NORTH' , ' WAY SOUTH' , ' LANE EAST' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 10 ) )
        when upper ( substr ( S.street_name , -11 ) ) in ( ' GROVE EAST' , ' GROVE WEST', ' LANE NORTH' , ' LANE SOUTH' , ' ROAD NORTH' , ' ROAD SOUTH' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 11 ) )
        when upper ( substr ( S.street_name , -12 ) ) in ( ' CLOSE NORTH' , ' CLOSE SOUTH' , ' COURT NORTH' , ' COURT SOUTH' , ' DRIVE NORTH' , ' DRIVE SOUTH' , ' STREET EAST' , ' STREET WEST' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 12 ) )
        when upper ( substr ( S.street_name , -13 ) ) in ( ' AVENUE NORTH' , ' AVENUE SOUTH' , ' STREET NORTH' , ' STREET SOUTH' , ' PARADE NORTH' , ' PARADE SOUTH' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 13 ) )
        when upper ( substr ( S.street_name , -14 ) ) in ( ' HIGHWAY NORTH' , ' HIGHWAY SOUTH' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 14 ) )
        else upper ( S.street_name )
    end as road_name,
    case
        when S.street_name like 'THE %' then
            case upper ( S.street_name )
                when 'THE BITTERN BOULEVARD' then 'BOULEVARD'
                when 'THE CUPS DRIVE' then 'DRIVE'
                when 'THE RIDGE ROAD' then 'ROAD'
                when 'THE SHEEDY WAY' then 'WAY'
                else ''
            end
        when S.street_name like '% ARCADE%' then 'ARCADE'
        when S.street_name like '% AVENUE%' then 'AVENUE'
        when S.street_name like '% BEND%' then 'BEND'
        when S.street_name like '% BOULEVARD%' then 'BOULEVARD'
        when S.street_name like '% BRAE%' then 'BRAE'
        when S.street_name like '% CIRCLE%' then 'CIRCLE'
        when S.street_name like '% CIRCUIT%' then 'CIRCUIT'
        when S.street_name like '% CLOSE%' then 'CLOSE'
        when S.street_name like '% COURT%' then 'COURT'
        when S.street_name like '% CRESCENT%' then 'CRESCENT'
        when S.street_name like '% CROSSING%' then 'CROSSING'
        when S.street_name like '% CUTTING%' then 'CUTTING'
        when S.street_name like '% DIVIDE%' then 'DIVIDE'
        when S.street_name like '% DRIVE%' then 'DRIVE'
        when S.street_name like '% ESPLANADE%' and S.street_name not like '% OFF ESPLANADE%' and S.street_name not like '%THE ESPLANADE%' then 'ESPLANADE'
        when S.street_name like '% FREEWAY%' then 'FREEWAY'
        when S.street_name like '% GARDENS%' then 'GARDENS'
        when S.street_name like '% GLADE%' then 'GLADE'
        when S.street_name like '% GREEN%' then 'GREEN'
        when S.street_name like '% GRANGE%' then 'GRANGE'
        when S.street_name like '% GROVE%' then 'GROVE'
        when S.street_name like '% HEATH%' then 'HEATH'
        when S.street_name like '% HIGHWAY%' then 'HIGHWAY'
        when S.street_name like '% LANE%' then 'LANE'
        when S.street_name like '% MEWS%' then 'MEWS'
        when S.street_name like '% PARADE%' then 'PARADE'
        when S.street_name like '% PARKWAY%' then 'PARKWAY'
        when S.street_name like '% PLACE%' then 'PLACE'
        when S.street_name like '% PLAZA%' then 'PLAZA'
        when S.street_name like '% QUAY%' then 'QUAY'
        when S.street_name like '% RETREAT%' then 'RETREAT'
        when S.street_name like '% RIDGE%' then 'RIDGE'
        when S.street_name like '% ROAD%' then 'ROAD'
        when S.street_name like '% RD%' then 'ROAD'
        when S.street_name like '% ROUND%' then 'ROUND'
        when S.street_name like '% RUN%' then 'RUN'
        when S.street_name like '% SQUARE%' then 'SQUARE'
        when S.street_name like '% STREET%' then 'STREET'
        when S.street_name like '% ST' then 'STREET'
        when S.street_name like '% ST %' then 'STREET'
        when S.street_name like '% STRIP%' then 'STRIP'
        when S.street_name like '% TERRACE%' then 'TERRACE'
        when S.street_name like '% TRACK%' then 'TRACK'
        when S.street_name like '% VISTA%' then 'VISTA'
        when S.street_name like '% WALK%' then 'WALK'
        when S.street_name like '% WATERS%' then 'WATERS'
        when S.street_name like '% WATERWAY%' then 'WATERWAY'
        when S.street_name like '% WAY%' then 'WAY'
        when S.street_name like '% WYND%' then 'WYND'
        when S.street_name like '% ACCESS%' then 'ACCESS'
        when S.street_name like '% BEACH%' and S.street_name not like '% OFF %' then 'BEACH'
        when S.street_name like '% COVE%' then 'COVE'
        when S.street_name like '% FORESHORE%' then 'FORESHORE'
        when S.street_name like '% LINK%' then 'LINK'
        when S.street_name like '% POINT%' then 'POINT'
        when S.street_name like '% RISE%' then 'RISE'
        when S.street_name like '% VIEW%' then 'VIEW'
        else ''
    end as road_type,
    case
        when S.street_name like '% NORTH' then 'N'
        when S.street_name like '% SOUTH' then 'S'
        when S.street_name like '% EAST' then 'E'
        when S.street_name like '% WEST' then 'W'
        else ''
    end as road_suffix,
    L.locality_name as locality_name,
    L.postcode as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    case P.electorate
        when 'French' then '379'
        else '352'
    end as lga_code,
    '' as crefno,
    A.formatted_address as summary
from
    techone_nucproperty P
    join techone_nucaddress A on A.property_no = P.property_no
    join techone_nucstreet S on S.street_no = A.street_no
    join techone_nuclocality L on L.locality_ctr = S.locality_ctr
where
    P.status <> 'P' and
    P.property_type_desc not in ( 'LUR' , 'RoadReserv' , 'CornerSpla' , 'InactRecor' , 'Laneway' , 'PermOcc' , 'Pms Blocks' ) and
    P.rate_analysis_desc not in ( 'R FarmHous' )
)
)
)
