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
# @author SIMP Team - https://simp-project.com
#
class simp_options::puppet (
  String $server,
  String $ca,
  Stdlib::Compat::Integer $ca_port = '8141'
){
  assert_private()
  validate_net_list($server)
  validate_net_list($ca)
}
