#! /usr/bin/env bash
cd ../data/
docker run -d --rm -it -v $(pwd):/data -p 8080:80 klokantech/tileserver-gl --mbtiles snow_depth.mbtiles --verbose
