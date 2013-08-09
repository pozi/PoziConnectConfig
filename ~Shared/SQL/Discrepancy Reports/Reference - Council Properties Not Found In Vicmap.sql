select
    *
from
    PC_Vicmap_Property_Address
where
    propnum is not null and
    propnum is not 'NCPR' and
    propnum not in ( select propnum from PC_Council_Property_Address )