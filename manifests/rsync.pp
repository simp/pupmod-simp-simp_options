#
# simp_options::rsync class
#
# Sets up ``rsync`` configuration variables
#
# @param server Server to use for the simp::rsync_server class.
#
#   This class is used by several SIMP modules to efficiently synchronize large
#   data files using ``rsync`` over ``stunnel``.
#
#   The **default value** of ``127.0.0.1`` is appropriate for rsync over stunnel.
#
# @param timeout rsync connection timeout in **seconds**
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::rsync (
  String $server   = '127.0.0.1',
  Integer $timeout = 1
){
  validate_net_list($server)
}
