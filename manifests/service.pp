
# start up ldirectord and make sure it starts on boot.

class lvs::service {
    service {"ldirectord":
        ensure => running,
        enable => true,
        require => Class["lvs::config"],
    }
}