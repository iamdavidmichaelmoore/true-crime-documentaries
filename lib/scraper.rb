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

  # def self.scrape_categories(controller_base_path)
  #   categories_with_urls = []
  #   index_page = Nokogiri::HTML(open(controller_base_path))
  #
  #   hash_1 = {}
  #   category_1 = 0
  #   hash_1[:name] = index_page.css("div.g1-column-inner #text-5 ul li")[category_1].text
  #   hash_1[:url] = index_page.css("div.g1-column-inner #text-5 ul li a")[category_1]["href"]
  #
  #   hash_2 = {}
  #   category_2 = 1
  #   hash_2[:name] = index_page.css("div.g1-column-inner #text-5 ul li")[category_2].text
  #   hash_2[:url] = index_page.css("div.g1-column-inner #text-5 ul li a")[category_2]["href"]
  #
  #   categories_with_urls << hash_1
  #   categories_with_urls << hash_2
  #   categories_with_urls
  # end



  def self.scrape_documentaries(category_url)
    documentaries_with_attributes = []
    category_page = Nokogiri::HTML(open(category_url))
    # binding.pry
    category_page.css("figure.entry-featured-media").each_with_index do |documentary, num|
      hash = {}
      hash[:title] = category_page.css("h3.g1-delta.entry-title a")[num].text
      hash[:year] = category_page.css("h3.g1-delta.entry-title a")[num].text
      hash[:year] = hash[:year].split(" ").last.gsub(/[()]/,"")
      hash[:category] = category_page.css("div.entry-body.g1-current-background ul a")[num].text
      hash[:synopsis] = category_page.css("div.entry-body.g1-current-background div.entry-summary.g1-text-narrow p")[num].text
      hash[:synopsis_url] = category_page.css("figure.entry-featured-media a")[num]["href"]
      documentaries_with_attributes << hash
    end
    documentaries_with_attributes
  end

  # def self.scrape_documentaries(category_url)
  #   # binding.pry
  #   documentaries_with_attributes = []
  #   category_page = Nokogiri::HTML(open(category_url))
  #   hash_1 = {}
  #   doc_1 = 0
  #   hash_1[:title] = category_page.css("h3.g1-delta.entry-title a")[doc_1].text
  #   hash_1[:year] = category_page.css("h3.g1-delta.entry-title a")[doc_1].text
  #   hash_1[:year] = hash_1[:year].split(" ").last.gsub(/[()]/,"")
  #   hash_1[:category] = category_page.css("div.entry-body.g1-current-background ul a")[doc_1].text
  #   hash_1[:synopsis] = category_page.css("div.entry-body.g1-current-background div.entry-summary.g1-text-narrow p")[doc_1].text
  #   hash_1[:synopsis_url] = category_page.css("figure.entry-featured-media a")[doc_1]["href"]
  #
  #   hash_2 = {}
  #   doc_2 = 1
  #   hash_2[:title] = category_page.css("h3.g1-delta.entry-title a")[doc_2].text
  #   hash_2[:year] = category_page.css("h3.g1-delta.entry-title a")[doc_2].text
  #   hash_2[:year] = hash_2[:year].split(" ").last.gsub(/[()]/,"")
  #   hash_2[:category] = category_page.css("div.entry-body.g1-current-background ul a")[doc_2].text
  #   hash_2[:synopsis] = category_page.css("div.entry-body.g1-current-background div.entry-summary.g1-text-narrow p")[doc_2].text
  #   hash_2[:synopsis_url] = category_page.css("figure.entry-featured-media a")[doc_2]["href"]
  #
  #   documentaries_with_attributes << hash_1
  #   documentaries_with_attributes << hash_2
  #   documentaries_with_attributes
  # end
end
