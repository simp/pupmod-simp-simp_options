#
# simp_options class
#
# Sets up variables that enable core SIMP capabilities or provide site
# configuration larger than the scope of a single module.
#
# @param auditd
#   Include SIMP's ``::auditd`` class and add audit rules pertinent to each
#   application
#
# @param clamav
#   Enable SIMP use of ``ClamAV``
#
# @param fips
#   Whether to enable ``FIPS`` mode for the system in accordaince with the SIMP
#   ``fips`` module
#
#   * This parameter enforces strict compliance with ``FIPS-140-2``
#   * All core SIMP modules can support this configuration
#   * It is important that you know the security tradeoffs of ``FIPS-140-2``
#     compliance
#   * ``FIPS`` mode disables the use of ``MD5`` and may require different
#     ciphers or key lengths than your security policies allow
#
# @see http://simp.readthedocs.io/en/master/security_mapping/components/simplib/cryptographic_protection/control.html SIMP - Security Control Mapping Cryptographic Protection
#
# @param firewall
#   Include SIMP's firewall class ``::iptables`` and add rules pertinent to
#   each application.
#
# @param haveged 
#   Include the ``::haveged`` class to ensure adequate entropy for key
#   generation
#
# @see http://simp.readthedocs.io/en/master/getting_started_guide/ISO_Build/Environment_Preparation.html?highlight=haveged SIMP - Getting Started Environment Preparation
#
# @param ipsec
#   Include SIMP's ``ipsec`` class, ``::libreswan``, and add rules pertinent to
#   each application.
#
# @param kerberos
#   Include the SIMP's Kerberos class, ``::krb5``, and to use ``Kerberos`` in
#   applicable modules
#
# @param ldap
#   Enable module capabilities related to ``LDAP``.
#
# @param libkv Feature flag for libkv.
#   Enable the ``libkv`` backend for some functions.
#
# @param logrotate
#   Include SIMP's `::logrotate`` class and add rules pertinent to each
#   application.
#
# @param pam
#   Include SIMP's ``::pam`` class SIMP to manage ``PAM``
#
# @param reboot_notifications
#   Enable reboot notifications from modules that support the feature
#
# @param pki
#   Include SIMP's ``::pki`` class and use ``pki::copy`` to distribute PKI
#   certificates to the correct locations.
#
#   * ``'simp'`` => include SIMP's ``::pki`` class, and use ``::pki::copy``.
#   * ``false``  => don't include SIMP's ``::pki`` class, and don't use ``::pki::copy``.
#   * ``true``   => don't include SIMP's ``::pki`` class, but use ``::pki::copy``.
#
# @param selinux
#   Include SIMP's ``::selinux`` class (which effectively manages the
#   ``SELinux`` enforcement and mode) and manage SIMP-specific ``SELinux``
#   configurations
#
# @param sssd
#   Enable SIMP management of ``SSSD``
#
# @param stunnel
#   Include SIMP's ``::stunnel`` class and use it to secure server-to-server
#   communications in applicable modules
#
# @param syslog
#   Include SIMP's ``::rsyslog`` class and configure RSyslog application hooks
#
# @param tcpwrappers
#   Include SIMP's ``::tcpwrappers`` class and use ``tcpwrappers::allow`` to
#   permit the application to the subnets in ``$::simp_options::trusted_nets``
#
# @param trusted_nets
#   Subnets to permit, in ``CIDR`` notation.
#
#   * If you need this to be more (or less) restrictive for a given class, you
#     can override it for the specific class via that class' parameters.
#
# @param package_ensure
#   The default ``ensure`` parmeter for packages.
#
#   * Can be either ``latest`` or ``installed``; currently defaults to
#   ``latest`` for historical reasons. Default may change in a newer version.
#
# @author SIMP Team - https://simp-project.com
#
class simp_options (
  Boolean                       $auditd               = false,
  Boolean                       $clamav               = false,
  Boolean                       $fips                 = false,
  Boolean                       $firewall             = false,
  Boolean                       $haveged              = false,
  Boolean                       $ipsec                = false,
  Boolean                       $kerberos             = false,
  Boolean                       $ldap                 = false,
  Boolean                       $libkv                = false,
  Boolean                       $logrotate            = false,
  Boolean                       $pam                  = false,
  Boolean                       $reboot_notifications = true,
  Boolean                       $selinux              = false,
  Boolean                       $sssd                 = false,
  Boolean                       $stunnel              = false,
  Boolean                       $syslog               = false,
  Boolean                       $tcpwrappers          = false,
  Simplib::Netlist              $trusted_nets         = ['127.0.0.1', '::1'],
  String                        $package_ensure       = 'latest',
  Variant[Boolean,Enum['simp']] $pki                  = false,
){
  validate_net_list($trusted_nets)

  include '::simp_options::dns'
  include '::simp_options::ntpd'
  include '::simp_options::openssl'
  include '::simp_options::puppet'
  include '::simp_options::rsync'
  include '::simp_options::uid'
  include '::simp_options::gid'

  if $ldap {
    include '::simp_options::ldap'
  }

  if $pki {
    include '::simp_options::pki'
  }

  if $syslog {
    include '::simp_options::syslog'
  }
}
