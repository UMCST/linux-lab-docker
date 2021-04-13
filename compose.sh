#!/bin/bash
source .env
guac_init() {
    for (( c=1; c<=$SCALE; c++ ))
    do
        users=$(cat <<-END
$users 
    <authorize username="user$c" password="$USER_PASSWORD">
        <connection name="web$c">
        <protocol>ssh</protocol>
            <param name="hostname">linux-lab-docker_web_$c.linux-lab-docker_web</param>
            <param name="port">22</param>
        </connection>
    </authorize>
END
)
    done


    cat << EOF > guacamole/user-mapping.xml
<user-mapping>
    $users
    <authorize username="admin" password="welike2hack10!">
        <connection name="web0">
        <protocol>ssh</protocol>
            <param name="hostname">linux-lab-docker_web0_1.linux-lab-docker_web</param>
            <param name="port">22</param>
            <param name="username">admin</param>
            <param name="password">welike2hack10!</param>
        </connection>
    </authorize>
</user-mapping>
EOF
}
wazuh_init() {
    docker-compose -f docker-compose.yml -f docker-compose.wazuh.yml -f docker-compose.guac.yml exec elasticsearch bash password-tool.sh -a
    docker-compose -f docker-compose.yml -f docker-compose.wazuh.yml -f docker-compose.guac.yml exec elasticsearch bash password-tool.sh -u kibanaserver -p $KIBANA_PASSWORD
    docker-compose -f docker-compose.yml -f docker-compose.wazuh.yml -f docker-compose.guac.yml exec elasticsearch bash password-tool.sh -u admin -p $ELASTIC_PASSWORD
    docker-compose -f docker-compose.yml -f docker-compose.wazuh.yml -f docker-compose.guac.yml exec elasticsearch bash password-tool.sh -u kibanaro -p $KIBANARO_PASSWORD
    docker-compose -f docker-compose.yml -f docker-compose.wazuh.yml -f docker-compose.guac.yml exec kibana bash change-password.sh $KIBANA_PASSWORD
    docker-compose -f docker-compose.yml -f docker-compose.wazuh.yml -f docker-compose.guac.yml restart elasticsearch wazuh kibana
}
init() {
    for (( c=1; c<=$SCALE; c++ ))
    do
        hosts=$(cat <<-END
$hosts
linux-lab-docker_web_$c.linux-lab-docker_web
END
)
    done

    cat << EOF > c2-base/pssh_hostfile.txt
$hosts
EOF

}
main() {
    if [ ! -z "$WAZUH" ]; then
        WAZUH="-f docker-compose.wazuh.yml"
    fi
    if [ ! -z "$GUAC" ]; then
        GUAC="-f docker-compose.guac.yml"
    fi
    if [ ! -z "$TRAEFIK" ]; then
        TRAEFIK="-f docker-compose.traefik.yml"
    fi
    SCALE=${SCALE:-'1'}
    if [[ $@ =~ "up" ]]; then
        init
        docker-compose -f docker-compose.yml $GUAC $WAZUH $TRAEFIK $@ --scale web=$SCALE
        if [ ! -z "$GUAC" ]; then
            guac_init
        fi
        if [ ! -z "$WAZUH" ]; then 
            auth="--user admin:admin -k"
            until docker-compose -f docker-compose.yml -f docker-compose.wazuh.yml exec wazuh curl -XGET https://elasticsearch:9200 ${auth} &> /dev/null; do
                >&2 echo "Elastic is unavailable - sleeping"
                sleep 5
            done
            wazuh_init
        fi
        docker-compose -f docker-compose.yml $GUAC $WAZUH $TRAEFIK exec web0 bash post_install.sh
    else 
        docker-compose -f docker-compose.yml $GUAC $WAZUH $TRAEFIK $@
    fi
}
main "$@"
