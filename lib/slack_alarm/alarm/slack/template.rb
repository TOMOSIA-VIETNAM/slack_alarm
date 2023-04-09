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
        add_el_header(output, opts[:header])
        add_el_started_n_duration(output, opts)
        add_el_body(output, opts[:body])
        add_el_footer(output, opts[:footer])

        output
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

      def el_divider
        {
          type: 'divider'
        }
      end

      def add_el_header(output, opts_header)
        output << el_description(opts_header)
        return output if opts_header[:context].nil?

        output << el_context(opts_header)
        output << el_divider
      end

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

      def add_el_started_n_duration(output, opts)
        el = { type: 'section' }

        fields = %i[started current_time].map do |key|
          {
            type: 'mrkdwn',
            text: "*#{key.to_s.capitalize}:*\n#{opts[key]}"
          }
        end

        el.merge(fields: fields)
        output << el
      end

      def add_el_body(output, opts_body)
        opts_body.each do |sections|
          if sections.length > 1
            add_group_sections(output, sections)
          else
            add_single_section(output, sections.first)
          end
        end
      end

      def add_single_section(output, section)
        return if blank?(section)

        section.each do |key, value|
          output << {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "*#{key}:*\n #{value})"
            }
          }
        end
      end

      def add_group_sections(output, sections)
        return if blank?(sections)

        sections.each_slice(2) do |fields|
          fields_content = []
          fields.each do |field|
            field.each do |key, value|
              fields_content << {
                type: 'mrkdwn',
                text: "*#{key.capitalize}:*\n#{value}"
              }
            end
          end
          output << {
            type: 'section',
            fields: fields_content
          }
        end
      end

      def add_el_footer(output, opts_footer)
        return if blank?(opts_footer)

        output << el_divider
        opts_footer.each do |section|
          add_single_section(output, section)
        end
      end
    end
  end
end
