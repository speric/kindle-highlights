require 'rubygems'
require 'mechanize'
require 'json'
require 'kindle_highlights/client'

module KindleHighlights  
  KINDLE_LOGIN_PAGE      = "http://kindle.amazon.com/login"
  SIGNIN_FORM_IDENTIFIER = "signIn"
  BATCH_SIZE             = 200
end
