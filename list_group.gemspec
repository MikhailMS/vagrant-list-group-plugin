$:.unshift File.expand_path("../lib", __FILE__)
require "list_group/version"

Gem::Specification.new do |spec|
  spec.name          = "list_group"
  spec.version       = ListGroup::VERSION
  spec.platform         = Gem::Platform::RUBY
  spec.license       = "MIT"
  spec.authors       = ["Mikhail Molotkov"]
  spec.email         = ["mikhail.molotkov@bt.com"]
  spec.homepage      = "https://git.nat.bt.com/611788519/vagrant-list-group-plugin"
  spec.summary       = %q{Plugin does simple job - split all VMs presented in Vagrant file into groups and sorts them in alphabetical order}
  spec.description   = %q{In order to successfully use this plugin, follow simple box name pattern -> groupPrefix- or _boxName, ie db-london, db-manchester etc}

  # The following block of code determines the files that should be included
  # in the gem. It does this by reading all the files in the directory where
  # this gemspec is, and parsing out the ignored files from the gitignore.
  # Note that the entire gitignore(5) syntax is not supported, specifically
  # the "!" syntax, but it should mostly work correctly.
  root_path      = File.dirname(__FILE__)
  all_files      = Dir.chdir(root_path) { Dir.glob("**/{*,.*}") }
  all_files.reject! { |file| [".", ".."].include?(File.basename(file)) }
  gitignore_path = File.join(root_path, ".gitignore")
  gitignore      = File.readlines(gitignore_path)
  gitignore.map!    { |line| line.chomp.strip }
  gitignore.reject! { |line| line.empty? || line =~ /^(#|!)/ }

  unignored_files = all_files.reject do |file|
    # Ignore any directories, the gemspec only cares about files
    next true if File.directory?(file)

    # Ignore any paths that match anything in the gitignore. We do
    # two tests here:
    #
    #   - First, test to see if the entire path matches the gitignore.
    #   - Second, match if the basename does, this makes it so that things
    #     like '.DS_Store' will match sub-directories too (same behavior
    #     as git).
    #
    gitignore.any? do |ignore|
      File.fnmatch(ignore, file, File::FNM_PATHNAME) ||
        File.fnmatch(ignore, File.basename(file), File::FNM_PATHNAME)
    end
  end
  

  spec.files         = unignored_files
  spec.executables   = unignored_files.map { |f| f[/^bin\/(.*)/, 1] }.compact
  spec.require_paths = 'lib'

  spec.required_rubygems_version = ">= 1.3.6"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "i18n"
end
