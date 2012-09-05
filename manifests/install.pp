
# install ldirectord so we can manage lvs from a config file

class lvs::install {
    package {"ldirectord":
        ensure => latest,
    }
}