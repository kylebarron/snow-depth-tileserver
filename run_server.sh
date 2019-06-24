#! /usr/bin/env bash
docker run --rm -it -v $(pwd):/data -p 8080:80 klokantech/tileserver-gl --mbtiles data/snow_depth.mbtiles --verbose
