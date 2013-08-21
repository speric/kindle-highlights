kindle-highlights
============

*Get your Kindle highlights via Amazon's Kindle site*

There's currently no Kindle API, so I built a scraper.
                                  
If you're looking for an older version of this gem, check out v0.0.7 at [https://github.com/speric/kindle-highlights/tree/v0.0.7](https://github.com/speric/kindle-highlights/tree/v0.0.7)

**Required gems**

* mechanize (2.7.2)

**Install**
```
gem install kindle-highlights
```

**Use**
```ruby
require 'kindle_highlights'

# pass in your Amazon credentials
# loads all your Kindle books on init, so might take a while                                                             
kindle = KindleHighlights::Client.new("sgt.pepper@lonelyhearts.com", "mr_kite") 

kindle.books #returns a hash, keyed on the book's ASIN, with the title as the value

/
{
  "B002JCSCO8"=>"The Art of the Commonplace: The Agrarian Essays of Wendell Berry",
  "B0049SPHC0"=>"Calvinistic Concept of Culture, The",
  "B003HNOB34"=>"The Collected Works of William Butler Yeats (Unexpurgated Edition) (Halcyon Classics)",
  "B000JMKZX6"=>"The Essays of Arthur Schopenhauer; On Human Nature",
  "B005CQ2ZE6"=>"From the Garden to the City",
  "B0082ZJFCO"=>"The Golden Sayings of Epictetus",
  "B000SEGEKI"=>"The Pragmatic Programmer: From Journeyman to Master",
  "B009D6AGOM"=>"The Rare Jewel of Christian Contentment",
  "B00E25KVLW"=>"Ruby on Rails 4.0 Guide",
  "B004X5RLBY"=>"The Seven Lamps of Architecture",
  "B0032UWX1O"=>"The Westminster Confession of Faith",
  "B0026772N8"=>"Zen and the Art of Motorcycle Maintenance"
}
/

#get your highlights for a specific book
kindle.highlights_for("B005CQ2ZE6")

[
  {
	  "asin"=>"B005CQ2ZE6",
	  "customerId"=>"...",
	  "embeddedId"=>"From_the_Garden_to_the_City:420E805A",
	  "endLocation"=>29591,
	  "highlight"=>"One of the most dangerous things you can believe in this world is that technology is neutral.",
	  "howLongAgo"=>"1 year ago",
	  "startLocation"=>29496,
	  "timestamp"=>1320901233000
  },
	{
		"asin"=>"B005CQ2ZE6",
		"customerId"=>"...",                                    
		"embeddedId"=>"From_the_Garden_to_the_City:420E805A",
		"endLocation"=>54220,
		"highlight"=>"While God's words are eternal and unchanging, the tools we use to access those words do change, and those changes in technology also bring subtle changes to the practice of worship. When we fail to recognize the impact of such technological change, we run the risk of allowing our tools to dictate our methods. Technology should not dictate our values or our methods. Rather, we must use technology out of our convictions and values.",
		"howLongAgo"=>"1 year ago",
		"startLocation"=>53780,
		"timestamp"=>1321038422000
	}
}	
```                                                    

**TODO**
* Documentation
* Tests            

**Contribute**
My goal here was to make something lightweight and useful. If you have ideas for making it better, fork the project, improve it, and submit a PR. Pull requests are very much welcome.