# @summary Sets up syslog configuration variables
#
# @param log_servers The log servers to receive forwarded logs
#
# @param failover_log_servers Failover log servers in case your log servers fail
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::syslog (
  Array[Simplib::Host] $log_servers          = [],
  Array[Simplib::Host] $failover_log_servers = []
){
  assert_private()
  simplib::validate_net_list($log_servers)
  simplib::validate_net_list($failover_log_servers)
}
