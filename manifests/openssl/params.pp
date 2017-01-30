# simp_options::openssl::params class
#
# Sets appropriate openssl cipher suite based on whether
# FIPS-mode is desired or the system is already in FIPS mode.
#
class simp_options::openssl::params (
) {
  assert_private()
  include '::simp_options'

  if $::simp_options::fips or $facts['fips_enabled'] {
    if $facts['fips_ciphers'] {
      $cipher_suite = $facts['fips_ciphers']
    }
    else {
      fail('$facts[\'fips_ciphers\'] not found')
    }
  }
  else {
    $cipher_suite = ['DEFAULT', '!MEDIUM']
  }
}
