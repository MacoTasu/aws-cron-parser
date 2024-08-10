# frozen_string_literal: true

require 'active_support/time'
require 'timecop'

RSpec.describe Aws::Cron::Parser do
  before do
    Timecop.freeze(Time.new(2024, 8, 1, 0, 0, 0))
  end

  after do
    Timecop.return
  end


  it 'has a version number' do
    expect(Aws::Cron::Parser::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'should initialize the cron_parser' do
      parser = Aws::Cron::Parser.new('cron(* * * * * *)')
      expect(parser).to be_a(Aws::Cron::Parser)
    end

    it 'should set the cron_expression' do
      parser = Aws::Cron::Parser.new('cron(* * * * * *)')
      expect(parser.cron_expression).to eq('* * * * * *')
    end
  end

  describe 'AWS cron expression patterns' do
    let(:now) { Time.now }

    patterns = {
      'Every minute' => 'cron(* * * * * *)',
      'Every 5 minutes' => 'cron(*/5 * * * * *)',
      'Every hour' => 'cron(0 * * * * *)',
      'Every day at midnight' => 'cron(0 0 * * * *)',
      'Every Monday at midnight' => 'cron(0 0 * * 1 *)',
      'Every 1st of the month at midnight' => 'cron(0 0 1 * * *)',
      'Every January 1st at midnight' => 'cron(0 0 1 1 * *)',
      'Every weekday at midnight' => 'cron(0 0 * * 1-5 *)',
      'Every weekend at midnight' => 'cron(0 0 * * 0,6 *)',
      'Every Monday to Friday at midnight using abbreviations' => 'cron(0 0 * * MON-FRI *)',
      'Every Saturday at midnight using abbreviation' => 'cron(0 0 * * SAT *)',
      'Every day at midnight with ? in day of month' => 'cron(0 0 ? * * *)',
      'Every day at midnight with ? in day of week' => 'cron(0 0 * * ? *)',
      'Every day at 00:00' => 'cron(00 00 * * * *)'
      # TODO: Implement these patterns
      # "Every last day of the month at midnight" => "cron(0 0 L * * *)",
      # "Every last weekday of the month at midnight" => "cron(0 0 LW * * *)",
      # "Every 2nd Friday of the month at midnight" => "cron(0 0 ? * 6#2 *)"
    }

    patterns.each do |description, cron_expression|
      it "parses #{description}" do
        parser = Aws::Cron::Parser.new(cron_expression)
        expect(parser).to be_a(Aws::Cron::Parser)
        expect(parser.times).not_to be_empty
      end
    end
  end

  describe '#next' do
    it 'returns the next time after a given time' do
      parser = Aws::Cron::Parser.new('cron(0 0 * * * *)')
      next_time = parser.next(Time.new(2024, 8, 2, 0, 0, 0))
      expect(next_time).to eq(Time.new(2024, 8, 3, 0, 0, 0))
    end
  end

  describe '#in_range' do
    it 'returns all times within a given range' do
      parser = Aws::Cron::Parser.new('cron(0 0 * * * *)')
      start_time = Time.new(2024, 8, 1, 0, 0, 0)
      end_time = Time.new(2024, 8, 3, 0, 0, 0)
      times = parser.in_range(start_time, end_time)
      expect(times).to eq([
                            Time.new(2024, 8, 2, 0, 0, 0),
                            Time.new(2024, 8, 3, 0, 0, 0)
                          ])
    end
  end
end
