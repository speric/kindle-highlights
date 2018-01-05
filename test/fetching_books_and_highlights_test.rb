require 'kindle_highlights'
require 'minitest/autorun'

class FetchingBooksAndHighlightsTest < Minitest::Test
  def setup
    @kindle = KindleHighlights::Client.new(
      email_address: "amazon@example.com",
      password: "letmein"
    )
    @kindle.mechanize_agent = FakeMechanizeAgent.new
    @kindle.kindle_logged_in_page = Mechanize::Page.new(
      URI('http://foo'),
      nil,
      raw_signin_page,
      200,
      Mechanize.new
    )
  end

  def test_fetching_books_from_kindle_account
    assert_equal 1, @kindle.books.count

    book = @kindle.books.first
    assert_equal "B000XUAETY", book.asin
    assert_equal "James R. Mcdonough", book.author
    assert_equal "Platoon Leader: A Memoir of Command in Combat", book.title
  end

  def test_fetching_highlights_for_a_book
    highlights = @kindle.highlights_for("B000XUAETY")
    assert_equal 1, highlights.count

    highlight = highlights.first
    assert_equal "306", highlight.location
    assert_equal "Destiny is not born of decision; it is born of uncontrollable circumstances.", highlight.text
    assert_equal "B000XUAETY", highlight.asin
    assert_equal "Page: 7", highlight.page
    assert_equal "This is a note!", highlight.note
  end

  def test_fetching_highlights_for_a_non_existing_asin
    assert_raises KindleHighlights::Client::AsinNotFoundError do
      @kindle.highlights_for("BADASIN")
    end
  end

  def raw_signin_page
    <<-BODY
<div id="kp-notebook-library" class="a-row">
  <div id="B000XUAETY" class="a-row kp-notebook-library-each-book aok-hidden">
    <span
      class="a-declarative"
      data-action="get-annotations-for-asin"
      data-get-annotations-for-asin="{&quot;asin&quot;:&quot;B000XUAETY&quot;}"
    >
      <a class="a-link-normal a-text-normal" href="javascript:void(0);">
        <div class="a-row">
          <div class="a-column a-span4 a-push4 a-spacing-medium a-spacing-top-medium">
            <img
              alt=""
              src="https://images-na.ssl-images-amazon.com/images/I/51jqQLu+ApL._SY160.jpg"
              class="kp-notebook-cover-image kp-notebook-cover-image-border"
            >
          </div>
        </div>
        <h2 class="a-size-base a-color-base a-text-center kp-notebook-searchable a-text-bold">
          Platoon Leader: A Memoir of Command in Combat
        </h2>
        <p class="a-spacing-base a-spacing-top-mini a-text-center a-size-base a-color-secondary kp-notebook-searchable">
          By: James R. Mcdonough
        </p>
      </a>
    </span>
    <input type="hidden" name="" value="Thursday November 16, 2017" id="kp-notebook-annotated-date-B000XUAETY">
  </div>
</div>
    BODY
  end

  class FakeMechanizeAgent
    def get(_)
      Mechanize::Page.new(
        URI('http://foo'),
        nil,
        raw_quotes_page,
        200,
        Mechanize.new
      )
    end

    def raw_quotes_page
      <<-BODY
<div id="kp-notebook-annotations" class="a-row">
  <div id="QUdPVFNVM0E3Vk1PQzpCMDAwWFVBRVRZOjQ1ODIwOkhJR0hMSUdIVA==" class="a-row a-spacing-base">
    <div class="a-column a-span10 kp-notebook-row-separator">
      <div class="a-row">
        <input type="hidden" name="" value="306" id="kp-annotation-location">
        <div class="a-column a-span4 a-text-right a-span-last">
            <div class="a-row a-spacing-top-medium">
              <div class="a-column a-span10 a-spacing-small kp-notebook-print-override">
                <div id="highlight-QUdPVFNVM0E3Vk1PQzpCMDAwWFVBRVRZOjQ1ODIwOkhJR0hMSUdIVA==" class="a-row kp-notebook-highlight kp-notebook-selectable kp-notebook-highlight-yellow">
                  <span id="highlight" class="a-size-base-plus a-color-base">
                    Destiny is not born of decision; it is born of uncontrollable circumstances.
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
    </div>
  </div>
</div>
      BODY
    end
  end
end
