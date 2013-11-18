# This is a placeholder class.
class cmssw($scramarch = $cmssw::config::scramarch,
            $installdir = $cmssw::config::installdir,
            $cmddir = $cmssw::config::cmddir,
) inherits cmssw::config {
  include boxen::config
  include cmssw::repo

  file {
    [$installdir, $cmddir, $libdir]:
      ensure => 'directory';

    # Helpers to simplify installation.
    "${cmddir}/cms-bootstrap":
      source => 'puppet:///modules/cmssw/cms-bootstrap';

    "${cmddir}/cms-install":
      source => 'puppet:///modules/cmssw/cms-install';

    "${cmddir}/cms-uninstall":
      source => 'puppet:///modules/cmssw/cms-uninstall';

    "${cmddir}/cms-needs-install":
      source => 'puppet:///modules/cmssw/cms-needs-install';
  }

  ->
  boxen::env_script {"cmssw":
    content => template('cmssw/env.sh.erb'),
    priority => higher,
  }


  define bootstrap($path, $arch, $repository="cms") {
    exec { "boostrap":
      command => "/usr/bin/cms-bootstrap setup -r ${repository} -path ${path} -arch ${arch}",
      cwd => "${path}",
      creates => "${path}/${arch}/external/apt/429/etc/profile.d/init.sh",
      user => "cms_",
      require => File["/usr/bin/cms-bootstrap"],
      logoutput => true
    }
  }
}
