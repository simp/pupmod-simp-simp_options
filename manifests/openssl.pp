#
# simp_options::openssl class.
#
# Sets up openssl configuration variables
#
# @param cipher_suite The default ciphers to use in openssl.
#
# @author SIMP Team
#
class simp_options::openssl (
  # default value is based on fips_enabled fact; values appear in 
  # simp_options/data/fips_enabled
  Array[String] $cipher_suite
){
}
