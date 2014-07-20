select
    Parish.parish_name name,
    Parish.parish_code code
from
    vmadmin_parish_polygon Parish,
    vmadmin_lga_polygon LGA
where
    st_intersects ( LGA.geometry , Parish.geometry ) and
    LGA.lga_code = 314

union

select
    Township.township_name name,
    Township.township_code code
from
    vmadmin_township_polygon Township,
    vmadmin_lga_polygon LGA
where
    st_intersects ( LGA.geometry , Township.geometry ) and
    LGA.lga_code = 314

order by
    code