# Provides a "best guess" method for determining if the current host is a
# puppet server. Makes all sorts of assumptions and may, or may not, be what
# you want (but probably is).
#
Puppet::Functions.create_function(:'simp_options::host_probably_puppetserver') do

  # @return [Boolean]
  #   `true` if the local system appears to be a potential puppetserver
  def host_probably_puppetserver
    found_puppetserver_apps?
  end

  private

  def found_puppetserver_apps?
    !Dir.glob(File.join('opt', 'puppetlabs', 'server', 'bin')).empty?
  end
end
