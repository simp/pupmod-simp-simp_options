# AGENTS.md

This file provides guidance to AI agents when working with code in this repository.

## What this module does

`simp-simp_options` is the SIMP Puppet module that **defines the SIMP
global-options catalog** — the `simp_options::*` Hiera keys that virtually every
other SIMP module reads (via `simplib::lookup('simp_options::*', { ... })`) to
decide whether to enable a cross-cutting feature (FIPS, firewall, PKI, LDAP,
syslog, …) or to pick up a site-wide value (trusted networks, package ensure,
DNS/NTP servers, UID/GID ranges). It manages **no system state itself**: it
declares no packages, services, files, or exec resources. It exists solely to
give the SIMP module ecosystem a single, typed, validated place to set these
shared toggles and values.

The top-level `simp_options` class is the canonical declaration of the
feature-toggle parameters (`manifests/init.pp`). Its sub-classes
(`simp_options::dns`, `::ntp`, `::pki`, `::ldap`, `::puppet`, …) declare the
namespaced *configuration values* other modules consume. Because
`simp_options`'s parameters are typed with `data_type` classes from `simp/simplib`
(`Simplib::Netlist`, `Simplib::Host`, `Simplib::URI`, …), setting a malformed
value fails compilation here rather than silently misconfiguring a downstream
module.

### Business logic

The public entry point is the `simp_options` class; all thirteen other classes
are private (`assert_private()`) and are option *namespaces*, not consumer-facing
classes.

- **`simp_options` (`manifests/init.pp`)** — the public class. Its
  parameters (`init.pp`) are the canonical `simp_options::*` feature
  toggles. All are `Boolean` and default `false` **except**:
  - `$pki` — `Variant[Boolean,Enum['simp']]`, default `false`
    (`init.pp`); `false` = don't include SIMP's `pki` class and don't use
    `pki::copy`; `true` = don't include the class but do use `pki::copy`;
    `'simp'` = include the class and use `pki::copy` (`init.pp`).
  - `$trusted_nets` — `Simplib::Netlist`, default `['127.0.0.1', '::1']`
    (`init.pp`).
  - `$package_ensure` — `String`, default `'latest'` (`init.pp`).

  The full toggle set (`init.pp`): `auditd`, `authselect`, `clamav`
  (**deprecated — do not use**, `init.pp`), `fips`, `firewall`, `haveged`,
  `ipsec`, `kerberos`, `ldap`, `logrotate`, `pam`, `pki`, `sssd`, `stunnel`,
  `syslog`, `tcpwrappers`, `trusted_nets`, `package_ensure`, `libkv`.

  Body (`init.pp`):
  - `simplib::validate_net_list($trusted_nets)` (`init.pp`).
  - **Unconditionally** `include`s eight namespace sub-classes:
    `simp_options::puppet`, `::dns`, `::ntp`, `::ntpd`, `::openssl`, `::rsync`,
    `::uid`, `::gid` (`init.pp`).
  - **Conditionally** includes three more, gated on the matching toggle:
    `simp_options::ldap` if `$ldap`, `simp_options::pki` if `$pki`,
    `simp_options::syslog` if `$syslog` (`init.pp`).

- **Namespace sub-classes** — each is `assert_private()` and simply declares
  typed, Hiera-overridable parameters (plus, in some, a `simplib::validate_*`
  call). Non-obvious defaults:
  - **`simp_options::openssl` / `::openssl::params`** — `$cipher_suite`
    defaults from `simp_options::openssl::params` (`openssl.pp`), which
    `inherits` `params`. `params` is the only sub-class that is
    FIPS-aware: it `include`s `simp_options` and, if `$simp_options::fips` **or**
    the `fips_enabled` fact is set, uses `$facts['fips_ciphers']` (failing hard
    if that fact is absent), otherwise `['DEFAULT', '!MEDIUM']`
    (`openssl/params.pp`).
  - **`simp_options::puppet`** — `$server_distribution` auto-detects PE vs PC1
    from the `pe_build`/`is_pe` facts; `$ca_port` defaults to the PE agent's
    `ca_port` on PE, else `8141` (`puppet.pp`).
  - **`simp_options::ldap`** — `$bind_pw`, `$bind_hash`, `$sync_pw`,
    `$sync_hash` are **required** (no default, `ldap.pp`); `$master`
    derives from `simp_options::puppet::server` and the DN defaults derive from
    `simplib::ldap::domain_to_dn()` (`ldap.pp`).
  - **`simp_options::ntpd`** — `$servers` is **deprecated**; use
    `simp_options::ntp` instead (`ntpd.pp`).
  - **`simp_options::uid` / `::gid`** — `$min`/`$max` default from the
    `login_defs` fact (`uid.pp`, `gid.pp`).
  - **`simp_options::pki`** — `$source` defaults to `/etc/pki/simp/x509`
    (`pki.pp`).
  - **`simp_options::rsync`** — `$server` defaults to `127.0.0.1` (rsync over
    stunnel), `$timeout` to `1` second (`rsync.pp`).
  - **`simp_options::dns`**, **`::syslog`** — empty-array list defaults, each
    validated with `simplib::validate_net_list` (`dns.pp`,
    `syslog.pp`).

### Gotchas / non-obvious details

- **This module manages no system state.** No packages, services, files, or
  execs — it only declares typed parameters and validates them. Do not add
  state-managing resources here; that belongs in the consuming modules.
- **`clamav` and `ntpd::servers` are deprecated** (`init.pp`,
  `ntpd.pp`). Leave them in place for backward compatibility but do not build
  new behavior on them; `simp_options::ntp` supersedes `ntpd`.
- **`simp_options::openssl::params` fails compilation** on a FIPS host if the
  `fips_ciphers` fact is missing (`openssl/params.pp`) — it has no fallback
  in that branch.
- **`simp_options::ldap` has four required parameters** with no defaults
  (`ldap.pp`); merely toggling `simp_options::ldap: true` without
  supplying `bind_pw`/`bind_hash`/`sync_pw`/`sync_hash` in Hiera will fail
  compilation.
- **Toggling `$pki` is tri-state**, not boolean (`init.pp`) — the
  `'simp'` value has distinct semantics from `true`.
- **The eight always-included sub-classes always compile**, even when their
  feature is off — they publish default values that downstream modules read
  regardless. Only `ldap`, `pki`, and `syslog` are gated (`init.pp`).

## This module publishes the `simp_options::*` seam (it does not consume it)

Other SIMP modules' AGENTS.md docs carry a "simp_options / simplib::lookup"
seam table listing the `simplib::lookup('simp_options::*', { 'default_value' =>
… })` calls that module makes to *read* the catalog. **That table format does
not apply here, and there is none to write:** `simp_options` is the **source**
of those keys, not a consumer of them. It contains no
`simplib::lookup('simp_options::*', …)` calls; it *declares* the parameters that
those lookups resolve against.

The canonical top-level keys it publishes (`manifests/init.pp`) are:

`simp_options::auditd`, `simp_options::authselect`, `simp_options::clamav`
(deprecated), `simp_options::fips`, `simp_options::firewall`,
`simp_options::haveged`, `simp_options::ipsec`, `simp_options::kerberos`,
`simp_options::ldap`, `simp_options::logrotate`, `simp_options::pam`,
`simp_options::pki`, `simp_options::sssd`, `simp_options::stunnel`,
`simp_options::syslog`, `simp_options::tcpwrappers`,
`simp_options::trusted_nets`, `simp_options::package_ensure`,
`simp_options::libkv`.

The namespaced sub-class keys (e.g. `simp_options::dns::servers`,
`simp_options::ntp::servers`, `simp_options::puppet::server`,
`simp_options::pki::source`, `simp_options::ldap::bind_pw`,
`simp_options::openssl::cipher_suite`, `simp_options::rsync::server`,
`simp_options::uid::min`, `simp_options::gid::min`,
`simp_options::syslog::log_servers`) are declared by the correspondingly-named
sub-classes under `manifests/`.

When adding a new site-wide option, add it here (as a typed parameter with a
sensible default and a puppet-strings `@param` docstring) so the whole SIMP
ecosystem can read it through one validated seam — do not scatter ad-hoc lookups
into individual modules.

## Dependencies

Module dependencies (from `metadata.json`):

- `puppetlabs/stdlib` `>= 8.0.0 < 10.0.0`
- `simp/simplib` `>= 4.9.0 < 6.0.0` (provides `simplib::lookup`,
  `simplib::validate_net_list`, `simplib::validate_uri_list`,
  `simplib::ldap::domain_to_dn`, `assert_private`, and the `Simplib::*` data
  types the parameters are typed with)

There are **no optional dependencies** (no `simp.optional_dependencies` in
`metadata.json`).

Fixture-only setup (from `.fixtures.yml`): `simplib` and `stdlib` are checked
out as repositories; `simp_options` itself is symlinked from the source dir.

Runtime requirement (from `metadata.json` `requirements`): `openvox
>= 8.0.0 < 9.0.0`.

Supported OS matrix (from `metadata.json`): CentOS 9/10; RedHat 8/9/10;
OracleLinux 8/9/10; Rocky 8/9/10; AlmaLinux 8/9/10.

## Repository layout

- `manifests/init.pp` — the public `simp_options` class; the canonical
  feature-toggle parameter declarations.
- `manifests/{dns,gid,ldap,ntp,ntpd,pki,puppet,rsync,syslog,uid}.pp` — the
  private (`assert_private()`) option-namespace sub-classes.
- `manifests/openssl.pp`, `manifests/openssl/params.pp` — the openssl namespace;
  `openssl` inherits `openssl::params`, which is the only FIPS-aware sub-class.
- `metadata.json` — deps, OS matrix, OpenVox requirement.
- `spec/classes/*_spec.rb` — rspec-puppet unit tests (one per public/testable
  class: `init`, `dns`, `ldap`, `ntp`, `ntpd`, `openssl`, `puppet`, `rsync`,
  `syslog`).
- `spec/fixtures/hieradata/*.yaml` — hieradata used by the specs, including
  several `*_with_invalid_*` files that assert the type/`validate_*` checks
  reject bad input.
- `REFERENCE.md` — generated Puppet Strings reference.
- No `data/` or `hiera.yaml` — this module ships **no module-level Hiera data**;
  all values come from consumers' Hiera or the parameter defaults in the
  manifests.
- No `lib/`, `types/`, or `templates/` — this module has no custom Ruby
  types/providers/functions/facts, no custom Puppet data types, and no
  templates. Every data type and function it uses comes from `simp/simplib`.
- No `spec/acceptance/` and no `spec/acceptance/nodesets/` — this module has no
  system state to exercise, so there is no beaker acceptance suite.
- **CI is unit-only:** `.github/workflows/pr_tests.yml` runs six jobs —
  `puppet-syntax`, `puppet-style`, `ruby-style`, `file-checks`,
  `releng-checks`, and `spec-tests`. There is **no acceptance job**.

## Common commands

```sh
# Install dependencies
bundle install

# Run all unit tests
bundle exec rake spec

# Run a single class spec
bundle exec rspec spec/classes/init_spec.rb

# Puppet lint
bundle exec rake lint

# Ruby lint
bundle exec rake rubocop

# Regenerate REFERENCE.md from puppet-strings docstrings
puppet strings generate --format markdown --out REFERENCE.md
```

Relevant gem pins (from `Gemfile`): `puppetlabs_spec_helper ~> 8.0.0`
(line 33), `simp-rake-helpers ~> 5.24.0` (line 39), `simp-beaker-helpers
~> 2.0.0` (line 55). Rubocop is pinned to `~> 1.88.0` (line 16). The tested
Puppet range defaults to `['>= 8', '< 9']` (line 23), and the Gemfile installs
**both** the `openvox` and `puppet` gems at that version via
`['openvox', 'puppet'].each do |gem_name|` (line 30) until the `puppet`
dependency is dropped from other gems. `spec/spec_helper.rb` requires
`puppetlabs_spec_helper/module_spec_helper`.

## Conventions

- **This is the SIMP options catalog — add new site-wide options here.** When a
  toggle or value needs to be readable across SIMP modules, declare it as a
  typed parameter on `simp_options` (or the appropriate `simp_options::*`
  sub-class) with a sensible default, rather than inventing a lookup key that
  lives only in a consuming module.
- **Type every parameter** with the narrowest appropriate `Simplib::*` /
  stdlib / core type and, where a value is a host/URI/network list, back it with
  the matching `simplib::validate_*` call — this is how malformed site config
  gets caught at compile time here instead of downstream.
- **Keep the namespace sub-classes `assert_private()`.** They are option
  namespaces, not consumer entry points; consumers read the *values*, they do
  not `include` these classes directly.
- Preserve the `@summary` / `@param` puppet-strings docstrings on every class —
  they drive `REFERENCE.md`. Regenerate `REFERENCE.md` after changing docs or
  parameters.
- Leave deprecated parameters (`clamav`, `simp_options::ntpd::servers`) in place
  for backward compatibility; do not build new behavior on them.
- `Gemfile`, `spec/spec_helper.rb`, and `.github/workflows/pr_tests.yml` carry a
  **puppetsync** notice — they are baseline-managed and the next sync overwrites
  local edits. Push changes to those files upstream to the baseline, not here.
- Match the existing 2-space Puppet indentation and aligned-arrow parameter
  style used in `manifests/init.pp`.
