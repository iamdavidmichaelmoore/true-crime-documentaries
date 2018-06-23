require 'colorize'
require 'pry'


class TrueCrime::TrueCrimeController

  attr_reader :docs_urls, :documentary_attributes

  INDEX_PAGE_PATH = "http://crimedocumentary.com"

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
    puts "Welcome to True Crime Documentary database!"
    puts "\n"
    puts "One moment... Getting information."
    puts "\n"
    make_categories
  end

  def call
    puts "\n"
    puts "Enter a number for category. Type 'Quit' to end the program."
    puts "You may need to scroll up to see your options/results."
    list_categories
    puts "Enter selection: \n"
    input = gets.strip.downcase
    while input != 'exit' do
      category = Category.all
      documentary = Documentary.all
      case
      when input =='quit'.downcase
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      when input == (category.count + 1).to_s && documentary.empty?
        puts "Getting more information. This will take a few seconds..."
        make_documentaries
        make_collection
        documentary_titles_menu
        break
      when input == (category.count + 1).to_s && !documentary.empty?
        make_collection
        documentary_titles_menu
        break
      when category.include?(category[input.to_i - 1]) && documentary.empty?
        puts "Getting more information. This will take a few seconds..."
        make_documentaries
        make_collection
        list_documentaries_in_category(category[input.to_i - 1])
        break
      when category.include?(category[input.to_i - 1]) && !documentary.empty?
        make_collection
        list_documentaries_in_category(category[input.to_i - 1])
        break
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
      documentary = Documentary.all.sort_by {|documentary| documentary.title}
      # binding.pry
      case
      when input == 'quit'.downcase
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      when input == 'return'.downcase
        call
        break
      when documentary.include?(documentary[input.to_i - 1])
        display_documentary_info(documentary[input.to_i - 1], input.to_i)
        break
      else
        documentary_titles_menu
      end
    end
  end

  def list_categories
    sorted_list = Category.all.sort_by {|category| category.name}
    puts "--------------------------"
    puts "  True Crime Categories"
    puts "--------------------------"
    sorted_list.each.with_index(1) {|category, num| puts "#{num}. #{category.name}"}
    puts "-------------------------"
    puts "#{sorted_list.count + 1}. Browse By Title"
    puts "\n"
  end

  def list_documentaries
    documentaries = Documentary.all.sort_by {|documentary| documentary.title}
    puts "-----------------------------------------------------------------------------"
    puts "  True Crime Documentaries | #{documentaries.count} title(s)"
    puts "-----------------------------------------------------------------------------"
    documentaries.each.with_index(1) do |documentary, num|
      puts "#{num}." + " #{documentary.title}".colorize(:red) + " - (#{documentary.year})" + " - #{documentary.category.name}".colorize(:green)
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
      puts "Year:".colorize(:light_blue) + " #{documentary.year}".colorize(:light_green)
      puts "Category:".colorize(:light_blue) + " #{documentary.category.name}".colorize(:light_green)
      puts "Synopsis:".colorize(:light_blue) + " #{documentary.synopsis}"
      puts "\n"
      puts "Follow the link for full synopsis.".colorize(:light_green)
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
    puts "Year:".colorize(:light_blue) + " #{documentary.year}".colorize(:light_green)
    puts "Category:".colorize(:light_blue) + " #{documentary.category.name}".colorize(:light_green)
    puts "Synopsis:".colorize(:light_blue) + " #{documentary.synopsis}"
    puts "\n"
    puts "Follow the link for full synopsis.".colorize(:light_green)
    puts "Full synopsis URL:".colorize(:light_blue) + " #{documentary.synopsis_url}"
    puts "----------------------------------------------------------------------------"
    puts "\n"
    call
  end
end
