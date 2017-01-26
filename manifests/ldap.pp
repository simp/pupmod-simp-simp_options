#
# simp_options::ldap class
#
# Sets up LDAP configuration variables
#
# Some parameters have default values in `simp_options/data/ldap.yaml`, all
# others **must** have a value specified via Hiera or your ENC.
#
# @param base_dn The Base Distinguished Name of the LDAP server
#
# @param bind_dn The LDAP Bind Distinguished Name
#
# @param bind_pw The LDAP Bind password
#
# @param bind_hash The salted LDAP Bind password hash
#
# @param sync_dn The LDAP Sync Distinguished Name
#
# @param sync_pw The LDAP Sync password
#
# @param sync_hash The LDAP Sync password hash
#
# @param root_dn The LDAP Root Distinguished Name
#
# @param root_hash The LDAP Root password hash
#
# @param master The LDAP master in URI form (ldap://server)
#
# @param uri The list of OpenLDAP servers in URI form (ldap://server)
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::ldap (
  String              $bind_pw,
  String              $bind_hash,
  String              $sync_pw,
  String              $sync_hash,
  String              $root_hash,
  String              $base_dn    = simplib::ldap::domain_to_dn(),
  String              $bind_dn    = "cn=hostAuth,ou=Hosts,${simp_options::ldap::base_dn}",
  String              $sync_dn    = "cn=LDAPSync,ou=Hosts,${simp_options::ldap::base_dn}",
  String              $root_dn    = "cn=LDAPAdmin,ou=People,${simp_options::ldap::base_dn}",
  Simplib::URI        $master     = "ldap://${simp_options::puppet::server}",
  Array[Simplib::URI] $uri        = ["ldap://${simp_options::puppet::server}"]
){
  assert_private()
  validate_uri_list($master,['ldap','ldaps'])
  validate_uri_list($uri,['ldap','ldaps'])
}
