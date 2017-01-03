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
#   * Has module data default
#
# @param bind_pw The LDAP Bind password
#
# @param bind_hash The salted LDAP Bind password hash
#
# @param sync_dn The LDAP Sync Distinguished Name
#
#   * Has module data default
#
# @param sync_pw The LDAP Sync password
#
# @param sync_hash The LDAP Sync password hash
#
# @param root_dn The LDAP Root Distinguished Name
#
#   * Has module data default
#
# @param root_hash The LDAP Root password hash
#
# @param master The LDAP master in URI form (ldap://server)
#
#   * Has module data default
#
# @param uri The list of OpenLDAP servers in URI form (ldap://server)
#
#   * Has module data default
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::ldap (
  String              $base_dn,
  String              $bind_dn,
  String              $bind_pw,
  String              $bind_hash,
  String              $sync_dn,
  String              $sync_pw,
  String              $sync_hash,
  String              $root_dn,
  String              $root_hash,
  Simplib::URI        $master,
  Array[Simplib::URI] $uri
){
  assert_private()
  validate_uri_list($master,['ldap','ldaps'])
  validate_uri_list($uri,['ldap','ldaps'])
}
