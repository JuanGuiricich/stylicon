# frozen_string_literal: true

require_relative "lib/stylicon/version"

Gem::Specification.new do |spec|
  spec.name = "stylicon"
  spec.version = Stylicon::VERSION
  spec.authors = ["JG"]
  spec.email = ["jguiricich@gmail.com"]

  spec.summary = "Generate performant CSS classes from SVGs using YAML configuration."
  spec.description = "Stylicon is a tool that takes SVG files and a YAML config to generate optimized CSS classes with embedded base64 icons. Ideal for rendering scalable, cacheable icons without bloating HTML or requiring runtime transformations."
  spec.homepage = "https://github.com/JuanGuiricich/stylicon"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/JuanGuiricich/stylicon"
  spec.metadata["changelog_uri"] = "https://github.com/JuanGuiricich/stylicon/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["stylicon"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
