# Public: Variables for working with CMSSW.
#
# Examples:
#
#   require cmssw::config
class cmssw::config {
  
  $installdir = "/opt/cms"
  $cmddir = "${installdir}/bin"

  $scramarch = $operatingsystem ? {
      "Darwin" => $macosx_productversion_major ? {
        "10.6" => "osx106_amd64_gcc462",
        "10.7" => "osx107_amd64_gcc472",
        "10.8" => "osx108_amd64_gcc481",
        "10.9" => "osx109_amd64_gcc481",
        default => "unknown"
      },
      default => "slc6_amd64_gcc481"
  }
}
