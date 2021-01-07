#!/bin/bash

HOSTNAME=`hostname`
echo "# Direction le bon dossier : /var/www/vhosts/ppcarto/private/osm"
cd /var/www/vhosts/ppcarto/private/osm/osm_pbf

echo "# Début de mise à jour des tuiles OSM"
rm -f *.osm.pbf

wget http://download.geofabrik.de/europe/france/poitou-charentes-latest.osm.pbf
wget http://download.geofabrik.de/europe/france/centre-latest.osm.pbf

source venv/bin/activate
cd ..
rm -f imposm-mapping.py

echo "# Copie du fichier imposm-mapping.py depuis le répertoire basemaps"
cp ../basemaps/imposm-mapping.py ./
##wget https://raw.githubusercontent.com/camptocamp/basemaps/capc-test/imposm-mapping.py

echo "# Import de données PBF"
imposm -m imposm-mapping.py --read --overwrite-cache osm_pbf/poitou-charentes-latest.osm.pbf
echo "  -> fin poitou-charentes"
imposm -m imposm-mapping.py --read --merge-cache osm_pbf/centre-latest.osm.pbf
echo "  -> fin centre"
imposm -m imposm-mapping.py --write -d osm --connection postgis://www-data:www-data@localhost/osm --proj EPSG:2154
echo "  -> fin import base"
imposm -m imposm-mapping.py --optimize --connection postgis://www-data:www-data@localhost/osm
echo "  -> fin optimisation"

echo "# Creation des tables et définition des droits"
sudo -u www-data psql -d osm -c "DROP TABLE IF EXISTS osm_new_waterways_gen0;CREATE TABLE osm_new_waterways_gen0 AS SELECT * FROM osm_new_waterways;"
sudo -u www-data psql -d osm -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO \"www-data\";"
imposm -m imposm-mapping.py -d osm --deploy-production-tables  --connection postgis://www-data:www-data@localhost/osm

cd /var/www/vhosts/ppcarto/private/basemaps

echo "# C'est tout bon !!"


