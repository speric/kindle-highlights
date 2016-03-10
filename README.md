## kindle-highlights

[![build status](https://secure.travis-ci.org/speric/kindle-highlights.png)](http://travis-ci.org/speric/kindle-highlights)

A Ruby gem for collecting your Kindle highlights.

### Requirements

* Ruby `2.1.0` or greater
* An Amazon Kindle account

<b>Note:</b> Version `0.0.8` of `kindle-highlights` is the last version which is compatible with older
versions of Ruby. For documentation on how to use that
version, see [the release](https://github.com/speric/kindle-highlights/releases/tag/v0.0.8).

### Install
```
gem install kindle-highlights
```

### Use

First, `require` the gem and initialize a new client by passing in the email address & password you use
to sign into your Amazon Kindle account:

```ruby
require 'kindle_highlights'

kindle = KindleHighlights::Client.new(email_address: "email.address@gmail.com", password: "password")
```

### Fetching a list of your Kindle books

Use the `books` method to get a listing of all your Kindle books. This method
returns a hash, keyed on the ASIN, with the title as the value:

```ruby
kindle.books
#=>
{
  "B002JCSCO8" => "The Art of the Commonplace: The Agrarian Essays of Wendell Berry",
  "B0049SPHC0" => "Calvinistic Concept of Culture, The",
  "B003HNOB34" => "The Collected Works of William Butler Yeats (Unexpurgated Edition) (Halcyon Classics)",
  "B000JMKZX6" => "The Essays of Arthur Schopenhauer; On Human Nature",
  "B005CQ2ZE6" => "From the Garden to the City",
  "B0082ZJFCO" => "The Golden Sayings of Epictetus",
  "B000SEGEKI" => "The Pragmatic Programmer: From Journeyman to Master",
  "B009D6AGOM" => "The Rare Jewel of Christian Contentment",
  "B00E25KVLW" => "Ruby on Rails 4.0 Guide",
  "B004X5RLBY" => "The Seven Lamps of Architecture",
  "B0032UWX1O" => "The Westminster Confession of Faith",
  "B0026772N8" => "Zen and the Art of Motorcycle Maintenance"
}
```

### Fetching all highlights for a single book

To get only the highlights for a specific book, use the `highlights_for` method, passing
in the book's Amazon ASIN as the only method parameter:

```ruby
kindle.highlights_for("B005CQ2ZE6")
#=>
[
  {
    "asin"          => "B005CQ2ZE6",
    "customerId"    => "...",
    "embeddedId"    => "From_the_Garden_to_the_City:420E805A",
    "endLocation"   => 29591,
    "highlight"     => "One of the most dangerous things you can believe in this world is that technology is neutral.",
    "howLongAgo"    => "1 year ago",
    "startLocation" => 29496,
    "timestamp"     => 1320901233000
  },
  {
    "asin"          => "B005CQ2ZE6",
    "customerId"    => "...",
    "embeddedId"    => "From_the_Garden_to_the_City:420E805A",
    "endLocation"   => 54220,
    "highlight"     => "While God's words are eternal and unchanging, the tools we use to access those words do change, and those changes in technology also bring subtle changes to the practice of worship. When we fail to recognize the impact of such technological change, we run the risk of allowing our tools to dictate our methods. Technology should not dictate our values or our methods. Rather, we must use technology out of our convictions and values.",
    "howLongAgo"    => "1 year ago",
    "startLocation" => 53780,
    "timestamp"     => 1321038422000
  }
]
```

### Advanced Usage

This gem uses [mechanize](https://github.com/sparklemotion/mechanize) to interact with Amazon's Kindle pages. You can override any of the default mechanize settings (see `lib/kindle_highlights/client.rb`) by passing your settings to the initializer:

```ruby
kindle = KindleHighlights::Client.new(
  email_address: "me@example.com",
  password: "amazon_password",
  mechanize_options: { user_agent_alias: 'Mac Safari' }
)
```

### A Note About CAPTCHAs

Amazon will sometimes issue a CAPTCHA challenge when logging in to your
Kindle account. If this happens when the gem attempts to log in to your
Kindle account to retrieve your book list or highlights via this gem, you'll get a `KindleHighlights::Client::CaptchaError`, like the following:

```ruby
> kindle.books
KindleHighlights::Client::CaptchaError: Received a CAPTCHA while attempting to sign in to your Amazon account. You will need to resolve this manually at https://www.amazon.com/ap/signin?openid.pape.max_auth_age=0&openid...
```

There's no way to programmatically resolve this situation. The best
solution I've found is to open a browser, visit the URL that the gem returns, log in to
your Kindle account, and click around a bit. Then log out of your Kindle
account and re-attempt to fetch your highlights via this gem. Additionally, you could try
instantiating a new instance of the client and changing the User-Agent
via `mechanize_options` like:

```ruby
kindle = KindleHighlights::Client.new(
  email_address: "me@example.com",
  password: "amazon_password",
  mechanize_options: { user_agent_alias: 'iPhone' }
)
```

### In The Wild
* [tobi/highlights](https://github.com/tobi/highlights) - Download your Kindle highlights and email random ones to your inbox

### Contributing to kindle-highlights (PRs welcome)

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the [issue tracker](http://github.com/speric/kindle-highlights/issues) to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for the feature/bugfix. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate it to its own commit so I can cherry-pick around it.

### Copyright

Copyright (c) 2011-2016 Eric Farkas. See MIT-LICENSE for details.
