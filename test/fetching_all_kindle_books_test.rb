require 'kindle_highlights'
require 'minitest/autorun'

class FetchingAllKindleBooksTest < Minitest::Test
  def setup
    @kindle = KindleHighlights::Client.new(
      email_address: "amazon@example.com",
      password: "letmein"
    )
    @kindle.mechanize_agent = FakeMechanizeAgentForAllBooks.new
  end

  def test_fetching_all_books_from_a_kindle_account
    assert_equal ({ "B003XDUCEU" => "Being Geek: The Software Developer's Career Handbook" }), @kindle.books
  end

  class FakeMechanizeAgentForAllBooks
    def get(login_page)
      FakeAmazonSignInPage.new
    end

    def submit(signin_form)
      html_page <<-BODY
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US">
  <head>
    <title>Amazon Kindle: Home</title>
  </head>
  <body>
    <div id="wholePage">
      <div id="header" class="cleardiv">
        <div class="mainNav">
          <ul>
            <li><a href="/your_reading">Your Books</a></li>
            <li><a href="/refresh">Daily Review</a></li>
            <li><a href="/your_highlights">Your Highlights</a></li>
          </ul>
        </div>
      </div>
    </div>
  </body>
</html>
      BODY
    end

    def click(logged_in_page)
      html_page <<-BODY
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"
  <head>
    <title>Amazon Kindle: Your Books - All (Kindle Only)</title>
  </head>head
  <body>
    <div id="wholePage">
      <div id="tab_content">
        <table id="yourReadingList" cellspacing="0">
          <thead>
            <tr>
              <th class="book" colspan="2">Book</th>
              <th class="status">Reading Status</th>
              <th class="yourRating">Your Rating</th>
              <th class="privacy">Make reading status &amp; rating public</th>
              <th class="privacy">Public Notes: Make yours public</th>
              <th>Remove From List</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="coverImage">
                <img alt="Book" class="bookCover" src="https://images-na.ssl-images-amazon.com/images/I/41fU6t6cPZL._SX50_SY60_.jpg" />
              </td>
              <td class="titleAndAuthor">
                <a href="/work/being-geek-software-developers-handbook-ebook/B00376IHBI/B003XDUCEU">Being Geek: The Software Developer's Career Handbook</a><br />
                <span class="author">Michael Lopp</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="yourReadingNav">
        <div class="yourReadingPaginationWrapper">
          <div class="yourReadingPagination">
            <div class="yourReadingNavComponent">
              <div class="paginationLinks bottomPagination">
                <span class="disabled"> &lt; Previous</span> | <span class="currentPage">Page: </span> <span class="currentPage">1</span> | <span class="disabled">Next &gt;</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
      BODY
    end

    def html_page(raw_html)
      Mechanize::Page.new(URI('http://foo'), nil, raw_html, 200, Mechanize.new)
    end

    class FakeAmazonSignInPage
      def form(form_id)
        FakeAmazonSignInForm.new
      end

      class FakeAmazonSignInForm
        attr_writer :email, :password
      end
    end
  end
end
