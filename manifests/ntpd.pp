# @summary Sets up NTP configuration variables
#
# @param servers The list of NTP time servers for the network.
#
#   A consistent time source is critical to your systems' security. **DO NOT**
#   run multiple production systems using individual hardware clocks!
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::ntpd (
  Array[Simplib::Host] $servers = []
){
  assert_private()
  simplib::validate_net_list($servers)
}
