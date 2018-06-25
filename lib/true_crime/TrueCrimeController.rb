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
    puts "Welcome to the True Crime Documentary Database!"
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
    puts "Enter a number for category. Enter 'Quit' to end the program."
    list_categories
    puts "Enter selection: \n"
    input = gets.strip.downcase
    while input != 'exit' do
      category = Category.alphabetical
      if input =='quit'
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      elsif input == (category.count + 1).to_s
        documentary_titles_menu
      elsif input.to_i >= 1 && input.to_i <= category.count
        list_documentaries_by_title_only_in_category_menu(category[input.to_i - 1])
      elsif !(input.to_i >= 1 && input.to_i <= category.count)
        puts "***>>>Enter proper selection.<<<***".colorize(:red)
        input = gets.strip.downcase
      else
        call
      end
    end
  end

  def documentary_titles_menu(category=nil)
    list_documentaries
    if category.nil?
      puts "Enter number for title."
    else
      puts "Enter number for title or 'Title' to retrn to the #{category.name} menu."
    end
    puts "Enter 'All Detail' to see documentaries in all categories."
    puts "Enter 'Return' for the main menu, or 'Quit' to end the program."
    input = gets.strip.downcase
    while input != 'exit' do
      documentary = Documentary.alphabetical
      if input == 'quit'
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      elsif input == 'return'
        call
      elsif input == 'title'
        if category.nil?
          puts "You have not chosen a category yet.".colorize(:red)
          input = gets.strip.downcase
        else
          list_documentaries_by_title_only_in_category_menu(category)
        end
      elsif input == 'all detail'
        all_documentaries_with_details(category)
      elsif input.to_i >= 1 && input.to_i <= documentary.count
        display_documentary_info(documentary[input.to_i - 1], input.to_i)
      elsif !(input.to_i >= 1 && input.to_i <= documentary.count)
        puts "***>>>Enter proper selection.<<<***".colorize(:red)
        input = gets.strip.downcase
      else
        documentary_titles_menu
      end
    end
  end

  def list_documentaries_by_title_only_in_category_menu(category)
    documentaries = category.documentaries.sort_by {|documentary| documentary.title}
    puts "-----------------------------------------------------------------------------"
    puts "  #{category.name.upcase} | #{documentaries.count} titles(s)"
    puts "-----------------------------------------------------------------------------"
    documentaries.each.with_index(1) do |documentary, num|
      puts "#{num}." + " #{documentary.title}".colorize(:red) + " - (#{documentary.year}) - #{documentary.category.name}"
      puts "----------------------------------------------------------------------------"
    end
    puts "Enter number for title with detail."
    puts "Enter 'All Detail' to see all #{category.name} titles with detail."
    puts "Enter 'Return' for the main menu, or 'Quit' to end the program."
    puts "\n"
    input = gets.strip.downcase
    while input != 'exit' do
      if input == 'quit'
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      elsif input == 'return'
        call
      elsif input == 'all detail'
        list_all_documentaries_with_details_in_category(category)
      elsif input.to_i >= 1 && input.to_i <= documentaries.count
        display_documentary_info(documentaries[input.to_i - 1], input.to_i)
      else
        puts "***>>>Enter proper selection.<<<***".colorize(:red)
        input = gets.strip.downcase
      end
    end
  end

  def return_menu(category=nil)
    if category.nil?
      nil
    else
      puts "Enter 'Title' to go to the #{category.name} menu."
    end
    puts "Enter 'All' to go to documentary titles list."
    puts "Enter 'Return' for the main menu, or 'Quit' to end the program."
    input = gets.strip.downcase
    while input != 'exit' do
      if input == 'quit'
        puts "\n"
        puts "Thank you! Good-bye!"
        puts "\n"
        exit
      elsif input == 'return'
        call
      elsif input == 'all'
        documentary_titles_menu(category)
      elsif input == 'title'
        list_documentaries_by_title_only_in_category_menu(category)
      else
        puts "***>>>Enter proper selection.<<<***".colorize(:red)
        input = gets.strip.downcase
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
      puts "#{num}." + " #{documentary.title}".colorize(:red) + " - (#{documentary.year}) - #{documentary.category.name}"
      puts "-----------------------------------------------------------------------------"
    end
    puts "\n"
  end


  def list_all_documentaries_with_details_in_category(category=nil)
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
    return_menu(category)
  end

  def all_documentaries_with_details(category=nil)
    documentaries = Documentary.alphabetical
    count = " #{documentaries.count} title(s)"
    puts "-----------------------------------------------------------------------------"
    puts "  True Crime Documentaries | #{documentaries.count} title(s)"
    puts "-----------------------------------------------------------------------------"
    documentaries.each.with_index(1) do |documentary, num|
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
    return_menu(category)
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
    return_menu(documentary.category)
  end
end
