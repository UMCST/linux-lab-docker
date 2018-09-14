#! /bin/bash
#docker network create -d ipvlan -o parent=wlp59s0 --subnet 192.168.0.0/24 --gateway 192.168.0.1 --ip-range 192.168.0.1/27 --aux-address 'host=192.168.0.8' bridge_net
