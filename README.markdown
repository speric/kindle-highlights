kindle-highlights
============

*Get your Kindle highlights via Amazon's Kindle site*

There's currently no Kindle API, so I built a scraper.

**Required gems**

* ruby-aaws
* Mechanize

**Install**
	
	gem install kindle-highlights
**Use**

	last_fm = LastFm.new("ericfarkas") #initialize with your last.fm username
	
	#top artists overall
	top_artists = last_fm.topartists
	top_artists.first.name
	=> "Thrice"
	top_artists.first.playcount
	=> "2600"
	top_artists.first.url
	=> "http://www.last.fm/music/Thrice"

	# top artists for the last 3 months	
	top_artists = last_fm.topartists(3)

	# top artists for the last 6 months
	top_artists = last_fm.topartists(6)

	# latest weekly artist chart	
	weekly = last_fm.weeklyartistchart


**TODO**

* Include notes/gotchas on setting up ruby-aaws
* Cache AWS Product API results to save time
* Get all highlights; Amazon currently does an infinite-scroll at the page bottom which loads highlights dynamically.  Currently the gem only gets the first "page" of highlights.
