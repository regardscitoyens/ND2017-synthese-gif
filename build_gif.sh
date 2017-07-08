#!/bin/bash

last=$(ls shots | tail -1)
new=$(date +%y%m%d).png

if [ "$last" = "$new" ]; then
  exit 0
fi

wget -q "https://www.nosdeputes.fr/graphes/groupes/all?mapId=Map_0000.map" -O shots/$new

if diff shots/$last shots/$new | grep diff > /dev/null; then
  convert -delay 100 -loop 0 shots/*.png synthese.gif
  git add shots synthese.gif
  git commit -m "autoupdate"
  git push
else
  rm -f shots/$new
fi
