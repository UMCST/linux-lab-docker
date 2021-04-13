#!/bin/bash
sed -i 's/elasticsearch.password:.*/elasticsearch.password: '"$1"'/' "/usr/share/kibana/config/kibana.yml"