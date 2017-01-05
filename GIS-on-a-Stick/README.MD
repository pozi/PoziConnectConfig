## GIS on a Stick

#### Notes:

#### Things to change:

* Vicmap Railways are showing disused railway. (only show railway from PTV?)
* add labels to waterways and water bodies
* add name labels to open space / forests
* remove planning growth boundary (duplicate data with growth area)
* add parcel table
* add CMA boundary
* vicmap hydro isn't being used? add it to replace water from vicmap lite?
* Drop some vicmap lite tables? data duplicated by transport / hydro / admin
* Trunkate all tables on import for unneeded fields
* PTV missing layers. only show routes and stops for tram and bus.
* PTV for train only track and stations.
* Public land is shown from vicmaplite not CL_tenure

#### Layers to order from Spatial Datamart

Whole of State : VIC
Mapinfo TAB file
Geographicals on GDA-94

Cadastre & Land Description > PLM25 (Public Land Management)
Cadastre & Land Description > VICMAP_ADDRESS
Cadastre & Land Description > VICMAP_CLTENURE_BASIC

Biology & Ecology > VICMAP_VEGETATION

Admin & Political Boundaries > Vicmap Admin
Admin & Political Boundaries > Vicmap Planning
Elevation > Vicmap Elevation
Vicmap Lite

Vicmap Crown Land Tenure
Vicmap Features of Interest

VMPROP map-polygons, Parcel and Property > VMPROP_S_PARCEL_MP
VMPROP map-polygons, Parcel and Property > VMPROP_S_PROPERTY_MP
Vicmap Property datasets > VMPROP_PARCEL_PROPERTY
Biology & Ecology > VICMAP_VEGETATION
Inland Water Resources > VICMAP_HYDRO
Transportation Networks > VICMAP_TRANSPORT
Transportation Networks > PTV (all)
* PTV Train Station
* PTV Bus Route Metro
* PTV Tram Stop
* PTV Tram Track Centreline
* PTV Bus Route Regional
* PTV Train Corridor Centreline
* PTV Train Track Centreline
* PTV Tram Route
* PTV Train Station Platform
* PTV Bus Stop