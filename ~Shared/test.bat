pause

SET GDAL_BASE=C:\PoziConnect\vendor\release-1600-gdal-1-10-0-mapserver-6-2-1\bin
SET GDAL_DATA=C:\PoziConnect\vendor\release-1600-gdal-1-10-0-mapserver-6-2-1\bin\gdal-data
SET PATH=C:\PoziConnect\vendor\release-1600-gdal-1-10-0-mapserver-6-2-1\bin\gdal\apps;C:\PoziConnect\vendor\release-1600-gdal-1-10-0-mapserver-6-2-1\bin;C:\PoziConnect\vendor\release-1600-gdal-1-10-0-mapserver-6-2-1\bin\gdal-data;%PATH%


C:\PoziConnect\vendor\release-1600-gdal-1-10-0-mapserver-6-2-1\bin\gdal\apps\ogrinfo -sql "DELETE FROM TMP_VM_PROPERTY_PARCEL WHERE LGA_CODE<>363" "C:\PoziConnect\Output\Stonnington.sqlite"

pause