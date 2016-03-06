kindle-highlights
============

A Ruby gem for collecting your Kindle highlights.

### Install
```
gem install kindle-highlights
```

### Use
```ruby
require 'kindle_highlights'

# pass in your Amazon credentials. Loads your books
# (not highlights) on init, so might take a while
kindle = KindleHighlights::Client.new("email.address@gmail.com", "password")

# returns a hash of your books, keyed on the ASIN, with the title as value
kindle.books #=>
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

# get your highlights for a specific book by passing the ASIN
kindle.highlights_for("B005CQ2ZE6") #=>
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
