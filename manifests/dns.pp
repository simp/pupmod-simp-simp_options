# @summary Sets up DNS configuration variables
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
#   ---------------------------------------------------------------------------
#   If you are using the SIMP ``resolv`` module, and the system is a DNS server
#   using the SIMP ``named`` module but you wish to have your node point to a
#   different DNS server for primary DNS resolution, then you MUST set
#   ``resolv::named_server`` to ``true`` via Hiera.
#
#   This will get around the convenience logic that was put in place to handle
#   the caching entries and will not attempt to convert your system to a
#   caching DNS server.
#   ---------------------------------------------------------------------------
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::dns (
  Array[String]        $search  = [],
  Array[Simplib::Host] $servers = []
){
  assert_private()
  simplib::validate_net_list($servers)
}
