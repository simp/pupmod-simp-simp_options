# @summary Sets up variables that enable core SIMP capabilities or provide site
# configuration larger than the scope of a single module.
#
# @param auditd
#   Include SIMP's ``auditd`` class and add audit rules pertinent to each
#   application
#
# @param clamav
#   Whether SIMP should manage ``ClamAV``
#
# @param fips
#   Enable ``FIPS`` mode for the system
#
#   * NOTE: This parameter enforces strict compliance with ``FIPS-140-2``.
#
#   * All core SIMP modules can support this configuration. It is important
#     that you know the security tradeoffs of ``FIPS-140-2`` compliance.
#
#   * ``FIPS`` mode disables the use of ``MD5`` and may require weaker ciphers
#     or key lengths than your security policies allow.
#
#   @see http://simp.readthedocs.io/en/master/security_mapping/components/simplib/cryptographic_protection/control.html SIMP - Security Control Mapping Cryptographic Protection
#
# @param firewall
#   Include SIMP's firewall management across the SIMP modules.
#
# @param haveged
#   Include the ``haveged`` class to ensure adequate entropy for key generation
#
#   @see http://simp.readthedocs.io/en/master/getting_started_guide/ISO_Build/Environment_Preparation.html?highlight=haveged SIMP - Getting Started Environment Preparation
#
# @param ipsec
#   Include SIMP's ``ipsec`` class, ``libreswan``, and add rules pertinent to
#   each application
#
# @param kerberos
#   Include the SIMP's Kerberos class, ``krb5``, and to use ``Kerberos`` in
#   applicable modules that support it
#
# @param ldap
#   Use ``LDAP`` in modules that support it
#
# @param logrotate
#   Include SIMP's `logrotate`` class and add rules pertinent to each
#   application.
#
# @param pam
#   Include SIMP's ``pam`` class SIMP to manage ``PAM``
#
# @param pki
#   Include SIMP's ``pki`` class and use ``pki::copy`` to distribute PKI
#   certificates to the correct locations.
#
#   * If false, don't include SIMP's ``pki`` class, and don't use ``pki::copy``.
#   * If true,  don't include SIMP's ``pki`` class, but use ``pki::copy``.
#   * If 'simp', include SIMP's ``pki`` class, and use ``pki::copy``.
#
# @param sssd
#   Enable ``SSSD`` in modules that support it
#
# @param stunnel
#   Include SIMP's ``stunnel`` class and use it to secure server-to-server
#   communications in modules that support it
#
# @param syslog
#   Include SIMP's ``rsyslog`` class and configure RSyslog application hooks
#
# @param tcpwrappers
#   Include SIMP's ``tcpwrappers`` class and use ``tcpwrappers::allow`` to
#   permit the application to the subnets in ``$simp_options::trusted_nets``
#
# @param trusted_nets
#   Subnets to permit; in ``CIDR`` notation.
#
#   * If you need this to be more (or less) restrictive for a given class, you
#     can override it for the specific class via that class' parameters.
#
# @param package_ensure
#   The default ``ensure`` parameter for packages
#
# @param libkv Feature flag for libkv.
#   Enable the libkv backend for some functions
#
# @param puppet
#   Include ``simp_options::puppet`` class SIMP to set key Puppet parameters
#   used by SIMP modules
#
# @author https://github.com/simp/pupmod-simp-simp_options/graphs/contributors
#
class simp_options (
  Boolean                       $auditd         = false,
  Boolean                       $clamav         = false,
  Boolean                       $fips           = false,
  Boolean                       $firewall       = false,
  Boolean                       $haveged        = false,
  Boolean                       $ipsec          = false,
  Boolean                       $kerberos       = false,
  Boolean                       $ldap           = false,
  Boolean                       $logrotate      = false,
  Boolean                       $pam            = false,
  Variant[Boolean,Enum['simp']] $pki            = false,
  Boolean                       $sssd           = false,
  Boolean                       $stunnel        = false,
  Boolean                       $syslog         = false,
  Boolean                       $tcpwrappers    = false,
  Simplib::Netlist              $trusted_nets   = ['127.0.0.1', '::1'],
  String                        $package_ensure = 'latest',
  Boolean                       $libkv          = false,
  Boolean                       $puppet         = simp_options::host_probably_puppetserver(),
){
  simplib::validate_net_list($trusted_nets)

  include 'simp_options::dns'
  include 'simp_options::ntpd'
  include 'simp_options::openssl'
  include 'simp_options::rsync'
  include 'simp_options::uid'
  include 'simp_options::gid'

  if $puppet {
    # Be sure to include before simp_options::ldap, as it has defaults
    # that use parameters from this class
    include 'simp_options::puppet'
  }

  if $ldap {
    include 'simp_options::ldap'
  }

  if $pki {
    include 'simp_options::pki'
  }

  if $syslog {
    include 'simp_options::syslog'
  }
}
