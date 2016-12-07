#
# simp_options::dns class
#
# Sets up DNS configuration variables
#
# @param search The DNS search list. Remember to put these in the appropriate
#   order for your environment.
#
# @param servers The list of DNS servers for the managed hosts.
#
#   If the first entry of this list is set to ``127.0.0.1``, then all clients
#   will configure themselves as caching DNS servers pointing to the other
#   entries in the list.
#
#   Also, if you have a system that's including SIMP's ``named`` class and is
#   **not** in this list, then you'll need to set a variable at the top of that
#   node entry called ``$named_server`` to ``true``.
#
#   This will get around the convenience logic that was put in place to handle
#   the caching entries and will not attempt to convert your system to a
#   caching DNS server.
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::dns (
  Array[String] $search = [],
  Array[String] $servers = []
){
  validate_net_list($servers)
}
