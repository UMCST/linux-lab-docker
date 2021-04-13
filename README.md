# UMCST's Intro To Linux Security Lab

The [University of Maine Cybersecurity Club](https://umcst.maine.edu) runs introductory labs for
new recruits every fall. This repository contains the technical portion
of the "Intro to Linux Security" lab. The lab has participants work to
fix a Linux server that has been compromised by a malicious actor. Once they
have restored the server, they then work to figure out what backdoors and remote
access the attackers has placed on the system. If you are not involved with UMCST,
but would like to read the lab, send us an email at um.cst@maine.edu.

Note: if you are going to be doing this lab in the near future
you should avoid looking to closesly at this repo, especially the
"spoilers" folder, as you might spoil the lab for yourself an others.

## Technical Description

To simulate 30+ Linux servers without actually running 30+ VMs
Docker containers are used. The Docker containers are setup to be
as much like real baremetal/VM Linux servers as possible. The primary
process in the containers is SystemD. The base utilities and such that
one would expect on most distributions are also installed into the image.

Additionally, the network in which the containers exist is meant to be
close to a standard network. The containers share the host's network via
a "macvlan" or "ipvlan" Docker network adaptor. An important implication of
this is that the containers cannot talk to their host over the network (
though this could be fixed with a special adaptor. PRs welcome. ).

In order to simulate malicious activity on the network, a special container
is used that resembles the normal web server containers. This container
contains scripts that will deploy malicious backdoors and break system utilities
on the other containers. When the lab begins, the lab administrator should get
a shell in this container (via `docker exec`) and run the script `post_install.sh`.

## Running your own version

The first step to running your own copy of this lab is to figure out
how you wish to set up networking. The lab populates a network with containers
via macvlan (or ipvlan if you are using wifi).

The general steps are below.

1. Clone this repository onto the host server.
2. If you don't want to use Guacamole and access the web servers directly, modify the `docker-compose.yml` file with the correct ip ranges and network drivers.

   - For a wired connection, use the `macvlan` driver, and set the docker-compose IPAM settings to use a suitable network range.
   - If you are on wifi, then you need to use a driver type of `ipvlan`. This is an experimental docker feature, so you need to enable experimental mode.
   
3. Copy the environment variable file to `env.example` to `.env`, and fill out the `.env` file. If you don't want any additional services, leave everything blank except for the `SCALE` variable

   - If you want Wazuh, set the `WAZUH` to `true`, and fill in the API, ELASTIC, KIBANA, and KIBANARO passwords. The API and kibana passwords are internal-only, but the elastic password is the `admin` password for the Wazuh, and the kibanaro password is the `kibanaro` password for the Wazuh (which has basic kibana permissions, as well as the readall permission)
   - If you want Guacamole, set `GUAC` to `true`, and set the user password. This is the password the users will use to log into Guacamole (with username `userX`, where X is their instance number)
   - If you want to use the Traefik proxy, set `TRAEFIK` to true, and set the domain to whatever your base domain to be. The Traefik proxy is pre-configured to use subdomains "wazuh" and "console" off of this domain, though by default it does not try to use Let's Encrypt for it's HTTPS certificate.  

4. The `compose.sh` script handles scaling for you via the `SCALE` variable in the environment file, but otherwise can be treated similarly to the docker-compose - to bring the stack up, simply run `./compose.sh up --build -d`. After it builds, initializes, and exits, the various components can be accessed at their corresponding ports (5601 for wazuh, over https, and port 8080 for guacamole over http, at path /guacamole), or via the proxy if enabled (at wazuh.DOMAIN or console.DOMAIN)

## Todo

Some changes and additions to make that would improve the lab.

- Optional DNS server to allow access to the sub-domain of the embedded docker web server from external users for macvlan/ipvlan components.
- Setup networking so that the Docker containers can talk to their host system. This could be used for more backdoors.
- Create more backdoors, like a web shell.
- Create a scoreboard that tracks how many backdoors are remaining on each system.

## Built With

- [Docker](https://www.docker.com) - To create "virtual servers".
- [pssh](https://linux.die.net/man/1/pssh) - To remotely control many servers at once.
- [not-a-backdoor](https://github.com/Dieff/not-a-backdoor) - One of the backdoors used on lab servers.
- [Wazuh](https://github.com/wazuh/wazuh-docker) - Host IDS used for further extension of the lab (log analysis, alerting, etc)
- [Guacamole](https://guacamole.apache.org/) - Web-based remote access console solution, for simpler deployment

## Authors

- **Nick Dieffenbacher-Krall** - _Initial work, many-many-many backdoors_ - [Dieff](https://github.com/Dieff)
- **Devin Christianson** - _Docker restructure, Wazuh, Guacamole_ - [devinchristianson](https://github.com/devinchristianson)

## License

The code in this project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
