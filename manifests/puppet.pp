# @summary Sets up Puppet configuration variables
#
# @param server The ``Hostname`` or ``FQDN`` of the Puppet server
#
# @param ca The Puppet Certificate Authority
#
# @param ca_port The port on which the Puppet Certificate Authority will listen
#
# @param server_distribution The server distribution being used, PC1 or PE.
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::puppet (
  Optional[Simplib::Host]     $server              = undef,
  Optional[Simplib::Host]     $ca                  = undef,
  Simplib::Serverdistribution $server_distribution = (('pe_build' in  $facts) or $facts['is_pe']) ? { true => 'PE', default => 'PC1' },
  Simplib::Port               $ca_port             = $server_distribution ? { 'PE' => $facts['puppet_settings']['agent']['ca_port'], default => 8141 }
){
  assert_private()

  if $server { simplib::validate_net_list($server) }
  if $ca { simplib::validate_net_list($ca) }
}
