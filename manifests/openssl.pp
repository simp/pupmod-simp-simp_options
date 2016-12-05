#
# simp_options::openssl class
#
# Sets up OpenSSL configuration variables
#
# @param cipher_suite The default ciphers to use in openssl.
#
#   * The default value is based on the ``fips_enabled`` fact. See the Hiera
#     defaults in ``simp_options/data/fips_enabled``.
#
# @see https://wiki.openssl.org/index.php/Command_Line_Utilities#ciphers OpenSSL Ciphers Command
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::openssl (
  Array[String] $cipher_suite
){
}
