# Class nova::compute::mdev
#
# Configures nova compute mdev options
#
# === Parameters:
#
# [*mdev_types*]
#   (Optional) A hash to define the nova::compute::mdev_type resources.
#   Defaults to {}
#
# DEPRECATED PARAMETERS
#
# [*mdev_types_device_addresses_mapping*]
#   (Optional) Map of mdev type(s) the instances can get as key and list of
#   corresponding device addresses as value.
#   Defaults to undef
#
class nova::compute::mdev(
  Hash $mdev_types = {},
  # DEPRECATED PARAMETERS
  Hash $mdev_types_device_addresses_mapping = {},
) {
  include nova::deps

  if !empty($mdev_types) {
    nova_config {
      'devices/enabled_mdev_types': value => join(keys($mdev_types), ',')
    }
    create_resources('nova::compute::mdev_type', $mdev_types)
  } elsif !empty($mdev_types_device_addresses_mapping) {
    nova_config {
      'devices/enabled_mdev_types': value => join(keys($mdev_types_device_addresses_mapping), ',');
    }

    $mdev_types_device_addresses_mapping.each |$mdev_type, $device_addresses| {
      nova::compute::mdev_type { $mdev_type :
        device_addresses => $device_addresses;
      }
    }
  } else {
    nova_config {
      'devices/enabled_mdev_types': ensure => absent;
    }
  }
}
