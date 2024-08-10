# Aws::Cron::Parser

## Installation

```ruby
gem 'aws-cron-parser', github: 'MacoTasu/aws-cron-parser', branch: 'main'
```

## Usage

```ruby
# in case: time is 2021-08-09 00:00:00 +0000

require 'aws-cron-parser'

cron = Aws::Cron::Parser.new('cron(0 0 * * ? *)')

cron.next(Time.now) # => 2021-08-10 00:00:00 +0000

cron.in_range(Time.now, Time.now + 2.day) # => [2021-08-10 00:00:00 +0000, 2021-08-11 00:00:00 +0000]
```

By default, the calculation results are returned within the range of the current year and month at runtime.
If you want to perform operations outside of this range, specify the range conditions as arguments to Aws::Cron::Parser.new.

```ruby
# example
Aws::Cron::Parser.new('cron(0 0 * * ? *)', Time.now.month, Time.now.month + 1)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/aws-cron-parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/aws-cron-parser/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Aws::Cron::Parser project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/aws-cron-parser/blob/main/CODE_OF_CONDUCT.md).
