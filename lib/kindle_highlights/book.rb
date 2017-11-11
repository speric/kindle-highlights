module KindleHighlights
  class Book
    attr_accessor :asin, :author, :title

    def self.from_html_elements(html_element:, mechanize_agent:)
      new(
        mechanize_agent: mechanize_agent,
        asin: html_element.attributes["id"].value.squish,
        title: html_element.children.search("h2").first.text.squish,
        author: html_element.children.search("p").first.text.split(":").last.strip.squish
      )
    end

    def initialize(asin:, author:, title:, mechanize_agent: nil)
      @asin = asin
      @author = author
      @title = title
      @mechanize_agent = mechanize_agent
    end

    def to_s
      "#{title} by #{author}"
    end

    def inspect
      "<#{self.class}: #{inspectable_vars}>"
    end

    def highlights_from_amazon
      return [] unless mechanize_agent.present?

      @highlights ||= fetch_highlights_from_amazon
    end

    private

    attr_reader :mechanize_agent

    def fetch_highlights_from_amazon
      mechanize_agent
        .get("https://read.amazon.com/kp/notebook?captcha_verified=1&asin=#{asin}&contentLimitState=&")
        .search("div#kp-notebook-annotations")
        .children
        .select { |child| child.name == "div" }
        .select { |child| child.children.search("div.kp-notebook-highlight").first.present? }
        .map    { |html_elements| Highlight.from_html_elements(book: self, html_elements: html_elements) }
    end

    def inspectable_vars
      instance_variables
        .select { |ivar| ivar != :@mechanize_agent }
        .map    { |ivar| "#{ivar}=#{instance_variable_get(ivar).inspect}" }
        .join(", ")
    end
  end
end
