require 'nokogiri'
require 'colorize'


class TrueCrime::TrueCrimeController

  attr_accessor :categories

  def call
    puts "Welcome to True Crime Documentary Database!"
    input = nil

    show_categories_menu
  end

  def list_all_documentaries

  end

  def list_all_categories
    puts "1. Drugs"
    puts "2. Forensics & Profiling"
    puts "3. Gangs"
    puts "4. Historical"
    puts "5. Kidnap & Hostage"
    puts "6. Miscellaneous"
    puts "7. Murder"
    puts "8. Organized Crime"
    puts "9. Prison"
    puts "10. Scam & Fraud"
    puts "11. Serial Killers"
    puts "12. Sexual"
    puts "13. Technological"
    puts "14. Theft & Robbery"
    puts "15. War & Terror"
  end

  def show_categories_menu
    puts "Enter number for category."
    puts "Enter 'return' for main menue, or 'exit' to quit."
    list_all_categories
  end

  def list_all_documentaries_by_category(category)

  end

  def categories
    @categories = []
  end

end
