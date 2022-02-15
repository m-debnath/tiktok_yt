#!/bin/bash

set -xe

mkdir "$(date +"%d-%m-%Y")"
cd "$(date +"%d-%m-%Y")"
# cp ../../zzzzz_outro.mp4 zzzzz_outro.mp4
youtube-dl $(curl -s -H "User-agent: 'your bot 0.1'" https://www.reddit.com/r/TikTokCringe/top.json\?limit\=24 | jq '.' | grep url_overridden_by_dest | grep -Eoh "https:\/\/v\.redd\.it\/\w{13}")

mkdir blur
for f in *.mp4; do ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K blur/$f; done
rm *.mp4
for f in blur/*.mp4; do echo "file $f" >> file_list.txt ; done
ffmpeg -f concat -i file_list.txt final_$(date +"%d-%m-%Y").mp4
