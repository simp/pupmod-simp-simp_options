#
# simp_options::pki class
#
# Sets up global PKI configuration variables
#
# @param source The source location for PKI certificates.  This is the source
#   directory for pki::copy.
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::pki (
  Stdlib::Absolutepath $source = '/etc/pki/simp'
){
  assert_private()
}
