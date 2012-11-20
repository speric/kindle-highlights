require 'test/unit'
require 'rubygems'
require 'yaml'

$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'kindle_highlights'

AMAZON = YAML.load_file(File.dirname(__FILE__) + "/../config/amazon.yml")

class KindleHighlightsTest < Test::Unit::TestCase
  def setup
    @kindle = KindleHighlight.new(AMAZON['email'], AMAZON['password'])
  end
  
  def test_can_login_and_scrape_highlights
    highlight = @kindle.highlights.first
    assert_not_nil highlight
    assert_not_nil highlight.annotation_id
    assert_not_nil highlight.content
  end
end