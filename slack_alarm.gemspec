# frozen_string_literal: true

require_relative 'lib/slack_alarm/version'

Gem::Specification.new do |spec|
  spec.name          = 'slack_alarm'
  spec.version       = SlackAlarm::VERSION
  spec.authors       = ['Tăng Quốc Minh', 'Nguyễn Xuân Tài']
  spec.email         = ['minh.tang1@tomosia.com', 'tai.nguyen@tomosia.com', 'vhquocminhit@gmail.com', 'nxt23081997@gmail.com', ]

  spec.summary       = 'Monitoring your project and pushing notifications to Slack.'
  spec.description   = 'Monitoring your project and pushing notifications to Slack.'
  spec.homepage      = 'https://guides.rubygems.org/'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.8')

  spec.metadata['allowed_push_host'] = 'https://github.com/'

  # spec.metadata['rubygems_mfa_required'] = 'true' # preparation for future release - expect it to be MFA signed
  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["{lib}/**/*.rb"]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'slack-notifier', '2.4.0'
end
