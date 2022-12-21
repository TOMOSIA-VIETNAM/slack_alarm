# frozen_string_literal: true

module Alarm
  module Slack
    module Helper
      FORMAT_DATE           = '%Y/%m/%d'
      FORMAT_TIME_WITH_ZONE = '%H:%M %z'

      def setup_options(opts)
        opts[:duration]     = time_elapsed(opts[:started], opts[:finished])
        opts[:current_time] = current_time_with_zone_formated(opts)
      end

      def time_elapsed(from, to)
        return 0 if from.nil? || to.nil?

        duration = (to - from).round(2)
        human_readable_time(duration)
      rescue StandardError => e
        "No estimates. Error: #{e.message}"
      end

      def current_time_with_zone_formated(opts)
        format_dateime_with_zone = valid_format_datetime_with_zone(opts[:format_date])
        return Time.current.strftime(format_dateime_with_zone) if Time.respond_to?(:current) # for Rails

        Time.now.strftime(format_dateime_with_zone)
      end

      def valid_format_datetime_with_zone(format_date)
        format_date = if format_date.nil? || blank?(format_date)
                        FORMAT_DATE
                      else
                        format_date.strip
                      end

        "#{format_date} #{FORMAT_TIME_WITH_ZONE}"
      rescue StandardError
        "#{FORMAT_DATE} #{FORMAT_TIME_WITH_ZONE}"
      end

      def blank?(obj)
        obj.respond_to?(:empty?) ? !!obj.empty? : !obj
      end

      def human_readable_time(secs)
        [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
          next unless secs > 0

          secs, number = secs.divmod(count)
          "#{number.to_i} #{number == 1 ? name.to_s.delete_suffix('s') : name}" unless number.to_i == 0
        end.compact.reverse.join(', ')
      end

      def hightlight(str)
        return '' if blank?(str)

        %(`#{str}`)
      end
    end
  end
end
