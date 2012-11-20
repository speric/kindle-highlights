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
    unless @@amazon_items.has_key?(asin)
      request = Request.new
      request.locale = 'us'
      response = ResponseGroup.new('Small')
      lookup = Amazon::AWS::ItemLookup.new('ASIN', {'ItemId' => asin, 'MerchantId' => 'Amazon'})
      amazon_item = request.search(lookup, response).item_lookup_response[0].items.item.first
      @@amazon_items[asin] = amazon_item
    end
    @@amazon_items[asin]
  end
end