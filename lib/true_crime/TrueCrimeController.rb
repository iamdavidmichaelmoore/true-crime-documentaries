require 'colorize'
require 'pry'


class TrueCrime::TrueCrimeController
  attr_accessor :raw_doc_data_hash

  INDEX_PAGE_PATH = "http://crimedocumentary.com"

  def run
    welcome
    make_categories
    make_documentaries
    make_collection
    call
  end

  def make_categories
      categories = TrueCrimeScraper.scrape_categories(INDEX_PAGE_PATH)
      Category.create_category_from_collection(categories)
  end

  def make_documentaries
    Category.all.each do |category|
      documentaries = TrueCrimeScraper.scrape_documentaries(category.url)
      Documentary.create_documentary_from_collection(documentaries)
    end
  end

  def make_collection
    Documentary.sort_documentaries_by_category
  end

  def welcome
    puts" _____                   ____      _  "
    puts"|_   _| __ _   _  ___   / ___|_ __(_)_ __ ___   ___ "
    puts"  | || '__| | | |/ _ \/ | |   | '__| | '_ ` _ \/ / _ \/"
    puts"  | || |  | |_| |  __/ | |___| |  | | | | | | |  __/"
    puts"  |_||_|   \/__,_|\/___|  \/____|_|  |_|_| |_| |_|\/___|"
    puts "\n"
    puts "Welcome to True Crime Documentary Database!"
    puts "\n"
    puts "One moment. Loading information..."
    puts "\n"
  end

  def call
    puts "\n"
    puts "Enter a number for category. Type 'Quit' to end the program."
    puts "\n"
    list_categories
    input = gets.strip.downcase
    while input != 'exit' do
      category = Category.all
      case
      when input =='quit'.downcase
        puts "\n"
        puts "Thank you for using True Crime! Good-bye!"
        puts "\n"
        exit
      when category.include?(category[input.to_i - 1])
        list_documentaries_in_category(category[input.to_i - 1])
        break
      else
        call
      end
    end
  end

  def list_categories
    sorted_list = Category.all.sort_by {|category| category.name}
    sorted_list.each.with_index(1) {|category, num| puts "#{num}. #{category.name}"}
    puts "\n"
  end

  def list_documentaries_in_category(category)
    puts "\n"
    puts "-----------------------------------------------------------------------------"
    puts "#{category.name.upcase} | #{category.docs_count} title(s)"
    puts "-----------------------------------------------------------------------------"
    category.documentaries.each.with_index(1) do |documentary, num|
      puts "\n"
      puts "#{num}." + " #{documentary.title.upcase}".colorize(:blue)
      puts "Year:".colorize(:light_blue) + " #{documentary.year}".colorize(:light_green)
      puts "Category:".colorize(:light_blue) + " #{documentary.category.name}".colorize(:light_green)
      puts "Synopsis:".colorize(:light_blue) + " #{documentary.synopsis}"
      puts "\n"
      puts "Follow the link for full synopsis.".colorize(:light_green)
      puts "Full synopsis URL:".colorize(:light_blue) + " #{documentary.synopsis_url}"
      puts "-----------------------------------------------------------------------------"
    end
    call
  end
end
