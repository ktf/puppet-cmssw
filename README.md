# Puppet module for installing CMSSW packages.

This puppet module (hopefully compatible with boxen), hopefully simplifies
installation of CMSSW packages providing a working CMS environment.

## Usage

To install packages via:

```puppet
package { 'cms+cmssw+CMSSW_7_0_0_pre3':
  ensure => 'present'
}
```

**NOTE:** For the moment this is limited to `slc6_amd64_gcc481` only for the
moment.

## Required Puppet Modules

boxen can optionally be used.
