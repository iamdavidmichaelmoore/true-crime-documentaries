require 'colorize'
require 'pry'


class TrueCrime::TrueCrimeController

  INDEX_PAGE_PATH = "http://crimedocumentary.com"

  def run
    welcome
    # make_documentaries
    # make_collection
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
    puts "Welcome to True Crime Documentary database!"
    puts "\n"
    puts "One moment... Getting information."
    puts "\n"
    make_categories
  end

  def call
    puts "\n"
    puts "Enter a number for category. Type 'Quit' to end the program."
    puts "\n"
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
      documentary = Documentary.all#.sort_by {|documentary| documentary.title}
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
        display_documentary_info(documentary[input.to_i - 1])
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
      puts "#{num}. #{documentary.title} - (#{documentary.year}) - #{documentary.category.name}"
      puts "---------------------------------------------------------------------------"
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
      puts "#{num}." + " #{documentary.title.upcase}".colorize(:blue)
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

  def display_documentary_info(documentary)
    puts "\n"
    puts "----------------------------------------------------------------------------"
    puts "TITLE CARD"
    puts "----------------------------------------------------------------------------"
    puts "#{documentary.title.upcase}".colorize(:blue)
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
