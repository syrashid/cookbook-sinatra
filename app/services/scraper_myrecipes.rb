require 'open-uri'
require 'nokogiri'
require_relative '../recipe'
require 'pry'

class ScrapeMyRecipes
  def self.call(term)
    url = "https://www.myrecipes.com/search?q=#{term}"
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    tits = doc.css('.search-result-title-link-text').map(&:text).map(&:strip)
    desc = doc.css('.search-result-description').map(&:text).map(&:strip)
    tits.first(5).collect.with_index do |title, index|
      Recipe.new(title, desc[index])
    end
  end
end
