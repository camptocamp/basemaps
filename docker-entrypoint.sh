#!/bin/bash

make -C /etc/mapserver/ all
mv /etc/mapserver/osm-${STYLE}.map /etc/mapserver/mapserver.map

exec "$@"
