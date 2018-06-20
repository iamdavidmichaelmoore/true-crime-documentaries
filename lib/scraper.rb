require_relative "./true_crime"
require 'open-uri'
require 'pry'


class TrueCrimeScraper
  def self.scrape_categories(controller_base_path)
    categories_with_urls = []
    index_page = Nokogiri::HTML(open(controller_base_path))
    index_page.css("div.g1-column-inner #text-5 ul li").each_with_index do |category, num|
      hash = {}
      hash[:name] = category.text
      hash[:url] = index_page.css("div.g1-column-inner #text-5 ul li a")[num]["href"]
      categories_with_urls << hash
    end
    categories_with_urls
  end

  def self.scrape_documentaries(category_url)
    documentaries_with_attributes = []
    category_page = Nokogiri::HTML(open(category_url))
    category_page.css("figure.entry-featured-media").each_with_index do |documentary, num|
      hash = {}
      hash[:title] = category_page.css("h3.g1-delta.entry-title a")[num].text.gsub(/^?[( ]\d{4}[) ]/, " ").strip
      hash[:year] = category_page.css("h3.g1-delta.entry-title a")[num].text.scan(/^?\d{4}/).last
      hash[:category] = category_page.css("h1.g1-beta.g1-beta-2nd.archive-title").text
      hash[:synopsis] = category_page.css("div.entry-body.g1-current-background div.entry-summary.g1-text-narrow p")[num].text
      hash[:synopsis_url] = category_page.css("figure.entry-featured-media a")[num]["href"]
      documentaries_with_attributes << hash
    end
    documentaries_with_attributes
  end
end
