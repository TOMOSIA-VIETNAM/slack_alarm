# frozen_string_literal: true

require 'slack_alarm/version'
require 'slack_alarm/initializers/configuration'
require 'slack_alarm/alarm/slack/task'

module SlackAlarm
  class Error < StandardError; end

  class << self
    # A SlackAlarm configuration object. Must act like a hash and return sensible
    # values for all SlackAlarm configuration options. See SlackAlarm::Configuration.
    attr_writer :configuration

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   SlackAlarm.configure do |config|
    #     config.webhook_url  = ""
    #     config.channel      = ""
    #     config.avatar       = ""
    #     config.username     = ""
    #     config.context      = ""
    #     config.hostname     = ""
    #     config.ruby_version = ""
    #   end
    def configure
      yield(configuration)
    end

    # The configuration object.
    # @see SlackAlarm.configure
    def configuration
      @configuration ||= Configuration.new
    end

    def perform(options, &block)
      options = {} unless options.is_a?(Hash)
      options = configuration.to_hash.merge(options)

      raise ArgumentError, 'no block given' unless block_given?

      raise ArgumentError, "'description' key is missing" unless options.key?(:description)

      Alarm::Slack::Task.perform(options, &block)
    end
  end
end
