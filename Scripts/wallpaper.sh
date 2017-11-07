#!/usr/bin/env sh

~/Scripts/wallpaper.py
convert ~/.background.png -resize 1920x1200^ -gravity center -extent 1920x1200 ~/.background.png
env DISPLAY=:0 /usr/bin/feh --bg-fill --no-fehbg /home/jwa/.background.png

