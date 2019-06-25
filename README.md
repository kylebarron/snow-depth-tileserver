# snow-depth-tileserver

This is a tile server to display snow depth as an overlay.

## Background

While preparing to hike the Pacific Crest trail, I searched and was unable to find snow depth as a layer that could be used with mapping software like Gaia GPS. Caltopo similarly [doesn't have a snow depth layer](http://help.caltopo.com/discussions/maps/647-noaa-snow-depth-layer).

Given available data, I wanted to see if I could build a dynamic map layer.

This map layer uses [NOAA's snow depth data](https://nsidc.org/data/g02158), and should be the same as the [Forest Service interactive map](https://www.fs.fed.us/r5/webmaps/SierraSnowDepth/).

## Using with Gaia GPS

## Map Legend

The legend is the [same as NOAA's](https://idpgis.ncep.noaa.gov/arcgis/rest/services/NWS_Observations/NOHRSC_Snow_Analysis/MapServer/legend):

- ![color](assets/0.svg) 0-1cm (0-0.4in)
- ![color](assets/10.svg) 1-5cm (0.4-2.0in)
- ![color](assets/50.svg) 5-10cm (2.0-3.9in)
- ![color](assets/100.svg) 10-25cm (3.9-9.8in)
- ![color](assets/250.svg) 25-50cm (9.8-20in)
- ![color](assets/500.svg) 50-100cm (20-39in)
- ![color](assets/1000.svg) 100-150cm (39-59in)
- ![color](assets/1500.svg) 150-250cm (59-98in)
- ![color](assets/2500.svg) 250-500cm (98-197in)
- ![color](assets/5000.svg) 500-750cm (197-295in)
- ![color](assets/7500.svg) 750-1000cm (295-394in)
- ![color](assets/10000.svg) 1000+cm (394+in)

## Technical details

### Dependencies

- GDAL. I installed `gdal-bin` from the Ubuntu GIS apt repository, because that gives GDAL 2.4.0, while the standard APT repository gives 2.2, and there's a bug with reading SNODAS data that was fixed in GDAL 2.3.

    ```
    sudo add-apt-repository ppa:ubuntugis/ppa
    sudo apt update
    sudo apt install gdal-bin
    ```

- TileServer GL. This serves the MBTiles as a web application. This requires docker to be installed. (I had trouble installing it with plain Node).

    To run the web server:
    ```
    docker run --rm -it -v $(pwd):/data -p 8080:80 klokantech/tileserver-gl snow_depth.MBTiles
    ```
