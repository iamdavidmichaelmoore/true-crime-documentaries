require 'colorize'
require 'pry'

class TrueCrime::NewTrueCrimeController

  attr_reader :docs_urls, :documentary_attributes, :input, :display_method_symbol, :method_hash, :previous_method

  INDEX_PAGE_URL = "http://crimedocumentary.com"

  def initialize
    @docs_urls = []
    @documentary_attributes = []
    @method_hash = {}
  end

  def run
    welcome
    call
    goodbye
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
    @input = nil
    while @input != 'quit' do
      puts "\n"
      puts "Enter a number for category. Enter 'Quit' to end the program."
      list_categories
      @input = gets.strip.downcase
      categories = Category.alphabetical
      if @input == (categories.count + 1).to_s
        documentary_titles_menu
      elsif @input.to_i >= 1 && @input.to_i <= categories.count
        list_documentaries_by_title_only_in_category_menu(categories[@input.to_i - 1])
      elsif @input == 'quit'
        break
      else
        invalid_entry!
      end
    end
  end

  def goodbye
    puts "\n"
    puts "Thank you! Good-bye!"
  end

  def invalid_entry!
    puts "***>>>Enter proper selection.<<<***".colorize(:red)
  end

  def documentary_titles_menu
    @previous_method = __method__
    while @input != 'main' do
      list_documentaries
      puts "Enter number for title."
      puts "Enter 'All Detail' to see documentaries in all categories."
      puts "Enter 'Main' for the main menu."
      @input = gets.strip.downcase
      documentary = Documentary.alphabetical
      if @input == 'return' || @input == 'main'
        break
      elsif @input == 'all detail'
        all_documentary_titles_with_details_menu
      elsif @input.to_i >= 1 && @input.to_i <= documentary.count
        display_documentary_info(documentary[@input.to_i - 1], @input.to_i, @previous_method)
      else
        invalid_entry!
      end
    end
  end

  def all_documentary_titles_with_details_menu
    while @input != 'main' do
      all_documentaries_with_details
      puts "Enter 'Return' to return to the titles list or 'Main' for the main menu."
      @input = gets.strip.downcase
      if @input == 'return'  || @input == 'main'
        break
      else
        invalid_entry!
      end
    end
  end

  def list_documentaries_by_title_only_in_category_menu(category)
    @previous_method = __method__
    while @input != 'main' do
      documentaries = category.sort_documentaries
      puts "-----------------------------------------------------------------------------"
      puts "  #{category.name.upcase} | #{documentaries.count} titles(s)"
      puts "-----------------------------------------------------------------------------"
      documentaries.each.with_index(1) do |documentary, num|
        puts "#{num}." + " #{documentary.title}".colorize(:red) + " - (#{documentary.year}) - #{documentary.category.name}"
        puts "----------------------------------------------------------------------------"
      end
      puts "Enter number for title with detail."
      puts "Enter 'All Detail' to see all #{category.name} titles with detail."
      puts "Enter 'Return' to return to the previous menu or 'Main' for the main menu."
      puts "\n"
      @input = gets.strip.downcase
      if @input == 'return' || @input == 'main'
        @previous_method = nil
        break
      elsif @input == 'all detail'
        list_all_documentaries_with_details_in_category_menu(category)
      elsif @input.to_i >= 1 && @input.to_i <= documentaries.count
        display_documentary_info(documentaries[@input.to_i - 1], @input.to_i, @previous_method)
      else
        invalid_entry!
      end
    end
  end

  def list_all_documentaries_with_details_in_category_menu(category)
    while @input != 'main' do
      list_all_documentaries_with_details_in_category(category)
      puts "Enter 'Return' to return to the previous menu."
      puts "Enter 'Main' for the main menu."
      @input = gets.strip.downcase
      if @input == 'return' || @input == 'main'
        break
      else
        invalid_entry!
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
  end

  def display_documentary_info(documentary, selection, previous_method=nil)
    while @input != 'main' do
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
      if count_call == 2 || @previous_method == :list_documentaries_by_title_only_in_category_menu
        puts "Enter 'Return' to return to the previous menu or 'Main' for the main menu."
      else
        puts "Enter 'Category' to see more titles in the #{documentary.category.name} category."
        puts "Enter 'Return' to return to the previous menu or 'Main' for the main menu."
        count_call
      end
      @input = gets.strip.downcase
      if @input == 'return' || @input == 'main'
        @method_hash[@display_method_symbol] = 0
        break
      elsif @input == 'category'
        list_documentaries_by_title_only_in_category_menu(documentary.category)
      else
        invalid_entry!
      end
    end
  end

  def count_call
    if method_hash[display_method_symbol].nil?
      method_hash[display_method_symbol] = 1
    elsif method_hash[display_method_symbol] < 2
      method_hash[display_method_symbol] += 1
    end
    method_hash[display_method_symbol]
  end
end
