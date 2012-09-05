
# usage: bind_virtual_ip{'eth0:0': '134.23.2.3'}
# or: bind_virtual_ip{'eth0:0': '134.23.2.3', '172.31.8.2'}

define lvs::bind_virtual_ip($virtual_ip, $netmask='255.255.255.0', $gateway='172.31.8.1') {
    
    if $netmask != '255.255.255.255' {
        $changes = [
            "set auto[child::1 = '${name}']/1 ${name}",
            "set iface[. = '${name}'] ${name}",
            "set iface[. = '${name}']/family inet",
            "set iface[. = '${name}']/method static",
            "set iface[. = '${name}']/address ${virtual_ip}",
            "set iface[. = '${name}']/netmask ${netmask}",
            "set iface[. = '${name}']/gateway  ${gateway}"
        ]    
    } else {
        $changes = [
            "set auto[child::1 = '${name}']/1 ${name}",
            "set iface[. = '${name}'] ${name}",
            "set iface[. = '${name}']/family inet",
            "set iface[. = '${name}']/method static",
            "set iface[. = '${name}']/address ${virtual_ip}",
            "set iface[. = '${name}']/netmask ${netmask}",
        ]    
    }

    augeas { "inteface-${name}":
        context => "/files/etc/network/interfaces",
        changes => $changes,
        require => Class["ensureaugeas"],
        notify => Exec["activate-interface-${name}"],
    }

    exec {"activate-interface-${name}":
        command => "/sbin/ifup ${name}",
        refreshonly => true,
    }
}
