#!/bin/bash
#Get last image
image=$(gcloud compute images list | cut -f 1 -d ' ' | grep reddit-full | sort -r | head -n 1)
#Create VM
gcloud beta compute --project "infra-198313" instances create "reddit-app" --zone "europe-west4-a" --machine-type "g1-small" --subnet "default" --maintenance-policy "MIGRATE" --min-cpu-platform "Automatic" --tags "puma-server" --image "$image" --image-project "infra-198313" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "reddit-app"