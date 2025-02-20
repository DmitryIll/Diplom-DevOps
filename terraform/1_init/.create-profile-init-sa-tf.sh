#!/bin/bash
yc config profile create init-sa-tf
yc config set organization-id bpf8g5ujsvrh7kl1dtfa
yc config set cloud-id b1gjo1f0ugngaqfdnp1h
yc config set folder-id b1gdm09v258sdmq82j9v
yc config set service-account-key .key.json
