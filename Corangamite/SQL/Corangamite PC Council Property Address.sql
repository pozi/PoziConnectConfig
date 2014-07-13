select
    cast ( P.property_no as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when A.floor_desc = 'DS' then 'DOWNSTAIRS'
        when A.floor_desc = 'US' then 'UPSTAIRS'
        else ''
    end as location_descriptor,
    ifnull ( A.unit_desc , '' ) as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when A.unit_no = '0' then ''
        else ifnull ( A.unit_no , '' )
    end as blg_unit_id_1,
    upper ( ifnull ( A.unit_no_suffix , '' ) ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when A.unit_no_to = '0' then ''
        else ifnull ( A.unit_no_to , '' )
    end as blg_unit_id_2,
    upper ( ifnull ( A.unit_no_to_suffix , '' ) ) as blg_unit_suffix_2,
    case
        when A.floor_no = '0' then ''
        else ifnull ( A.floor_no , '' )
    end as floor_no_1,
    upper ( ifnull ( A.floor_suffix , '' ) ) as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when A.floor_no_to = '0' then ''
        else ifnull ( A.floor_no_to , '' )
    end as floor_no_2,
    upper ( ifnull ( A.floor_suffix_to , '' ) ) as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as house_prefix_1,
    case
        when A.house_no = '0' then ''
        else ifnull ( A.house_no , '' )
    end as house_number_1,
    upper ( ifnull ( A.house_no_suffix , '' ) ) as house_suffix_1,
    case
        when A.house_no_to = '0' then ''
        else ifnull ( A.house_no_to , '' )
    end as house_number_2,
    upper ( ifnull ( A.house_no_to_suffix , '' ) ) as house_suffix_2,

    UPPER ( RTRIM ( CASE

        WHEN S.street_name LIKE 'THE %' THEN S.street_name

        WHEN S.street_name LIKE '% ARCADE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% ARCADE%', S.street_name  ) )
        WHEN S.street_name LIKE '% AVENUE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% AVENUE%' , S.street_name ) )
        WHEN S.street_name LIKE '% BOULEVARD%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% BOULEVARD%' , S.street_name ) )
        WHEN S.street_name LIKE '% CIRCUIT%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% CIRCUIT%' , S.street_name ) )
        WHEN S.street_name LIKE '% CLOSE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% CLOSE%' , S.street_name ) )
        WHEN S.street_name LIKE '% COURT%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% COURT%' , S.street_name ) )
        WHEN S.street_name LIKE '% CRESCENT%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% CRESCENT%' , S.street_name ) )
        WHEN S.street_name LIKE '% CUTTING%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% CUTTING%' , S.street_name ) )
        WHEN S.street_name LIKE '% DRIVE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% DRIVE%' , S.street_name ) )
        WHEN S.street_name LIKE '% FREEWAY%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% FREEWAY%' , S.street_name ) )
        WHEN S.street_name LIKE '% GROVE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% GROVE%' , S.street_name ) )
        WHEN S.street_name LIKE '% HIGHWAY%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% HIGHWAY%' , S.street_name ) )
        WHEN S.street_name LIKE '% LANE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% LANE%' , S.street_name ) )
        WHEN S.street_name LIKE '% PARADE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% PARADE%' , S.street_name ) )
        WHEN S.street_name LIKE '% PLACE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% PLACE%' , S.street_name ) )
        WHEN S.street_name LIKE '% PLAZA%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% PLAZA%' , S.street_name ) )
        WHEN S.street_name LIKE '% ROAD %' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% ROAD %' , S.street_name ) )
        WHEN S.street_name LIKE '% ROAD%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% ROAD%' , S.street_name ) )
        WHEN S.street_name LIKE '% RD%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% RD%' , S.street_name ) )
        WHEN S.street_name LIKE '% ROUND%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% ROUND%' , S.street_name ) )
        WHEN S.street_name LIKE '% RUN%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% RUN%' , S.street_name ) )
        WHEN S.street_name LIKE '% SQUARE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% SQUARE%' , S.street_name ) )
        WHEN S.street_name LIKE '% ST' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% ST' , S.street_name ) )
        WHEN S.street_name LIKE '% STREET%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% STREET%' , S.street_name ) )
        WHEN S.street_name LIKE '% TERRACE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% TERRACE%' , S.street_name ) )
        WHEN S.street_name LIKE '% TRACK%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% TRACK%' , S.street_name ) )
        WHEN S.street_name LIKE '% VISTA%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% VISTA%' , S.street_name ) )
        WHEN S.street_name LIKE '% WALK%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% WALK%' , S.street_name ) )
        WHEN S.street_name LIKE '% WAY%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% WAY%' , S.street_name ) )

        WHEN S.street_name LIKE '% ACCESS%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% ACCESS%', S.street_name  ) )
        WHEN S.street_name LIKE '% RISE%' THEN SUBSTRING ( S.street_name , 1 , PATINDEX ( '% RISE%' , S.street_name ) )

        ELSE S.street_name

        END ) ) as "street_name",

    CASE

        WHEN S.street_name LIKE 'THE %' THEN ''

        WHEN S.street_name LIKE '% ARCADE%' THEN 'ARCADE'
        WHEN S.street_name LIKE '% AVENUE%' THEN 'AVENUE'
        WHEN S.street_name LIKE '% BOULEVARD%' THEN 'BOULEVARD'
        WHEN S.street_name LIKE '% CIRCUIT%' THEN 'CIRCUIT'
        WHEN S.street_name LIKE '% CLOSE%' THEN 'CLOSE'
        WHEN S.street_name LIKE '% COURT%' THEN 'COURT'
        WHEN S.street_name LIKE '% CRESCENT%' THEN 'CRESCENT'
        WHEN S.street_name LIKE '% CUTTING%' THEN 'CUTTING'
        WHEN S.street_name LIKE '% DRIVE%' THEN 'DRIVE'
        WHEN S.street_name LIKE '% FREEWAY%' THEN 'FREEWAY'
        WHEN S.street_name LIKE '% GROVE%' THEN 'GROVE'
        WHEN S.street_name LIKE '% HIGHWAY%' THEN 'HIGHWAY'
        WHEN S.street_name LIKE '% LANE%' THEN 'LANE'
        WHEN S.street_name LIKE '% PARADE%' THEN 'PARADE'
        WHEN S.street_name LIKE '% PLACE%' THEN 'PLACE'
        WHEN S.street_name LIKE '% PLAZA%' THEN 'PLAZA'
        WHEN S.street_name LIKE '% QUAY%' THEN 'QUAY'
        WHEN S.street_name LIKE '% ROAD%' THEN 'ROAD'
        WHEN S.street_name LIKE '% RD%' THEN 'ROAD'
        WHEN S.street_name LIKE '% ROUND%' THEN 'ROUND'
        WHEN S.street_name LIKE '% RUN%' THEN 'RUN'
        WHEN S.street_name LIKE '% SQUARE%' THEN 'SQUARE'
        WHEN S.street_name LIKE '% STREET%' THEN 'STREET'
        WHEN S.street_name LIKE '% ST' THEN 'STREET'
        WHEN S.street_name LIKE '% ST %' THEN 'STREET'
        WHEN S.street_name LIKE '% TERRACE%' THEN 'TERRACE'
        WHEN S.street_name LIKE '% TRACK%' THEN 'TRACK'
        WHEN S.street_name LIKE '% VISTA%' THEN 'VISTA'
        WHEN S.street_name LIKE '% WALK%' THEN 'WALK'
        WHEN S.street_name LIKE '% WAY%' THEN 'WAY'

        WHEN S.street_name LIKE '% ACCESS%' THEN 'ACCESS'
        WHEN S.street_name LIKE '% RISE%' THEN 'RISE'

        ELSE ''
    END as "street_type",

    CASE
        WHEN S.street_name LIKE '% NORTH' THEN 'N'
        WHEN S.street_name LIKE '% SOUTH' THEN 'S'
        WHEN S.street_name LIKE '% EAST' THEN 'E'
        WHEN S.street_name LIKE '% WEST' THEN 'W'
        ELSE ''
    END as "street_suffix",

    L.locality_name as "locality",
    L.postcode as "postcode",
    P.property_no AS MI_PRINX

FROM
    nucProperty P(nolock)
    join nucAddress A(nolock) on A.property_no = P.property_no
    join nucStreet S(nolock) on S.street_no = A.street_no
    join nucLocality L(nolock) on L.locality_ctr = S.locality_ctr

WHERE
    P.status <> 'P' and
    P.status <> 'x'
