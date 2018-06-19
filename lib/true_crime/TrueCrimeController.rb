# require 'nokogiri'
# require 'colorize'
require 'pry'


class TrueCrime::TrueCrimeController

  INDEX_PAGE_PATH = "http://crimedocumentary.com"

  def run
    make_categories
    make_documentaries
    welcome
    call
  end

  def make_categories
      categories = TrueCrimeScraper.scrape_categories(INDEX_PAGE_PATH)
      Category.create_from_collection(categories)
      binding.pry
  end

  def make_documentaries
    Category.all.each do |cat|
      docs = TrueCrimeScraper.scrape_documentaries(cat.url)
      Documentary.create_from_collection(docs, cat)
    end
  end

  def welcome
    puts "Welcome to True Crime Documentary Database!"
    puts "\n"
  end

  def call
    input = nil
    unless  input == 'exit'
      puts "Enter number '1' to see all documentaries."
      puts "Enter number '2' to browse documentaries by category"
      puts "Enter 'exit' to quit the program.\n"
      puts "\n"
      input = gets.strip
      case input
      when "1" then list_all_documentaries
      when "2" then show_categories_menu
      end
    else
      call
    end
  end

  def list_all_documentaries
    Category.all.each_with_index do |documentary, num|
      puts "\n"
      puts "Total number of documentary titles: #{Documentary.total_docs_count}"
      puts "#{num}." + " #{documentary.title.upcase}.colorize(:blue)"
      puts "  Year:".colorize(:light_blue) + "#{documentary.year}"
      puts "  Category:".colorize(:light_blue) + "#{documentary.category.name}"
      puts "\n"
      puts "  Synopsis:".colorize(:light_blue)
      puts "  #{documentary.synopsis}"
      puts "  Full synopsis URL:".colorize(:light_blue) + "#{documentary.synopsis_url}"
      puts "\n"
    end
  end

  def list_categories
    sorted_list = Category.all.sort_by {|category| category.name}
    sorted_list.each.with_index {|category, num| puts "#{num}. #{category.name}"}
  end

  def list_categories_menu
    input = nil
    unless input == 'exit'
      puts "\n"
      puts "Enter a number for category."
      list_categories
      sorted_list = Category.all.sort_by {|category| category.name}
      sorted_list.each.with_index(1) do |category, num|
        input = gets.strip
        if input.to_i == num
          list_documentaries_in_category(category)
        end
      end
    else
      list_categories_menu
    end
  end

  def list_documentaries_in_category(category)
    puts "\n"
    category.documentaries.each do |documentary|
      puts "\n"
      puts "#{category.name.upcase} has #{category.docs_count} titles."
      puts "\n"
      puts "#{num}." + " #{documentary.title.upcase}.colorize(:blue)"
      puts "  Year:".colorize(:light_blue) + "#{documentary.year}"
      puts "  Category:".colorize(:light_blue) + "#{documentary.category.name}"
      puts "\n"
      puts "  Synopsis:".colorize(:light_blue)
      puts "  #{documentary.synopsis}"
      puts "  Full synopsis URL:".colorize(:light_blue) + "#{documentary.synopsis_url}"
      call
    end
  end
end
