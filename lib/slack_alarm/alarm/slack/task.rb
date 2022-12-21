# frozen_string_literal: true

require 'slack-notifier'
require 'slack_alarm/alarm/slack/template'

module Alarm
  module Slack
    class Task
      attr_reader :opts, :notifier, :exception

      def initialize(opts)
        @opts = opts || {}
        @notifier = ::Slack::Notifier.new(opts[:webhook_url]) do
          defaults  channel: opts[:channel],
                    username: opts[:username]
          middleware format_message: { formats: [:html] }, format_attachments: { formats: [:markdown] }
        end
      end

      def self.perform(options, &block)
        options ||= {}
        est_time_spent(options) { est_memory_usage(options, &block) }
      rescue StandardError => e
        options[:exception] = e
      ensure
        slack = Alarm::Slack::Task.new(options)
        slack.push_notice
      end

      def push_notice
        notifier.post(
          blocks: template_block(opts),
          attachments: template_attachment(opts),
          icon_emoji: opts[:avatar]
        )
      end

      private

      include Alarm::Slack::Template

      def self.est_memory_usage(options, &block)
        memory_before = `ps -o rss= -p #{Process.pid}`.to_i
        block.call
      ensure
        memory_after = `ps -o rss= -p #{Process.pid}`.to_i
        options[:memory] = "#{((memory_after - memory_before) / 1024.0).round(2)} MB"
      end

      def self.est_time_spent(options, &block)
        options[:started] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        block.call
      ensure
        options[:finished] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end
    end
  end
end
