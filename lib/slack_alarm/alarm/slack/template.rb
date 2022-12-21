# frozen_string_literal: true

require 'slack_alarm/alarm/slack/helper'

module Alarm
  module Slack
    module Template
      # Params required:
      #  @description, @stared, @finished, @cmd
      #
      # Params optional:
      #  @exception
      #
      def template_block(opts)
        setup_options(opts)
        output = []
        output << el_description(opts)
        output << el_context(opts) if opts[:context]
        output << el_divider if opts[:context]
        output << el_cmd(opts) if opts[:cmd]
        output << el_started(opts)
        output << el_duration_n_memory(opts)
        output << el_hostname(opts)
        output << el_ruby_version(opts)
      end

      def template_attachment(opts)
        return if blank?(opts[:exception])

        [
          {
            color: opts[:color],
            title: ":octagonal_sign: Error: #{opts[:exception].message}",
            text: "*Backtrace:*\n#{opts[:exception].backtrace.join("\n")}"
          }
        ]
      end

      private

      include Alarm::Slack::Helper

      def el_description(opts)
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*#{opts[:description]}*"
          }
        }
      end

      def el_context(opts)
        {
          type: 'context',
          elements: [
            {
              text: opts[:context],
              type: 'mrkdwn'
            }
          ]
        }
      end

      def el_divider
        {
          type: 'divider'
        }
      end

      def el_cmd(opts)
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*Command:*\n #{hightlight(opts[:cmd])} (#{opts[:env] || 'development'})"
          }
        }
      end

      def el_started(opts)
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*Started:*\n#{opts[:current_time]}"
          }
        }
      end

      def el_duration_n_memory(opts)
        {
          type: 'section',
          fields: [
            {
              type: 'mrkdwn',
              text: "*Duration:*\n#{opts[:duration]}"
            },
            {
              type: 'mrkdwn',
              text: "*Memory:*\n#{opts[:memory]}"
            }
          ]
        }
      end

      def el_hostname(opts)
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*Hostname:*\n#{opts[:hostname]}"
          }
        }
      end

      def el_ruby_version(opts)
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*Version:*\n#{opts[:ruby_version]}"
          }
        }
      end
    end
  end
end
