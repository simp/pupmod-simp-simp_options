#
# simp_options class
#
# Sets up variables that enable core SIMP capabilities or provide site
# configuration larger than the scope of a single module.
#
# @param auditd Whether to include SIMP's ``::auditd`` class and add audit rules
#   pertinent to each application
#
# @param clamav Whether SIMP should manage ``ClamAV``
#
# @param fips Whether to enable ``FIPS`` mode for the system.
#
#  This parameter enforces strict compliance with ``FIPS-140-2``.
#
#  All core SIMP modules can support this configuration. It is important that
#  you know the security tradeoffs of ``FIPS-140-2`` compliance.
#
#  ``FIPS`` mode disables the use of ``MD5`` and may require weaker ciphers or
#  key lengths than your security policies allow.
#
# @see http://simp.readthedocs.io/en/master/security_mapping/components/simplib/cryptographic_protection/control.html SIMP - Security Control Mapping Cryptographic Protection
#
# @param firewall Whether to include SIMP's firewall class ``::iptables``
#   and add rules pertinent to each application.
#
# @param haveged Whether to include the ``::haveged`` class to ensure adequate
#   entropy for key generation
#
# @see http://simp.readthedocs.io/en/master/getting_started_guide/ISO_Build/Environment_Preparation.html?highlight=haveged SIMP - Getting Started Environment Preparation
#
# @param ipsec Whether to include SIMP's ``ipsec`` class, ``::libreswan``, and
#   add rules pertinent to each application.
#
# @param kerberos Whether to include the SIMP's Kerberos class, ``::krb5``, and
#   to use ``Kerberos`` in applicable modules
#
# @param ldap Whether modules should use ``LDAP``.
#
# @param logrotate Whether to include SIMP's `::logrotate`` class
#   and add rules pertinent to each application.
#
# @param pam Whether to include SIMP's ``::pam`` class SIMP to manage ``PAM``
#
# @param pki Whether to include SIMP's ``::pki`` class and use ``pki::copy`` to
#   distribute PKI certificates to the correct locations.
#   If false, don't include SIMP's ``::pki`` class, and don't use ``::pki::copy``.
#   If true,  don't include SIMP's ``::pki`` class, but use ``::pki::copy``.
#   If 'simp', include SIMP's ``::pki`` class, and use ``::pki::copy``.
#
# @param selinux Whether to include SIMP's ``::selinux`` class (which
#   effectively manages the ``SELinux`` enforcement and mode) and manage
#   SIMP-specific ``SELinux`` configurations
#
# @param sssd Whether to use ``SSSD``
#
# @param stunnel Whether to include SIMP's ``::stunnel`` class and use it to
#   secure server-to-server communications in applicable modules
#
# @param syslog Whether to include SIMP's ``::rsyslog`` class and configure
#   RSyslog application hooks
#
# @param tcpwrappers Whether to include SIMP's ``::tcpwrappers`` class and
#   use ``tcpwrappers::allow`` to permit the application to the subnets in
#   ``$::simp_options::trusted_nets``
#
# @param trusted_nets Subnets to permit, in ``CIDR`` notation.
#
#   If you need this to be more (or less) restrictive for a given class, you
#   can override it for the specific class via that class' parameters.
# @param package_ensure The default ensure parmeter for packages.
#
#   Can be either 'latest' or 'installed'; currently defaults to 'latest' for
#   historical reasons. Default may change in a newer version.
#
# @param libkv Feature flag for libkv.
#
#   If set to true, it will enable the libkv backend for some functions.
#
# @author SIMP Team - https://simp-project.com
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
  Boolean                       $selinux        = false,
  Boolean                       $sssd           = false,
  Boolean                       $stunnel        = false,
  Boolean                       $syslog         = false,
  Boolean                       $tcpwrappers    = false,
  Simplib::Netlist              $trusted_nets   = ['127.0.0.1', '::1'],
  String                        $package_ensure = 'latest',
  Boolean                       $libkv          = false,
){
  validate_net_list($trusted_nets)

  include '::simp_options::dns'
  include '::simp_options::ntpd'
  include '::simp_options::openssl'
  include '::simp_options::puppet'
  include '::simp_options::rsync'

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
