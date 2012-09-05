
# Configure lvs by binding 2 virtual ip adresses and writing the ldirectord
# config file.

class lvs::config($members) {
    include ensureaugeas
        
    file {"/etc/ldirectord.cf":
        content => template('lvs/etc/ldirectord.cf.erb'),
        owner => "root",
        require => Class["lvs::install"],
        mode => "0644",
        ensure => file,
        replace => true,
    }    
}
