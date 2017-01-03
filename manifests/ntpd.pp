#
# simp_options::ntpd class
#
# Sets up NTP configuration variables
#
# @param servers The list of NTP time servers for the network.
#
#   A consistent time source is critical to your systems' security. **DO NOT**
#   run multiple production systems using individual hardware clocks!
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::ntpd (
  Array[Simplib::Host] $servers = []
){
  assert_private()
  validate_net_list($servers)
}
