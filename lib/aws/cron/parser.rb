# frozen_string_literal: true

module Aws
  module Cron
    class Parser
      VERSION = '0.1.0'
      class Error < StandardError; end

      attr_reader :cron_expression, :minutes, :hours, :days, :months, :weekdays, :years, :times

      WDAYS = {
        sun: '0',
        mon: '1',
        tue: '2',
        wed: '3',
        thu: '4',
        fri: '5',
        sat: '6'
      }.freeze

      # @param cron_expression [String] A cron expression e.g. cron("* * * * * *")
      def initialize(origin_cron_expression, min_month = Time.now.month, max_month = Time.now.month, min_year = Time.now.year, max_year = Time.now.year)
        @cron_expression = origin_cron_expression.gsub(/cron\(/, '').gsub(/\)/, '')

        parts = cron_expression.split

        raise Error, 'Invalid cron expression' if parts[2] == '?' && parts[4] == '?'

        raise Error, 'Invalid cron expression' if parts.length != 6

        @minutes = parse_part(parts[0], 0, 59)
        @hours = parse_part(parts[1], 0, 23)
        @days = parse_part(parts[2], 1, 31)
        @months = parse_part(parts[3], min_month, max_month)
        @weekdays = parse_part(convert_to_wday_number(parts[4]), 0, 6)
        @years = parse_part(parts[5], min_year, max_year)

        # FIXME: This is a temporary implementation
        # Need to implement a more efficient way to calculate the times
        @times = []
        @years.each do |year|
          @months.each do |month|
            @days.each do |day|
              @hours.each do |hour|
                @minutes.each do |minute|
                  time = Time.new(year, month, day, hour, minute)
                  @times << time if @weekdays.include?(time.wday)
                end
              end
            end
          end
        end
        @times = @times.sort
      end

      def next(time = Time.now)
        @times.each do |t|
          return t if t > time
        end
        nil
      end

      def in_range(start_time, end_time)
        raise ArgumentError, 'start_time must be less than end_time' if start_time > end_time

        times = []
        next_time = self.next(start_time)
        return times if next_time.nil?

        while next_time <= end_time
          times << next_time
          next_time = self.next(next_time)
          break if next_time.nil?
        end

        times
      end

      private

      def parse_part(part, min, max)
        result = []
        part.split(',').each do |subpart|
          if subpart.include?('-')
            range = subpart.split('-').map(&:to_i)
            result.concat((range[0]..range[1]).to_a)
          elsif subpart.include?('/')
            step = subpart.split('/').last.to_i
            result.concat((min..max).step(step).to_a)
          elsif ['*', '?'].include?(subpart)
            result.concat((min..max).to_a)
          else
            result << subpart.to_i
          end
        end
        result.uniq.sort
      end

      # mon, mon-sun, mon-fri
      def convert_to_wday_number(wday)
        return wday if is_numeric?(wday)

        wdays = ''
        wday.split(',').each_with_index do |w, index|
          wdays += ',' if index > 0

          if w.include?('-')
            range = w.split('-')
            wdays += if is_numeric?(range[0]) && is_numeric?(range[1])
                       "#{range[0]}-#{range[1]}"
                     else
                       "#{WDAYS[range[0].downcase.to_sym]}-#{WDAYS[range[1].downcase.to_sym]}"
                     end
          elsif ['*', '?'].include?(w)
            wdays += w
          else
            wdays += if is_numeric?(w)
                       w
                     else
                       WDAYS[w.downcase.to_sym]
                     end
          end
        end

        wdays
      end

      def is_numeric?(str)
        !!(str =~ /\A[-+]?\d+(\.\d+)?\z/)
      end
    end
  end
end
