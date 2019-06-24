#! /usr/bin/env bash
# Download SNODAS data

YEAR=$(date +%Y)
MONTH_NUM=$(date +%m)
MONTH_SHORT=$(date +%b)
DATE_DIGITS=$(date +%Y%m%d)

# Create URL
URL=ftp://sidads.colorado.edu/DATASETS/NOAA/G02158/masked/$YEAR/${MONTH_NUM}_${MONTH_SHORT}/SNODAS_${DATE_DIGITS}.tar

# Download file from FTP server
wget $URL

# If file was not found, use yesterday's date
rc=$?
if [[ $rc != 0 ]]; then

  YEAR=$(date +%Y --date='yesterday')
  MONTH_NUM=$(date +%m --date='yesterday')
  MONTH_SHORT=$(date +%b --date='yesterday')
  DATE_DIGITS=$(date +%Y%m%d --date='yesterday')

  # Create URL
  URL=ftp://sidads.colorado.edu/DATASETS/NOAA/G02158/masked/$YEAR/${MONTH_NUM}_${MONTH_SHORT}/SNODAS_${DATE_DIGITS}.tar

  # Download file from FTP server
  wget $URL

  # If yesterday's data not found, exit
  rc=$?; if [[ $rc != 0 ]]; then
    echo "Yesterday's SNODAS data not found"
    exit $rc
  fi
fi

# Saved as SNODAS_YYYYMMDD.tar
# Extract from tarball
tar xvf SNODAS_${DATE_DIGITS}.tar

# Keep only snow depth files
rm SNODAS_${DATE_DIGITS}.tar

# SWE and snow depth files have the format:
SWE_FILE=us_ssmv11034tS__T0001TTNATS${DATE_DIGITS}*HP001
SD_FILE=us_ssmv11036tS__T0001TTNATS${DATE_DIGITS}*HP001

# Extract files of interest
gunzip $SD_FILE.dat.gz
gunzip $SD_FILE.Hdr.gz

mkdir -p ../data/
mv -f $SD_FILE.dat ../data/
mv -f $SD_FILE.Hdr ../data/

# Delete other files
rm us_ssmv*.gz

# Create MBTiles from SNODAS Snow Depth
gdaldem color-relief ../data/$SD_FILE.Hdr colors.txt ../data/snow_depth.tiff -of GTiff
gdal_translate ../data/snow_depth.tiff ../data/snow_depth.mbtiles
gdaladdo -r average ../data/snow_depth.mbtiles
