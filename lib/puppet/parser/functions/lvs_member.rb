module Puppet::Parser::Functions
    newfunction(:lvs_member,
    :type => :rvalue,
    :doc => "returns an lvs member config object.
    
    virtual_ip, port, and backends are required to construct an lvs_cluster.
    
    $backends = [
        {'ipaddress' => '168.234.1.1'},
        {'ipaddress' => '168.234.1.2'},
        {'ipaddress' => '168.234.1.3'},
    ]
    
    $member = lvs_member('virtual_ip' => '127.1.1.1', port => 3456, backends => $backends)
    
    Defaults that can be overridded are:
    
    'forwarding_method' => 'gate',
    'scheduler' => 'wrr',
    'protocol' => 'tcp',
    'checktype' => 'connect',
    'failurecount' => 20
    " ) do |kwargs|
        
        if kwargs.kind_of?(Array)
            kwargs = Hash[*kwargs]
        end

        default = {
            'forwarding_method' => 'gate',
            'scheduler' => 'wrr',
            'protocol' => 'tcp',
            'checktype' => 'connect',
            'failurecount' => 20
        }

        if kwargs.kind_of?(Hash)
            if kwargs.has_key? 'virtual_ip' and
                kwargs.has_key? 'port' and
                kwargs.has_key? 'backends'

                default.merge! kwargs
                return default            
            else
                raise Puppet::ParseError, "virtual_ip, port, and backends are required to construct an :lvs_member."
            end
        else
            raise Puppet::ParseError, "lvs_cluster requires keyword arguments. #{kwargs.type} #{kwargs.class} #{kwargs}"
        end
    end
end
