## kindle-highlights

[![build status](https://secure.travis-ci.org/speric/kindle-highlights.png)](http://travis-ci.org/speric/kindle-highlights)

A Ruby gem for collecting your Kindle highlights.

### Requirements

* Ruby `2.1.0` or greater
* An Amazon Kindle account

### Install
```
gem install kindle-highlights
```

### Use

First, `require` the gem and initialize a new client by passing in the email address & password you use
to sign into your Amazon Kindle account:

```ruby
require 'kindle_highlights'

kindle = KindleHighlights::Client.new(
  email_address: "email.address@gmail.com",
  password: "password"
)
```

### Fetching a list of your Kindle books

Use the `books` method to get a listing of all your Kindle books. This method
returns a collection of `KindleHighlights::Book` objects:

```ruby
kindle.books
#=>
[
  <KindleHighlights::Book:
      @asin="B000XUAETY",
      @author="James R. Mcdonough",
      @title="Platoon Leader: A Memoir of Command in Combat"
  >,
  <KindleHighlights::Book:
    @asin="B003XDUCEU",
    @author="Michael Lopp",
    @title="Being Geek: The Software Developer's Career Handbook"
  >,
  <KindleHighlights::Book:
    @asin="B00JJ1RIO2",
    @author="James K. A. Smith",
    @title="How (Not) to Be Secular: Reading Charles Taylor"
  >
]
```

Each `Book` object has it's `asin`, `author`, `title`, `page` and `note` as attributes:

```ruby
book = kindle.books.first
book.asin
#=> "B000XUAETY"
book.author
#=> "James R. Mcdonough"
book.title
#=> "Platoon Leader: A Memoir of Command in Combat"
book.page
#=> "Page: 7"
book.note
#=> "This is a note!"
```

### Fetching all highlights for a single book

To get only the highlights for a specific book, use the `highlights_for` method, passing
in the book's Amazon ASIN as the only method parameter. This method returns a collection of
`KindleHighlights::Highlight` objects:

```ruby
kindle.highlights_for("B005CQ2ZE6")
#=>
[
  <KindleHighlights::Highlight:0x007fc4e7e03ea0
    @asin="B005CQ2ZE6",
    @text="One of the most dangerous things you can believe in this world is that technology is neutral.",
    @location="197"
    @page="Page:7"
    @note="This is a note"
  >
]
```

Each `Highlight` object has the book's `asin`, the `text` of the highlight, the `page` number if available (it returns "Location: xx" if not available), it's `location`, and any `note` associated with the highlight (this will return _null_ if there is no note) as attributes:

```ruby
highlight = kindle.highlights_for("B005CQ2ZE6").first

highlight.asin
#=> "B005CQ2ZE6"
highlight.text
#=> "One of the most dangerous things you can believe in this world is that technology is neutral."
highlight.page
#=> "Page: 7"
highlight.location
#=> "197"
highlight.note
#=> "This is a note"
```

Additionally, each book has it's own `highlights_from_amazon` method:

```
book = kindle.books.first
book.highlights_from_amazon
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
Kindle account to retrieve your book list or highlights, you'll get a `KindleHighlights::Client::CaptchaError`, like the following:

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

Copyright (c) 2011-2018 Eric Farkas. See MIT-LICENSE for details.
