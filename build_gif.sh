#!/bin/bash

cd $(dirname $0)

last=$(ls shots | tail -1)
new=$(date +%y%m%d).png

if [ "$last" = "$new" ]; then
  exit 0
fi

wget -q "https://www.nosdeputes.fr/graphes/groupes/all?mapId=Map_0000.map" -O shots/$new

mkdir -p captioned
for shot in shots/*.png; do
  captioned=captioned/$(basename $shot)
  if [ ! -f "$captioned" ]; then
    label=$(date -d ${shot:6:6} +"%d %B %Y")
    convert $shot -crop 707x323+7+7 -background "#F0F0F0" label:"$label" -gravity Center -append $captioned
  fi
done

if diff shots/$last shots/$new | grep diff > /dev/null; then
  convert -delay 100 -loop 0 captioned/*.png synthese.gif
  git add shots synthese.gif
  git commit -m "autoupdate"
  git push
else
  rm -f shots/$new
fi
