module KindleHighlights
  class Client
    # Number of highlights to fetch at once from the Kindle API. Over 250 or so and the endpoint starts 500'ing.
    BATCH_SIZE = 200

    attr_reader :books
        
    def initialize(email_address, password, **mechanize_kwargs)
      @email_address = email_address
      @password      = password
      @books         = Hash.new
      
      setup_mechanize_agent(mechanize_kwargs)
      load_books_from_kindle_account
    end
  
    def highlights_for(asin)
      cursor = 0
      highlights = []

      loop do
        # This endpoint includes a `hasMore` field. Unfortunately at the time of this writing is always false.
        page = @mechanize_agent.get("https://kindle.amazon.com/kcw/highlights?asin=#{asin}&cursor=#{cursor}&count=#{BATCH_SIZE}")
        json = JSON.parse(page.body)
        break unless json['items'] and json['items'].length > 0
        highlights.concat(json['items'])
        cursor += BATCH_SIZE
      end
      highlights
    end
    
    private
   
    def load_books_from_kindle_account
      signin_page = @mechanize_agent.get(KINDLE_LOGIN_PAGE)
      
      signin_form           = signin_page.form(SIGNIN_FORM_IDENTIFIER)
      signin_form.email     = @email_address
      signin_form.password  = @password
      kindle_logged_in_page = @mechanize_agent.submit(signin_form)
      highlights_page       = @mechanize_agent.click(kindle_logged_in_page.link_with(text: /Your Books/))

      loop do
        highlights_page.search(".//td[@class='titleAndAuthor']").each do |book|
          asin_and_title_element = book.search("a").first
          asin                   = asin_and_title_element.attributes["href"].value.split("/").last
          title                  = asin_and_title_element.inner_html
          @books[asin]           = title
        end
        break if highlights_page.link_with(text: /Next/).nil?
        highlights_page = @mechanize_agent.click(highlights_page.link_with(text: /Next/))
      end
    end
    
    def setup_mechanize_agent(mechanize_options)
      @mechanize_agent                        = Mechanize.new
      @mechanize_agent.user_agent_alias       = 'Windows Mozilla'
      @mechanize_agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # Override default settings using mechanize_options
      mechanize_options.each do |mech_attr, value|
        @mechanize_agent.send("#{mech_attr}=", value)
      end
    end
  end
end
