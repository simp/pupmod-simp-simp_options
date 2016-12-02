#
# simp_options::ldap class.
#
# Sets up LDAP configuration variables
#
# @param base_dn The Base Distinguished Name of the LDAP server
# @param bind_dn The LDAP Bind Distinguished Name
# @param bind_pw The LDAP Bind password
# @param bind_hash The salted LDAP Bind password hash
# @param sync_dn The LDAP Sync Distinguished Name
# @param sync_pw The LDAP Sync password
# @param sync_hash The LDAP Sync password hash
# @param root_dn The LDAP Root Distinguished Name
# @param root_hash The LDAP Root password hash
# @param master The LDAP master in URI form (ldap://server)
# @param uri The list of OpenLDAP servers in URI form (ldap://server)
#
# @author SIMP Team
#
class simp_options::ldap (
  # parameters noted have default values in simp_options/data/ldap.yaml
  String $base_dn,
  String $bind_dn,     # has module data default
  String $bind_pw,
  String $bind_hash,
  String $sync_dn,     # has module data default
  String $sync_pw,
  String $sync_hash,
  String $root_dn,     # has module data default
  String $root_hash,
  String $master,      # has module data default
  Array[String] $uri   # has module data default
){
  validate_uri_list($master,['ldap','ldaps'])
  validate_uri_list($uri,['ldap','ldaps'])
}
