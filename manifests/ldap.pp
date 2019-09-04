# @summary Sets up LDAP configuration variables
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
# @param master The LDAP master in URI form (ldap://server)
#
# @param uri The list of OpenLDAP servers in URI form (ldap://server)
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::ldap (
  String              $bind_pw,
  String              $bind_hash,
  String              $sync_pw,
  String              $sync_hash,
  Simplib::URI        $master     = $simp_options::puppet::server ? { undef => undef, default => "ldap://${simp_options::puppet::server}"},
  Array[Simplib::URI] $uri        = $master ? { undef => undef, default => [$master]},
  String              $base_dn    = simplib::ldap::domain_to_dn(),
  String              $bind_dn    = "cn=hostAuth,ou=Hosts,${base_dn}",
  String              $sync_dn    = "cn=LDAPSync,ou=Hosts,${base_dn}",
  String              $root_dn    = "cn=LDAPAdmin,ou=People,${base_dn}",
){
  assert_private()

  simplib::validate_uri_list($master, ['ldap','ldaps'])
  simplib::validate_uri_list($uri, ['ldap','ldaps'])
}
