# require 'nokogiri'
# require 'colorize'
require 'pry'


class TrueCrime::TrueCrimeController

  attr_accessor :categories

  BASE_PATH = "http:crimedocumentary.com"

  def run
    make_categories
    make_documentaries
    add_attributes_to_docs
    welcome
    call
  end

  def make_categories
      categories = TrueCrimeScraper.scrape_categories(BASE_PATH)
      Category.create_from_category_collection(categories)
  end

  def make_documentaries
    Category.all.each do |category|
      path = text_to_url_path(category.name)
      documentaries = TrueCrimeScraper.scrape_documentaries(BASE_PATH + "#{path}")

  end

  def add_attributes_to_docs

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
    Category.all.each_with_index do |doc, num|
      puts "\n"
      puts "#{num}." + " #{doc.title.upcase}.colorize(:blue)"
      puts "  Year:".colorize(:light_blue) + "#{doc.year}"
      puts "  Category:".colorize(:light_blue) + "#{doc.category.name}"
      puts "\n"
      puts "  Synopsis:".colorize(:light_blue)
      puts "  #{doc.synopsis}"
      puts "  Full synopsis URL:".colorize(:light_blue) + "#{doc.synopsis_url}"
    end
  end

  # def list_all_categories
  #   puts "1. Drugs"
  #   puts "2. Forensics & Profiling"
  #   puts "3. Gangs"
  #   puts "4. Historical"
  #   puts "5. Kidnap & Hostage"
  #   puts "6. Miscellaneous"
  #   puts "7. Murder"
  #   puts "8. Organized Crime"
  #   puts "9. Prison"
  #   puts "10. Scam & Fraud"
  #   puts "11. Serial Killers"
  #   puts "12. Sexual"
  #   puts "13. Technological"
  #   puts "14. Theft & Robbery"
  #   puts "15. War & Terror\n"
  #   puts "\n"
  # end

  def list_all_categories
    puts "True Crime Categories"
    Category.all.sort_by {|doc| doc.title}.each.with_index(1) do |doc, num|
      puts "#{num}. #{doc.name}"
    end
  end

  def show_categories_menu
    input = nil
    unless input == 'exit'
      puts "\n"
      puts "Enter a number for category."
      list_all_categories
      input = gets.strip.downcase
      case input
      when "1" then list_documentaries_by_category("Drugs")
      when "2" then list_documentaries_by_category("Forensics & Profiling")
      when "3" then list_documentaries_by_category("Gangs")
      when "4" then list_documentaries_by_category("Historical")
      when "5" then list_documentaries_by_category("Kidnap & Hostage")
      when "6" then list_documentaries_by_category("Miscellaneous")
      when "7" then list_documentaries_by_category("Murder")
      when "8" then list_documentaries_by_category("Organized  Crime")
      when "9" then list_documentaries_by_category("Prison")
      when "10" then list_documentaries_by_category("Scam & Fraud")
      when "11" then list_documentaries_by_category("Serial Killer")
      when "12" then list_documentaries_by_category("Sexual")
      when "13" then list_documentaries_by_category("Technological")
      when "14" then list_documentaries_by_category("Theft & Robbery")
      when "15" then list_documentaries_by_category("War & Terror")
      end
    else
      show_categories_menu
    end
  end

  def list_documentaries_by_category(category)
    puts "\n"
    # functions below are fake and temporary just to see the menus work
    puts "#{category.upcase}"
    # just holder titles that don't relate to the category passed in as arg
    puts "1. MURDERERS AND THEIR MOTHERS - SEASON 1 etc..."
    puts "2. CONFESSIONS OF CRIME } VOLUME 1-3 etc..."
    puts "3. THE SYSTEM: ESCAPE FROM DEATH ROW etc..."
    puts "4. GOING POSTAL (2009)"
    puts "5. THE CHICAGO RIPPERS etc..."
    puts "6. MY SON: THE SERIAL KILLER etc...\n"
    puts "\n"
    call
  end

  def categories
    @categories = []
  end

  def text_to_url_path(text)
    if text.include?("&")
      new_text = text.gsub(" ", "").gsub("&","-").downcase
      "/category/#{new_text}/"
    else
      new_text = text.gsub(" ", "-").downcase
      "/category/#{new_text}/"
    end
  end

end
