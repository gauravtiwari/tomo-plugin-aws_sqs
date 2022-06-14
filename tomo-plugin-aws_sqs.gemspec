require_relative "lib/tomo/plugin/aws_sqs/version"

Gem::Specification.new do |spec|
  spec.name = "tomo-plugin-aws_sqs"
  spec.version = Tomo::Plugin::AwsSqs::VERSION
  spec.authors = ["Matt Brictson"]
  spec.email = ["opensource@gauravtiwari.com", "gaurav@gauravtiwari.co.uk"]

  spec.summary = "Aws::Sqs background tasks for tomo"
  spec.homepage = "https://github.com/gauravtiwari/tomo-plugin-aws_sqs"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/gauravtiwari/tomo-plugin-aws_sqs/issues",
    "changelog_uri" => "https://github.com/gauravtiwari/tomo-plugin-aws_sqs/releases",
    "source_code_uri" => "https://github.com/gauravtiwari/tomo-plugin-aws_sqs",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tomo", "~> 1.0"
end
