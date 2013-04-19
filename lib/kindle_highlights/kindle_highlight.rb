class KindleHighlight
  
  attr_accessor :highlights
	
  def initialize(email_address, password)
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Windows Mozilla'
    @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    page = @agent.get("https://www.amazon.com/ap/signin?openid.assoc_handle=amzn_kindle&openid.mode=checkid_setup&pageId=amzn_kindle&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.return_to=https%3A%2F%2Fkindle.amazon.com%3A443%2Fauthenticate%2Flogin_callback%3Fwctx%3D%252F&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.pape.max_auth_age=0&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0")
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