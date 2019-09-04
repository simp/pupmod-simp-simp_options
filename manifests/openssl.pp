# @summary Sets up OpenSSL configuration variables
#
# @param cipher_suite The default ciphers to use in openssl.
#
# @see https://wiki.openssl.org/index.php/Command_Line_Utilities#ciphers OpenSSL Ciphers Command
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options::openssl (
  Array[String] $cipher_suite = $::simp_options::openssl::params::cipher_suite
) inherits simp_options::openssl::params {
  assert_private()
}
