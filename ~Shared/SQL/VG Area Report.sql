select p.prop_propnum,cast(round(ST_Area(ST_Transform(p.geometry,28354))) as integer) as area,'M' as unit
from vmprop_property_mp p
where p.prop_lga_code='371'
and p.prop_propnum <>''
order by p.prop_propnum