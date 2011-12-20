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

	TO DO


**TODO**

* Include notes/gotchas on setting up ruby-aaws
* Cache AWS Product API results to save time
* Get all highlights; Amazon currently does an infinite-scroll at the page bottom which loads highlights dynamically.  Currently the gem only gets the first "page" of highlights.
