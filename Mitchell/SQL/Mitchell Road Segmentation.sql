select
    x.assetid,
    x.type,
    x.start_road as AssetStartRoad,
    x.parentID,
    trim(r.AssetDescription) as ParentDesc,
    cast(x.ch1 as double) as ch1_orig,
    cast(x.ch2 as double) as ch2_orig,
    case
        when (
            select count(*)
            from conquest_roads c
            where
                substr(c.AssetDescription,1,3)=substr(upper(start_road),1,3) and
                ST_Distance(c.geometry,ST_StartPoint(r.geometry))<50) >0 then 1
        else 0
    end as FlagDirection1,
    case
        when (
            select count(*)
            from conquest_roads c
            where
                substr(c.AssetDescription,1,3)=substr(upper(start_road),1,3) and
                ST_Distance(c.geometry,ST_EndPoint(r.geometry))<50)>0 then 1
        else 0
    end as FlagDirection2,
    cast(x.ch1 as double)/ST_Length(r.geometry)*1000 as ch1_frac,
    min(1.0,cast(x.ch2 as double)/ST_Length(r.geometry)*1000) as ch2_frac,
    r.geometry

from
    (
        select
                AssetID,
                "Segment Start Point / Chainage" as ch1,
                "Segment End Point / Chainage" as ch2,
                ParentID,"Road Start Point" as start_road,
                'SEALS' as type
            from conquest_roads_seals

        union
        
        select
                AssetID,
                "Segment Start Point / Chainage",
                "Segment End Point / Chainage",
                ParentID,"Road Start Point",
                'FORMATIONS'
            from conquest_formations

        union
        
        select
                AssetID,
                "Segment Start Point / Chainage",
                "Segment End Point / Chainage",
                ParentID,"Road Start Point",
                'PAVEMENT - SEALED'
            from conquest_pavement_sealed

        union
        
        select
                AssetID,
                "Segment Start Point / Chainage",
                "Segment End Point / Chainage",
                ParentID,"Road Start Point",
                'PAVEMENT - UNSEALED'
            from conquest_pavement_unsealed
    ) x,
    conquest_roads r
where
    x.ParentID = r.AssetID
order by
    r.AssetID,
    x.type,x.ch1