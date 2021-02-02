# @summary Sets up NTP configuration variables
#
# @param servers The NTP time servers for the network and, optionally,
#   configuration for the daemons that communicate with them.
#
#   A consistent time source is critical to your systems' security. **DO NOT**
#   run multiple production systems using individual hardware clocks!
#
#  @example A hash of servers
#   {
#     'ntp1.example.com' => [
#       'minpoll 3',
#       'maxpoll 6',
#     ],
#     'ntp2.example.com' => [
#       'iburst',
#       'minpoll 4',
#       'maxpoll 8',
#     ]
#   }
#
# @example An array of servers
#   [
#     'ntp1.example.com',
#     'ntp2.example.com',
#   ]
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::ntp (
  Variant[Hash[Simplib::Host, Array[String[1]]], Array[Simplib::Host]] $servers = []
){
  assert_private()
}
