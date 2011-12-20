require 'rubygems'
require 'mechanize'
require 'amazon/aws'
require 'amazon/aws/search'

include Amazon::AWS
include Amazon::AWS::Search

class KindleHighlight
	attr_accessor :highlights
	
	def initialize(email_address, password)
		@agent = Mechanize.new
		page = @agent.get("https://www.amazon.com/ap/signin?openid.return_to=https%3A%2F%2Fkindle.amazon.com%3A443%2Fauthenticate%2Flogin_callback%3Fwctx%3D%252F&pageId=amzn_kindle&openid.mode=checkid_setup&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.pape.max_auth_age=0&openid.assoc_handle=amzn_kindle&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select")
		@amazon_form = page.form('signIn')
		@amazon_form.email = email_address
		@amazon_form.password = password
		scrape_highlights
	end

	def scrape_highlights
		signin_submission = @agent.submit(@amazon_form)
		highlights_page = @agent.click(signin_submission.link_with(:text => /Your Highlights/))
		collected_highlights = Array.new
		highlights_page.search(".//div[@class='highlightRow yourHighlight']").each do |h|
			collected_highlights << Highlight.new(h)
		end
		self.highlights = collected_highlights
	end
end

class KindleHighlight::Highlight

	attr_accessor :annotation_id, :asin, :author, :title, :content

	@@amazon_items = Hash.new

	def initialize(highlight)
		self.annotation_id = highlight.xpath("form/input[@id='annotation_id']").attribute("value").value 
		self.asin = highlight.xpath("p/span[@class='hidden asin']").text
		self.content = highlight.xpath("span[@class='highlight']").text
		amazon_item = lookup_or_get_from_cache(self.asin)
		self.author = amazon_item.item_attributes.author.to_s
		self.title = amazon_item.item_attributes.title.to_s
	end

	def lookup_or_get_from_cache(asin)
		unless @@amazon_items.has_key? (asin)
			request = Request.new
			request.locale = 'us'
			response = ResponseGroup.new('Medium')
			lookup = Amazon::AWS::ItemLookup.new('ASIN', {'ItemId' => asin, 'MerchantId' => 'Amazon'})
			puts amazon_item = request.search(lookup, response).item_lookup_response[0].items.inspect
			amazon_item = request.search(lookup, response).item_lookup_response[0].items.item.first
			@@amazon_items[asin] = amazon_item
		end
		@@amazon_items[asin]
	end
end