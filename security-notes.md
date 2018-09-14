## CGROUPS
 Used to limit the resource consumption of processes.

## Namespaces
  Used to limit the views of processes. Views include
  - ipc (inter-process communication)
  - network
  - mount
  - PID
  - User (UIDS and GUIDs)
  - UTS (system identifiers (hostnames?))


https://gist.github.com/FrankSpierings/5c79523ba693aaa38bc963083f48456c


Get the ip address from file system in bash
awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)"