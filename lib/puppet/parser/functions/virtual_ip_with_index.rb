module Puppet::Parser::Functions
    newfunction(:virtual_ip_with_index,
    :type => :rvalue,
    :doc => "returns a virtual ip from a list of virtual ips that are available." ) do |index|
        
        integer_index = Integer(index.to_s)
        vip = lookupvar("::lvs_virtual_ip_#{integer_index+1}")
        return vip
    end
end
