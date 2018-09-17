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

1. Set a static ip for the lab host above the range for the containers.
2. Clone this repository onto the host server.
3. Customize the `docker-compose.yml` file with the correct ip ranges.
4. Run `docker-compose build` and the `docker-compose up`
5. Get a shell on the container `web1.umcstlab.net` and run the shell script `post_install.sh`
6. Test that outside computers can ping the lab servers.


## Todo
Some changes and additions to make that would improve the lab.

* A DNS server for the network would be great. The docker containers manage their own DNS, but the clients connecting to them do not have that knowledge.
* Setup networking so that the Docker containers can talk to their host system. This could be used for more backdoors.
* Create more backdoors, like a web shell.
* Create a scoreboard that tracks how many backdoors are remaining on each system.
* There needs to be an easy way for lab participants to grab a new copy of the nginx.conf file.

## Built With

* [Docker](https://www.docker.com) - To create "virtual servers".
* [pssh](https://linux.die.net/man/1/pssh) - To remotely control many servers at once.
* [not-a-backdoor](https://github.com/Dieff/not-a-backdoor) - One of the backdoors used on lab servers.

## Authors

* **Nick Dieffenbacher-Krall** - *Initial work* - [Dieff](https://github.com/Dieff)

## License

The code in this project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
