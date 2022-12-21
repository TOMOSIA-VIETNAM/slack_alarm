# frozen_string_literal: true

module SlackAlarm
  # Used to set up and modify settings for the retryable.
  class Configuration
    VALID_OPTION_KEYS = %i[
      webhook_url
      channel
      username
      avatar
      context
      ruby_version
      hostname
      color
    ].freeze

    attr_accessor(*VALID_OPTION_KEYS)

    def initialize
      @avatar       = ':squirrel:'
      @username     = 'ALARM'
      @webhook_url  = ''
      @channel      = ''
      @context      = ''
      @ruby_version = `ruby -v`
      @hostname     = `hostname`
      @color        = '#e74c3c'
    end

    # Returns a hash of all configurable options
    def to_hash
      VALID_OPTION_KEYS.each_with_object({}) do |key, memo|
        memo[key] = instance_variable_get("@#{key}")
      end
    end

    # Returns a hash of all configurable options merged with +hash+
    #
    # @param [Hash] hash A set of configuration options that will take precedence over the defaults
    def merge(hash)
      to_hash.merge(hash)
    end
  end

  class << self
    attr_writer :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
