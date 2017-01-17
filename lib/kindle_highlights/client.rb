module KindleHighlights
  class Client
    class CaptchaError < StandardError; end
    class AuthenticationError < StandardError; end

    MAX_AUTH_RETRIES = 2

    attr_writer :mechanize_agent
    attr_accessor :kindle_logged_in_page

    def initialize(email_address:, password:, mechanize_options: {})
      @email_address     = email_address
      @password          = password
      @mechanize_options = mechanize_options
    end

    def books
      @books ||= load_books_from_kindle_account
    end

    def highlights_for(asin)
      conditionally_sign_in_to_amazon

      cursor     = 0
      highlights = []

      loop do
        # This endpoint includes a `hasMore` field. Unfortunately at the time of this writing is always `false`.
        page  = mechanize_agent.get("https://kindle.amazon.com/kcw/highlights?asin=#{asin}&cursor=#{cursor}&count=#{BATCH_SIZE}")
        items = JSON.parse(page.body).fetch("items", [])

        break unless items.any?

        highlights.concat(items)
        cursor += BATCH_SIZE
      end
      highlights
    end

    private

    attr_accessor :email_address, :password, :mechanize_options

    def conditionally_sign_in_to_amazon
      retries ||= 0

      if @kindle_logged_in_page.nil?
        signin_page            = mechanize_agent.get(KINDLE_LOGIN_PAGE)
        signin_form            = signin_page.form(SIGNIN_FORM_IDENTIFIER)
        signin_form.email      = email_address
        signin_form.password   = password
        post_signin_page       = mechanize_agent.submit(signin_form)

        if post_signin_page.search("#ap_captcha_img").any?
          resolution_url = post_signin_page.link_with(text: /See a new challenge/).resolved_uri.to_s
          raise CaptchaError, "Received a CAPTCHA while attempting to sign in to your Amazon account. You will need to resolve this manually at #{resolution_url}"
        elsif post_signin_page.search("#message_error > p").any?
          amazon_error = post_signin_page.search("#message_error > p").children.first.to_s.strip
          raise AuthenticationError, "Unable to sign in, received error: '#{amazon_error}'"
        else
          @kindle_logged_in_page = post_signin_page
        end
      end
    rescue AuthenticationError
      retry unless (retries += 1) == MAX_AUTH_RETRIES
    end

    def load_books_from_kindle_account
      conditionally_sign_in_to_amazon

      books           = {}
      highlights_page = mechanize_agent.click(kindle_logged_in_page.link_with(text: /Your Books/))

      loop do
        highlights_page.search(".//td[@class='titleAndAuthor']").each do |book|
          asin_and_title_element = book.search("a").first
          asin                   = asin_and_title_element.attributes.fetch("href").value.split("/").last
          title                  = asin_and_title_element.inner_html
          books[asin]            = title
        end

        break if highlights_page.link_with(text: /Next/).nil?
        highlights_page = mechanize_agent.click(highlights_page.link_with(text: /Next/))
      end
      books
    end

    def mechanize_agent
      @mechanize_agent ||= initialize_mechanize_agent
    end

    def initialize_mechanize_agent
      mechanize_agent                        = Mechanize.new
      mechanize_agent.user_agent_alias       = Mechanize::AGENT_ALIASES.keys.grep(/\A(Linux|Mac|Windows)/).sample
      mechanize_agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      mechanize_options.each do |mech_attr, value|
        mechanize_agent.send("#{mech_attr}=", value)
      end
      mechanize_agent
    end
  end
end
