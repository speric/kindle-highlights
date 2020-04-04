module KindleHighlights
  class Client
    class CaptchaError < StandardError; end
    class AuthenticationError < StandardError; end
    class AsinNotFoundError < StandardError; end

    SIGNIN_FORM_IDENTIFIER = "signIn"
    MAX_AUTH_RETRIES       = 2

    attr_writer :mechanize_agent, :kindle_logged_in_page
    attr_reader :root_url, :kindle_login_page

    def initialize(email_address:, password:, root_url: "https://read.amazon.com", mechanize_options: {})
      @email_address = email_address
      @password = password
      @mechanize_options = mechanize_options
      @retries = 0
      @kindle_logged_in_page = nil
      @root_url = root_url
      @kindle_login_page = "#{@root_url}/notebook"
    end

    def books
      @books ||= load_books_from_kindle_account
    end

    def highlights_for(asin)
      if book = books.detect { |book| book.asin == asin }
        book.highlights_from_amazon
      else
        raise AsinNotFoundError, "Book with ASIN #{asin} not found."
      end
    end

    private

    attr_accessor :email_address, :password, :mechanize_options
    attr_reader :kindle_logged_in_page

    def mechanize_agent
      @mechanize_agent ||= initialize_mechanize_agent
    end

    def initialize_mechanize_agent
      mechanize_agent = Mechanize.new
      mechanize_agent.user_agent_alias = Mechanize::AGENT_ALIASES.keys.grep(/\A(Linux|Mac|Windows)/).sample
      mechanize_agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      mechanize_options.each do |mech_attr, value|
        mechanize_agent.send("#{mech_attr}=", value)
      end
      mechanize_agent
    end

    def load_books_from_kindle_account
      conditionally_sign_in_to_amazon

      kindle_library.map do |book|
        unless book.attributes["id"].blank?
          Book.from_html_elements(html_element: book, mechanize_agent: mechanize_agent, root_url: root_url)
        end
      end.compact
    end

    def conditionally_sign_in_to_amazon
      if login?
        post_signin_page = login_via_mechanize

        if post_signin_page.search("#auth-captcha-image").any?
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
      retry unless too_many_retries?
    end

    def kindle_library
      @kindle_library ||= @kindle_logged_in_page.search("div#kp-notebook-library").children
    end

    def login_via_mechanize
      signin_page = mechanize_agent.get(@kindle_login_page)
      signin_form = signin_page.form(SIGNIN_FORM_IDENTIFIER)
      signin_form.email = email_address
      signin_form.password = password
      mechanize_agent.submit(signin_form)
    end

    def login?
      @kindle_logged_in_page.blank?
    end

    def too_many_retries?
      retry! == MAX_AUTH_RETRIES
    end

    def retry!
      retries += 1
    end
  end
end
