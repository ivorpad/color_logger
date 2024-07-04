# frozen_string_literal: true

require_relative "lib/color_logger/version"

Gem::Specification.new do |spec|
  spec.name = "color_logger"
  spec.version = ColorLogger::VERSION
  spec.authors = ["Ivor Padilla"]
  spec.email = ["ivorjpc@gmail.com"]

  spec.summary       = %q{A colorful logger for Rails applications}
  spec.description   = %q{ColorLogger provides a customizable, colorful logging solution for Rails applications, with file and line number information.}
  spec.homepage      = "https://github.com/ivorpad/color_logger"
  spec.license       = "MIT"
  spec.required_ruby_version =  Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ivorpad/color_logger"
  spec.metadata["changelog_uri"] = "https://github.com/ivorpad/color_logger/CHANGELOG.rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
