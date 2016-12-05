[![License](http://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html) [![Build Status](https://travis-ci.org/simp/pupmod-simp-simp_options.svg)](https://travis-ci.org/simp/pupmod-simp-simp_options) [![SIMP compatibility](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with simp_options](#setup)
    * [What simp_options affects](#what-simp_options-affects)
    * [Beginning with simp_options](#beginning-with-simp_options)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

This module provides variables needed by one or more SIMP module.

## This is a SIMP module
This module is a component of the [System Integrity Management Platform](https://github.com/NationalSecurityAgency/SIMP), a compliance-management framework built on Puppet.

Most SIMP modules actively take advantage of this module when used within the SIMP ecosystem.

## Module Description

The `simp_options` module primarily provides variables that are
* Enablers of capabilities provided or used by SIMP modules.
* Data that describes the configuration of a site.
  * The scope of the data is larger than the scope of a single module.
  * 0..n unrelated profiles might make use of this data.

Some of these variables support SIMP's security compliance reporting.

## Setup

### What simp_options affects

The variables provided by `simp_options` are used by SIMP modules to
enable and/or configure capabilities.

### Beginning with simp_options

`simp_options` is configured for you when you run ```simp config``` on your SIMP
system.  Otherwise, setup is simple:  include the class as the first class in your
```site.pp``` and select the desired capabilities through Hiera or your ENC.

--------------------

 **NOTE**

 The ```environments/simp/hieradata/simp_defs.yaml``` file delivered with the
 simp puppet module is an example file that can be used to create the
 appropriate hieradata for your site.

--------------------

## Usage

TODO - Need to describe the nuances of the global catalysts?
* More details of what they do than what is in each manifest
* How they are related/interoperate.
* Any bad stuff that can happen if you don't enable them.

## Reference

TODO - Anything to put here?  Module is trivial, so further explanation
doesn't seem warranted.

## Limitations

This module is applicable to SIMP systems or systems containing SIMP components.

## Development

Please see the [SIMP Contribution Guidelines](https://simp-project.atlassian.net/wiki/display/SD/Contributing+to+SIMP).
