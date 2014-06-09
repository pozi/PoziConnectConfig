select distinct p.prop_propnum,o.zone_code
from vmprop_property_mp p, vmplan_plan_overlay o
where p.prop_lga_code='371' and o.lga_code='371'
and ST_Intersects(p.geometry,o.geometry)
and p.prop_propnum <>''
order by p.prop_propnum,o.zone_code