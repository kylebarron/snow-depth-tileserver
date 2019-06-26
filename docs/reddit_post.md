In light of yesterday's post about snow safety, I thought I'd share how to get a snow depth map overlay for Caltopo and Gaia GPS. Only Caltopo lets you import NOAA's feed directly, so over the last few days I set up an auto-updating map layer compatible with Gaia. It uses the same [NOAA data](https://nsidc.org/data/g02158) and both use the [same](https://idpgis.ncep.noaa.gov/arcgis/rest/services/NWS_Observations/NOHRSC_Snow_Analysis/MapServer/legend) [scale](https://github.com/kylebarron/snow-depth-tileserver#map-legend). With Gaia you can download the layer for offline use on your phone (subscription required). It should automatically update next time you have service. 

[Here are screenshots in action.](https://imgur.com/a/mnVvzTx)

### Instructions
#### Caltopo

While snow depth [may at some point become an official layer](http://help.caltopo.com/discussions/maps/647-noaa-snow-depth-layer), currently Caltopo only supports the limited SNOTEL sensors. 

To import NOAA's layer directly, go to `+ Add > Add New Layer > Custom Source`. Then change `Type` to `WMS`, give a name like `Snow Depth`, change `Overlay?` to `Yes`, and paste in the following URL for `URL Template`:
```
https://idpgis.ncep.noaa.gov/arcgis/rest/services/NWS_Observations/NOHRSC_Snow_Analysis/MapServer/export?dpi=96&transparent=true&format=png8&layers=show:3&bbox={left},{bottom},{right},{top}&bboxSR=102100&imageSR=102100&size={tilesize},{tilesize}&f=image
```
[Here are screenshots.](https://imgur.com/a/8HMMURR)

#### Gaia GPS

To add my snow depth overlay to Gaia, go to <https://www.gaiagps.com/mapsource/add/>, name the map something like `Snow Depth`, then paste the following map link
```
https://snowdepth.us/data/snow_depth/{z}/{x}/{y}.png
```
and set minimum zoom to 2, **maximum zoom to 7**, and click `Add this map source`.

The map layer should automatically sync with your phone. The layer can be found in the `Custom Imports` section when adding map layers to your library.

### Notes

The two layers might look slightly different when zoomed in because I create a gradient across cells, so it doesn't look so pixelated. The code to create the map server is [open source](https://github.com/kylebarron/snow-depth-tileserver).

Let me know if you have feedback. The server cost is $5/month, so I can't promise that I'll leave it running indefinitely, but I plan to for at least a couple years. 

