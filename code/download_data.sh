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

# Uncomment if I want to keep snow-water equivalent
# mv -f $SWE_FILE.dat.gz swe.dat.gz
# mv -f $SWE_FILE.Hdr.gz swe.Hdr.gz
mv -f $SD_FILE.dat.gz snow_depth.dat.gz
mv -f $SD_FILE.Hdr.gz snow_depth.Hdr.gz

# Delete other files
rm us_ssmv*.gz

# Extract files of interest
gunzip snow_depth.dat.gz
gunzip snow_depth.Hdr.gz

# Move to data folder
mv snow_depth.dat ../data/
mv snow_depth.Hdr ../data/
