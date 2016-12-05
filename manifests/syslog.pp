#
# simp_options::syslog class
#
# Sets up ``syslog`` configuration variables
#
# @param log_servers The log servers to receive forwarded logs
#
# @param failover_log_servers Failover log servers in case your log servers fail
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::syslog (
  Array[String] $log_servers          = [],
  Array[String] $failover_log_servers = []
){
  validate_net_list($log_servers)
  validate_net_list($failover_log_servers)
}
