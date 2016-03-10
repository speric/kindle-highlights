require 'kindle_highlights'
require 'minitest/autorun'

class FetchingAllHighlightsForABookTest < Minitest::Test
  def setup
    @kindle = KindleHighlights::Client.new(
      email_address: "amazon@example.com",
      password: "letmein"
    )
    @kindle.mechanize_agent       = FakeMechanizeAgentForSingleBook.new
    @kindle.kindle_logged_in_page = "<html></html>"
  end

  def test_fetching_all_quotes_from_a_kindle_book
    quotes = @kindle.highlights_for("B003XDUCEU")

    assert_equal 2, quotes.count

    assert_equal "B003XDUCEU", quotes.first["asin"]
    assert_equal "CUS_ID", quotes.first["customerId"]
    assert_equal "CR!SDMDM6529H7S511VQ7R627N2J874:EE63BD4D", quotes.first["embeddedId"]
    assert_equal 40116, quotes.first["endLocation"]
    assert_equal "A good manager creates opportunity, but it&rsquo;s your responsibility to take it.", quotes.first["highlight"]
    assert_equal "3 hours ago", quotes.first["howLongAgo"]
    assert_equal 40041, quotes.first["startLocation"]
    assert_equal 1457525264000, quotes.first["timestamp"]

    assert_equal "B003XDUCEU", quotes.last["asin"]
    assert_equal "CUS_ID", quotes.last["customerId"]
    assert_equal "CR!SDMDM6529H7S511VQ7R627N2J874:EE63BD4D", quotes.last["embeddedId"]
    assert_equal 43633, quotes.last["endLocation"]
    assert_equal "Any task, big or small, that has landed on your plate and you failed to complete is eroding your reputation.", quotes.last["highlight"]
    assert_equal "3 hours ago", quotes.last["howLongAgo"]
    assert_equal 43536, quotes.last["startLocation"]
    assert_equal 1457525368000, quotes.last["timestamp"]
  end

  class FakeMechanizeAgentForSingleBook
    def get(asin_url)
      FakeResponse.new(asin_url)
    end

    class FakeResponse
      def initialize(asin_url)
        @asin_url = asin_url
      end

      def body
        if @asin_url =~ /cursor=0/
          response_with_items
        else
          response_without_items
        end.to_json
      end

      def response_without_items
        {
          "items" => []
        }
      end

      def response_with_items
        {
          "items" => [
            {
              "asin"          => "B003XDUCEU",
              "customerId"    => "CUS_ID",
              "embeddedId"    => "CR!SDMDM6529H7S511VQ7R627N2J874:EE63BD4D",
              "endLocation"   => 40116,
              "highlight"     => "A good manager creates opportunity, but it&rsquo;s your responsibility to take it.",
              "howLongAgo"    => "3 hours ago",
              "startLocation" => 40041,
              "timestamp"     => 1457525264000
            },
            {
              "asin"          => "B003XDUCEU",
              "customerId"    => "CUS_ID",
              "embeddedId"    => "CR!SDMDM6529H7S511VQ7R627N2J874:EE63BD4D",
              "endLocation"   => 43633,
              "highlight"     => "Any task, big or small, that has landed on your plate and you failed to complete is eroding your reputation.",
              "howLongAgo"    => "3 hours ago",
              "startLocation" => 43536,
              "timestamp"     => 1457525368000
            }
          ]
        }
      end
    end
  end
end
