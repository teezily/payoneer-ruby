## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payoneer-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install payoneer-ruby

## Usage

```ruby
# Configuration
Payoneer.configure do |c|
  c.environment = 'production'
  c.partner_id = '<payoneer_account_id>'
  c.partner_username = '<payoneer_account_username>'
  c.partner_api_password = '<payoneer_api_password>'
  c.auto_approve_sandbox_accounts = true # if you want sandbox accounts to be automatically approved after signup
end

# Check Payoneer API status. See Payoneer documentation for possible error codes
response = Payoneer::System.status
response.code
=> "000"
response.body
=> "Echo OK - All systems are up"
response.ok?
=> true

# Get Payee Signup URL
Payoneer::Payee.signup_url('payee_1')
Payoneer::Payee.signup_url('payee_1', redirect_url: 'http://<redirect_url>.com')
Payoneer::Payee.signup_url('payee_1', redirect_url: 'http://<redirect_url>.com', redirect_time: 10) #seconds

response = Payoneer::Payee.signup_url('payee_1')
signup_url = response.body if response.ok?

# Get Payee Details

response = Payoneer::Payee.details('payee_1')
payee = response.body if response.ok?
p payee["PayeeStatus"]

# Perform Payout for Payee
response = Payoneer::Payout.create(
  program_id: '<payoneer_program_id>',
  payment_id: 'payment_1',
  payee_id: 'payee_1',
  amount: 4.20,
  description: 'payee payout',
  payment_date: Time.now, #defaults to Time.now
  currency: 'USD' #defaults to USD
)

p 'Payout created!' if response.ok?

# Status of a Payout

response = Payoneer::Payout.status(payee_id: 'payee_1', payment_id: 'payment_1')
p response.body
=> 'Payment completed'

# Cancel a Payout
response = Payoneer::Payout.cancel('payment_1') # payment_id
p response.body
=> { 'PaymentID' => 'payment1',
     'Result' => '000',
     'Amount' => '5.00',
     'Curr' => 'USD',
     'Description' => 'Long description of the payout' }

# Balance of the partner
response = Payoneer::Partner.balance
p response.body
=> { 'FeesDue' => '110.45',
     'AccountBalance' => '222.33',
     'Curr' => 'USD' }

```

## Development

After checking out the repo, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Docker

Build Image:
- docker build -t payoneer .

Run spec:
- docker run -it payoneer rspec spec

Launch guard
- docker run -v ${PWD}:/home/app -it payoneer guard

## Contributing

1. Fork it ( https://github.com/[my-github-username]/payoneer-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
