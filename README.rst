puppet-lvs: Load balance server clusters with linux virtual server
==================================================================

.. note::

    puppet-lvs requires puppet-kicker.

.. _lvs_introduction:

Introduction
------------

Linux virtual server is an ultra high performance layer4 load balancer. It's
main feature is deferring a connection directly to a backend server from a cluster.
In effect, for each connection, only a single packet ever goes through lvs,
all the rest of the packets for that connection will reach the backend server
directly. This way of load balancing is extremely efficient in case of websockets
where a connection is persistent.

.. image:: images/VS-DRouting.gif

For more info see: `LVS direct routing <http://www.linuxvirtualserver.org/VS-DRouting.html>`_

.. lvs_module_status:

Status
------

The status of this module is pre-alpha. Instead of a generic module, the lvs
module is tailored to the oe-stack, with hardcoded configuration. The reason
for this, is that lvs requires additional ip-addresses to be assigned to a VM,
called virtual ip's. Unfortunately this is **not supported** by cloudstack 2.0.
In cloudstack 3.0 this will be possible. As soon as cloudstack has been upgraded
to version 3.0, this module will be refactored in to a general purpose module.

In the mean time, if services need to be added to lvs, fork the repository,
add your services to this module, and submit a pull request.

.. _lvs_usage:

Load balancing a cluster of servers with lvs
--------------------------------------------

We manage lvs configuration using ``ldirectord``, it offers simple
configuration of lvs through a configuration file.

To have lvs distribute load over the servers in your cluster, make sure the
server roles that are balanced by lvs are defined in config.pp.

.. _lvs_config:

.. literalinclude:: ../modules/lvs/manifests/config.pp
   :language: ruby
   :lines: 7-
   :end-before: # bind the virtual ips needed by lvs to a network interface.
   :prepend: #lvs/manifests/config.pp

After you added your server role to the list in ``config.pp``, modify the
ldirector config file so it will add configuration for your services. *Please
note that you can NOT map an external port to a different internal port in gate
mode!* Here's an example of how rabbitmq is configured in ldirectord.

.. _lvs_template:

.. literalinclude:: ../modules/lvs/templates/etc/ldirectord.cf.erb
   :language: erb
   :lines: 6-
   :end-before: <% if not guiservers.empty? %>
   :prepend: #lvs/templates/etc/ldirectord.cf.erb

So for now, modify the files in question, and send a pull request. Later on, the
entire lvs module will be properly parameterized.

More info on the ``ldirectord`` configuration syntax can be found at
`the ldirectord man page <http://pwet.fr/man/linux/administration_systeme/ldirectord>`_