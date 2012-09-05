
# install the linux virtual server, which load balances all the server
# clusters

class lvs($members) {
    include lvs::install
    class{"lvs::config":
        members => $members,
    }
    include lvs::service
}