#!/bin/bash

./score_norm.py -m M1 -n race -d rfw -p original -P ./scorenorm_dataset_protocol/protocols/RFW -D ./embedding -o ./output

./score_norm.py -m M1.1 -n race -d rfw -p original -P ./scorenorm_dataset_protocol/protocols/RFW -D ./embedding -o ./output

./score_norm.py -m M1.2 -n race -d rfw -p original -P ./scorenorm_dataset_protocol/protocols/RFW -D ./embedding -o ./output

./score_norm.py -m M2 -n race -d rfw -p original -P ./scorenorm_dataset_protocol/protocols/RFW -D ./embedding -o ./output

./score_norm.py -m M2.1 -n race -d rfw -p original -P ./scorenorm_dataset_protocol/protocols/RFW -D ./embedding -o ./output

./score_norm.py -m M2.2 -n race -d rfw -p original -P ./scorenorm_dataset_protocol/protocols/RFW -D ./embedding -o ./output

./score_norm.py -m M3 M4 M5 -n race -d rfw -p original -P ./scorenorm_dataset_protocol/protocols/RFW -D ./embedding -o ./output
