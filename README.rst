puppet-lvs: Load balance server clusters with linux virtual server
==================================================================

.. _lvs_introduction:

Introduction
------------

Linux virtual server is an ultra high performance layer4 load balancer. It's
main feature is deferring a connection directly to a backend server from a cluster.
In effect, for each connection, only incoming packets ever go through lvs,
all the response packets will reach the backend server directly. This way of
load balancing is extremely efficient because the internet is clearly
asymmetric with the bulk of the traffic in the response.

.. image:: images/VS-DRouting.gif

For more info see: `LVS direct routing <http://www.linuxvirtualserver.org/VS-DRouting.html>`_

.. lvs_module_status:

.. _lvs_usage:

Load balancing a cluster of servers with lvs
--------------------------------------------

We manage lvs configuration using ``ldirectord``, it offers simple
configuration of lvs through a configuration file.

.. _lvs_config:

Lvs is configured by specifying the different clusters and their members

.. code-block:: ruby

   # specify the backend servers for each lvs member type:
   $ssloffloaders = [
       {'ipaddress' => '168.234.1.1'},
       {'ipaddress' => '168.234.1.2'},
       {'ipaddress' => '168.234.1.3'},
   ]
   $webservers = [
    {'ipaddress' => '168.234.1.4'},
    {'ipaddress' => '168.234.1.5'},
   ]
   $socketservers = [
    {'ipaddress' => '168.234.1.6'},
    {'ipaddress' => '168.234.1.7'},
   ]
   
   # bind the virtual ip's to the network interface
   # the $lvs_virtual_ip_1 and $lvs_virtual_ip_2 are defined
   # in site.pp.
   lvs::bind_virtual_ip{'eth0:0': virtual_ip => $lvs_virtual_ip_1} ->
   lvs::bind_virtual_ip{'eth0:1': virtual_ip => $lvs_virtual_ip_2, netmask => '255.255.255.255'} ->

   # define the lvs class and specify the members and their backends.
   class{"lvs":
       members => [
           lvs_member(virtual_ip => $lvs_virtual_ip_2, port => 8081, backends => $socketservers),
           lvs_member(virtual_ip => $lvs_virtual_ip_1, port => 80,   backends => $webservers),
           lvs_member(virtual_ip => $lvs_virtual_ip_1, port => 443,  backends => $ssloffloaders),
       ]
   }

*Please note that you can NOT map an external port to a different internal
port in gate mode!*

If you where using :ref:`puppet-kicker` specifying the backends for each lvs
member would be much easier:

.. code-block:: ruby

   $ssloffloaders = servers_with_role('ssloffloader')
   $webservers = servers_with_role('webserver')
   $socketservers = servers_with_role('socketservers')

More info on the ``ldirectord`` configuration syntax can be found at
`the ldirectord man page <http://pwet.fr/man/linux/administration_systeme/ldirectord>`_