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
    $cipher_suite = ['FIPS', '!LOW']
  } else {
    $cipher_suite = ['DEFAULT', '!MEDIUM']
  }
}
