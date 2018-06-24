require 'colorize'
require 'pry'

class TrueCrime::TrueCrimeController

  attr_reader :docs_urls, :documentary_attributes

  INDEX_PAGE_URL = "http://crimedocumentary.com"

  def initialize
    @docs_urls = []
    @documentary_attributes = []
  end

  def run
    welcome
    call
  end

  def get_urls
    urls = TrueCrimeScraper.scrape_urls(INDEX_PAGE_URL)
    urls.each {|url| docs_urls << url}
  end

  def get_documentary_attributes
    docs = []
    docs_urls.each do |path|
      docs =  TrueCrimeScraper.scrape_documentary_attributes(path)
      docs.each {|attributes| documentary_attributes << attributes}
    end
  end

  def add_documentary_attributes
    Documentary.create_documentary_from_collection(documentary_attributes)
  end

  def welcome
    puts" _____                   ____      _  "
    puts"|_   _| __ _   _  ___   / ___|_ __(_)_ __ ___   ___ "
    puts"  | || '__| | | |/ _ \/ | |   | '__| | '_ ` _ \/ / _ \/"
    puts"  | || |  | |_| |  __/ | |___| |  | | | | | | |  __/"
    puts"  |_||_|   \/__,_|\/___|  \/____|_|  |_|_| |_| |_|\/___|"
    puts "\n"
    puts "Welcome to the  True Crime Documentary Database!"
    puts "\n"
    puts "One moment... Gathering collection."
    puts "\n"
    get_urls
    puts "Building collection."
    get_documentary_attributes
    add_documentary_attributes
  end

  def call
    puts "\n"
    puts "Enter a number for category. Type 'Quit' to end the program."
    list_categories
    puts "Enter selection: \n"
    input = gets.strip.downcase
    while input != 'exit' do
      category = Category.all
      if input =='quit'
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      elsif input == (category.count + 1).to_s
        documentary_titles_menu
      elsif input.to_i >= 1 && input.to_i < category.count
        list_documentaries_in_category(category[input.to_i - 1])
      elsif !(input.to_i >= 1 && input.to_i < category.count)
        puts "***>>>Enter proper selection.<<<***".colorize(:red)
        input = gets.strip.downcase
      else
        call
      end
    end
  end

  def documentary_titles_menu
    list_documentaries
    puts "Enter number for title. Type 'Return' for categories menu or 'Quit'.\n"
    input = gets.strip
    while input != 'exit' do
      documentary = Documentary.alphabetical
      if input == 'quit'.downcase
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      elsif input == 'return'.downcase
        call
      elsif input.to_i >= 1 && input.to_i < documentary.count
        display_documentary_info(documentary[input.to_i - 1], input.to_i)
      elsif !(input.to_i >= 1 && input.to_i < documentary.count)
        puts "***>>>Enter proper selection.<<<***".colorize(:red)
        input = gets.strip.downcase
      else
        documentary_titles_menu
      end
    end
  end

  def list_categories
    categories = Category.alphabetical
    puts "--------------------------"
    puts "  True Crime Categories"
    puts "--------------------------"
    categories.each.with_index(1) do |category, num|
      puts "#{num}. #{category.name} (#{category.docs_count})"
    end
    puts "-------------------------"
    puts "#{categories.count + 1}. Browse By Title (#{Documentary.docs_count})"
    puts "\n"
  end

  def list_documentaries
    documentaries = Documentary.alphabetical
    puts "-----------------------------------------------------------------------------"
    puts "  True Crime Documentaries | #{documentaries.count} title(s)"
    puts "-----------------------------------------------------------------------------"
    documentaries.each.with_index(1) do |documentary, num|
      puts "#{num}." + " #{documentary.title}".colorize(:red) + "- (#{documentary.year}) - #{documentary.category.name}"
      puts "-----------------------------------------------------------------------------"
    end
    puts "\n"
  end

  def list_documentaries_in_category(category)
    count = "#{category.name.upcase} | #{category.docs_count} title(s)"
    puts "\n"
    puts "-----------------------------------------------------------------------------"
    puts "#{count}"
    puts "-----------------------------------------------------------------------------"
    category.documentaries.each.with_index(1) do |documentary, num|
      puts "\n"
      puts "#{num}." + " #{documentary.title.upcase}".colorize(:red)
      puts "Year:".colorize(:light_blue) + " #{documentary.year}"
      puts "Category:".colorize(:light_blue) + " #{documentary.category.name}"
      puts "Synopsis:".colorize(:light_blue) + " #{documentary.synopsis}"
      puts "\n"
      puts "Follow the link for full synopsis.".colorize(:light_blue)
      puts "Full synopsis URL:".colorize(:light_blue) + " #{documentary.synopsis_url}"
      puts "----------------------------------------------------------------------------"
    end
    puts "#{count}" + "     |     END OF LIST"
    puts "------------------------------------------------------------------------------"
    call
  end

  def display_documentary_info(documentary, selection)
    puts "\n"
    puts "----------------------------------------------------------------------------"
    puts "TITLE CARD: #{selection}"
    puts "----------------------------------------------------------------------------"
    puts "#{documentary.title.upcase}".colorize(:red)
    puts "Year:".colorize(:light_blue) + " #{documentary.year}"
    puts "Category:".colorize(:light_blue) + " #{documentary.category.name}"
    puts "Synopsis:".colorize(:light_blue) + " #{documentary.synopsis}"
    puts "\n"
    puts "Follow the link for full synopsis.".colorize(:light_blue)
    puts "Full synopsis URL:".colorize(:light_blue) + " #{documentary.synopsis_url}"
    puts "----------------------------------------------------------------------------"
    puts "\n"
    call
  end
end
