#! /usr/bin/env bash
# Download SNODAS data
set -e -x
YEAR=$(date +%Y)
MONTH_NUM=$(date +%m)
MONTH_SHORT=$(date +%b)
DATE_DIGITS=$(date +%Y%m%d)

# Create URL
URL=ftp://sidads.colorado.edu/DATASETS/NOAA/G02158/masked/$YEAR/${MONTH_NUM}_${MONTH_SHORT}/SNODAS_${DATE_DIGITS}.tar

mkdir -p data
pushd data

# Download file from FTP server
wget $URL

# Saved as SNODAS_YYYYMMDD.tar
# Extract from tarball
tar -xvf SNODAS_${DATE_DIGITS}.tar

# Keep only snow depth files
rm SNODAS_${DATE_DIGITS}.tar

# SWE and snow depth files have the format:
SWE_FILE=us_ssmv11034tS__T0001TTNATS${DATE_DIGITS}*HP001
SD_FILE=us_ssmv11036tS__T0001TTNATS${DATE_DIGITS}*HP001

# Extract files of interest
gunzip $SD_FILE.dat.gz
gunzip $SD_FILE.Hdr.gz

popd

mkdir -p build
# Create MBTiles from SNODAS Snow Depth
gdaldem color-relief data/$SD_FILE.Hdr colors.txt build/snow_depth.tiff -of GTiff -alpha
gdal_translate build/snow_depth.tiff build/snow_depth.mbtiles
gdaladdo -r average build/snow_depth.mbtiles

if [[ -v "S3_URL" ]]; then
  python3 /opt/Processing/upload_mbtiles.py --threads 100 \
      --extension ".png" \
      --header "Cache-Control:max-age=21600" \
      build/snow_depth.mbtiles $S3_URL
fi
