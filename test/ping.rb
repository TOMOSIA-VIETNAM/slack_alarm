# frozen_string_literal: true

require 'slack_alarm'
require 'pry'

SlackAlarm.configure do |config|
  config.webhook_url  = 'xxx'
  config.channel      = '#xxx'
  config.username     = 'ALARM'
  config.avatar       = ':squirrel:'
  config.context      = 'Announcement from the *TOMOSIA Developer team*'
  config.hostname     = `hostname`
  config.ruby_version = `ruby -v`
end

SlackAlarm.perform(
  description: 'How are you today?',
  cmd: 'bundle exec healthy:how_are_you'
  # username: 'EH',
  # avatar: ':alien: ',
  # context: 'How are you today?',
  # hostname: 'minh.tang.local',
  # ruby_version: '2.7.5'
) do
  p 'Hello world'
end
