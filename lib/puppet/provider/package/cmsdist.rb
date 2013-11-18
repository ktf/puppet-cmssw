require "pathname"
require "puppet/provider/package"
require "puppet/util/execution"

Puppet::Type.type(:package).provide :cmsdist, :parent => Puppet::Provider::Package do
  include Puppet::Util::Execution

  has_feature :unversionable

  def self.home
    if boxen_home = Facter.value(:boxen_home)
      "#{boxen_home}/homebrew"
    else
      "/opt/cms"
    end
  end

  def self.bootstrapped?
    Kernel.system "source #{self.home}/#{self.architecture}/external/apt/*/etc/profile.d/init.sh 2>/dev/null; which apt-get"
  end

  def self.architecture
    "slc6_amd64_gcc481"
  end

  def self.cms_user
    "cmsbuild"
  end

  # Helper function to boostrap a CMSSW environment.
  def bootstrap
    if not self.class.bootstrapped?
      execute ["mkdir", "-p", self.class.home]
      execute ["chown", "cmsbuild", self.class.home]
      execute ["wget", "-O", File.join([self.class.home, "bootstrap-#{self.class.architecture}.sh"]), "http://cmsrep.cern.ch/cmssw/cms/bootstrap.sh"]
      execute ["sudo", "-u", self.class.cms_user, "sh", "-x", File.join([self.class.home, "bootstrap-#{self.class.architecture}.sh"]), "setup", "-path", self.class.home, "-arch", self.class.architecture]
    end
  end
  
  def install
    bootstrap
    group, package, version = @resource[:name].split "+"
    Kernel.system "sudo -u #{self.class.cms_user} bash -c 'source #{self.class.home}/#{self.class.architecture}/external/apt/*/etc/profile.d/init.sh ;  apt-get install -y #{@resource[:name]}'"
  end

  def query 
    bootstrap
    group, package, version = @resource[:name].split "+"
    existance = File.exists? File.join([self.class.home, self.class.architecture, group, package, version])
    if not existance
      return nil
    else
      return { :ensure => "1.0", :name => @resource[:name] }
    end
  end

  def self.instances
    return []
  end


  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end

  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  def self.execute(*args)
    if Puppet.features.bundled_environment?
      Bundler.with_clean_env do
        super
      end
    else
      super
    end
  end
end
