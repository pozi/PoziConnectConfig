select
    x.assetid,
    x.type,
    x.start_road as AssetStartRoad,
    x.parentID,
    trim(r.AssetDescription) as ParentDesc,
    cast(x.ch1 as double) as ch1_orig,
    cast(x.ch2 as double) as ch2_orig,
    case
        when
            (
                select count(*)
                from conquest_roads c
                where
                    substr(c.AssetDescription,1,3)=substr(upper(start_road),1,3) and
                    ST_Distance(c.geometry,ST_StartPoint(r.geometry)) < 50
            ) > 0 then 1
        else 0
    end as FlagDirection1,
    case
        when
            (
                select count(*)
                from conquest_roads c
                where
                    substr(c.AssetDescription,1,3)=substr(upper(start_road),1,3) and
                    ST_Distance(c.geometry,ST_EndPoint(r.geometry)) < 50
            ) > 0 then 1
        else 0
    end as FlagDirection2,
    cast(x.ch1 as double)/ST_Length(r.geometry)*1000 as ch1_frac,
    min(1.0,cast(x.ch2 as double)/ST_Length(r.geometry)*1000) as ch2_frac,
    r.geometry

from
    (
        select
                assetid,
                start_ch as ch1,
                finish_ch as ch2,
                parentid,
                roadstart as start_road,
                'SEALS' as type
            from conquest_seals
            
        union

        select
                assetid,
                start_ch as ch1,
                finish_ch as ch2,
                parentid,
                roadstart as start_road,
                'PAVEMENT - SEALED' as type
            from conquest_pavements
    ) x,
    conquest_roads r
where
    x.ParentID = r.AssetID
order by
    r.AssetID,
    x.type,x.ch1
