#!/bin/bash
#Create directories based on date weekly, such as for youtube or podcasts
base_directory="/home/pi/videos"
current_date=$(date +%F)

for i in {1..54}; do
  folder_name="$base_directory/$current_date"
  mkdir -p "$folder_name"
  current_date=$(date -d "$current_date + 7 days" +%F)
done