# @summary Sets up variables that enable core SIMP capabilities or provide site configuration larger than the scope of a single module
#
# @param auditd
#   Include SIMP's ``auditd`` class and add audit rules pertinent to each
#   application
#
# @param clamav
#   Deprecated - DO NOT USE
#
# @param fips
#   Enable ``FIPS`` mode for the system
#
#   This parameter enforces strict compliance with ``FIPS-140-2``.
#
#   All core SIMP modules can support this configuration. It is important that
#   you know the security tradeoffs of ``FIPS-140-2`` compliance.
#
#   ``FIPS`` mode disables the use of ``MD5`` and may require weaker ciphers or
#   key lengths than your security policies allow.
#
#   @see http://simp.readthedocs.io/en/stable/security_mapping/components/simp/cryptographic_protection/control.html SIMP - Security Control Mapping Cryptographic Protection
#
# @param firewall
#   Indicate that you want to load the native SIMP firewall management subsystem
#
# @param haveged
#   Include the ``haveged`` class to ensure adequate entropy for key
#   generation
#
#   @see http://simp.readthedocs.io/en/stable/getting_started_guide/Installation_Options/ISO/ISO_Build/Environment_Preparation.html?highlight=haveged SIMP - Getting Started Environment Preparation
#
# @param ipsec
#   Include SIMP's ``ipsec`` class, ``libreswan``, and add rules pertinent to
#   each application
#
# @param kerberos
#   Include the SIMP's Kerberos class, ``krb5``, and to use ``Kerberos`` in
#   applicable modules
#
# @param ldap
#   Encourage modules to use ``LDAP`` support where possible
#
# @param logrotate
#   Include SIMP's ``logrotate`` class and add rules pertinent to each
#   application
#
# @param pam
#   Include SIMP's ``pam`` class SIMP to manage ``PAM``
#
# @param pki
#   Include SIMP's ``pki`` class and use ``pki::copy`` to distribute PKI
#   certificates to the correct locations
#
#   * If ``false``, don't include SIMP's ``pki`` class, and don't use
#     ``pki::copy``
#   * If ``true``,  don't include SIMP's ``pki`` class, but do use ``pki::copy``
#   * If ``simp``, include SIMP's ``pki`` class, and use ``pki::copy``
#
# @param sssd
#   Enable ``SSSD`` support where possible
#
# @param stunnel
#   Include SIMP's ``stunnel`` class and use it to secure server-to-server
#   communications in applicable modules
#
# @param syslog
#   Include SIMP's ``rsyslog`` class and configure RSyslog application hooks
#
# @param tcpwrappers
#   Whether to include SIMP's ``tcpwrappers`` class and use
#   ``tcpwrappers::allow`` to permit the application to the subnets in
#   ``$simp_options::trusted_nets``
#
# @param trusted_nets
#   Subnets to permit, in ``CIDR`` notation
#
#   * If you need this to be more (or less) restrictive for a given class, you
#     can override it for the specific class via that class' parameters.
#
# @param package_ensure
#   The default ensure parameter for packages
#
#   * Can be either ``latest`` or ``installed``
#
# @param libkv
#   Enable the libkv backend for some functions
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
  Boolean                       $libkv          = false
){
  simplib::validate_net_list($trusted_nets)

  include 'simp_options::puppet'
  include 'simp_options::dns'
  include 'simp_options::ntp'
  include 'simp_options::ntpd'
  include 'simp_options::openssl'
  include 'simp_options::rsync'
  include 'simp_options::uid'
  include 'simp_options::gid'

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
