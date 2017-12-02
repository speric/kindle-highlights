require 'rubygems'
require 'mechanize'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/filters'

module KindleHighlights
  KINDLE_ROOT = "https://read.amazon.com"
end

require_relative './kindle_highlights/client'
require_relative './kindle_highlights/book'
require_relative './kindle_highlights/highlight'
