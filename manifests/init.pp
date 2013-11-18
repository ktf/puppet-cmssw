# This is a placeholder class.
class cmssw($scramarch = $cmssw::config::scramarch,
            $installdir = $cmssw::config::installdir,
            $cmddir = $cmssw::config::cmddir,
) inherits cmssw::config {

  if $osfamily == "RedHat" {
      file {"/etc/sudoers.d/999-cmsbuild-requiretty":
        content => "Defaults:root !requiretty\n",
      }
  }
  else { 
    boxen::env_script {"cmssw":
      content => template('cmssw/env.sh.erb'),
      priority => higher,
    }
  }
  user {"cmsbuild": }
  ->
  file {"/opt":
    ensure => directory,
  }
  ->
  file {"/opt/cms":
    ensure => directory,
    owner => "cmsbuild",
  }
}
