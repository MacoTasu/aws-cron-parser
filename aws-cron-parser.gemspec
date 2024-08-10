# frozen_string_literal: true

require_relative 'lib/aws/cron/parser'

Gem::Specification.new do |spec|
  spec.name = 'aws-cron-parser'
  spec.version = Aws::Cron::Parser::VERSION
  spec.authors = ['MacoTasu']
  spec.email = ['maco.tasu+github@gmail.com']

  spec.summary = 'This is a simple gem to parse cron expressions for AWS cron'
  spec.description = ''
  spec.homepage = 'https://github.com/MacoTasu/aws-cron-parser'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
