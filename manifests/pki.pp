# @summary Sets up global PKI configuration variables
#
# @param source The source location for PKI certificates.  This is the source
#   directory for pki::copy.
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::pki (
  Stdlib::Absolutepath $source = '/etc/pki/simp/x509'
){
  assert_private()
}
