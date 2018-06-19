require_relative "./true_crime"
# require 'open_uri'
# require 'pry'


class TrueCrimeScraper

  def self.scrape_categories(controller_base_path)
    categories_with_urls = []
    index_page = Nokogiri::HTML(open(controller_base_path))
    index_page.css()each.with_index(1) do |category, num|
      hash = {}
      hash[:category] = category.css().text
      hash[:url] = index_page.css()[num]["href"]
      categories_with_urls << hash
    end
    categories_with_urls
  end

  end

  # then I can call the Category class in order interpolate the names
  # as a concatenation with the BASE_PATH in order get the all of the docs
  def self.scrape_documentaries(base_path_with_doc_url)

  end

end
