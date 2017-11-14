#
# simp_options::puppet class
#
# Sets up Puppet configuration variables
#
# @param server The ``Hostname`` or ``FQDN`` of the Puppet server
#
# @param ca The Puppet Certificate Authority
#
# @param ca_port The port on which the Puppet Certificate Authority will listen
#
# @param server_distribution The server distribution being used, PC1 or PE.
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::puppet (
  Simplib::Host $server,
  Simplib::Host $ca,
  Simplib::Serverdistribution $server_distribution = $facts['is_pe'] ? { true => 'PE', default => 'PC1' },
  Simplib::Port $ca_port = $server_distribution ? { 'PE' => 8140, default => 8141 }
){
  assert_private()
  validate_net_list($server)
  validate_net_list($ca)
}
