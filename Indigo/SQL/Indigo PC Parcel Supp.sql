select
    '' as LandParcelNumber,
    vp.propnum as Property,
    '' as TypeID,
    case vp.plan_prefix
        when 'CP' then 'Consolidation Plan'
        when 'LP' then 'Lodged Plan'
        when 'PC' then 'Plan of Consolidation'
        when 'PS' then 'Plan of Subdivision'
        when 'RP' then 'Strata Plan'
        when 'SP' then 'Stratum Plan'
        when 'TP' then 'Title Plan'
        else ''
    end as Type,
    vp.plan_prefix as TypeAbrev,
    '' as TypeExt,
    vp.lot_number as Lot,
    vp.plan_number as PlanNo,
    vp.allotment as CrownAllotment,
    vp.portion as CrownPortion,
    vp.sec as Section,
    vp.township_code as Township,
    vp.parish_code as Parish,
    '' as Volume,
    '' as Folio,
    '' as Commenced,
    '' as Ended,
    'Active' as Status,
    vp.parcel_pfi as PersistantFeatureID,
    vp.spi as StandardParcelID,
    cp.lot as "Comments (reference only; not for loading)"
from
    pc_vicmap_parcel vp join
        ( select cast ( Property as varchar ) "propnum" , *
        from lynx_propertys
        where Property not in ( select PropertyNumber from lynx_vwlandparcel )
        ) cp on vp.propnum = cp.propnum
where
    ( vp.plan_numeral = '' or ( vp.plan_numeral <> '' and cp.lot like '%' || vp.plan_numeral || '%' ) ) and   
    ( vp.lot_number = '' or ( vp.lot_number <> '' and cp.lot like '%LOT %' || vp.lot_number || '%' ) ) and
    ( vp.sec = '' or ( vp.sec <> '' and cp.lot like '%SEC %' || vp.sec || '%' ) ) and
    ( vp.allotment = '' or ( vp.allotment <> '' and cp.lot like '%' || vp.allotment || ' %' ) )
order by cast ( vp.propnum as integer )