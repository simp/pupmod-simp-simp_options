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
  Simplib::Port $ca_port = 8141,
  Simplib::Serverdistribution $server_distribution = 'PC1'
){
  assert_private()
  validate_net_list($server)
  validate_net_list($ca)
}
