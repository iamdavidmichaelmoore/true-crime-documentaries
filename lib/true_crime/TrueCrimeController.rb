require 'nokogiri'
require 'colorize'


class TrueCrime::TrueCrimeController

  attr_accessor :categories

  def call
    puts "Welcome to True Crime Documentary Database!"
    input = nil
    while input != 'exit'
      puts "Enter number '1' to browse documentaries by category or '2' to see all documentaryes."
      puts "Enter 'exit' to quit."
      input = gets.strip
      case input
      when "1" then show_categories_menu
      when "2" then list_all_documentaries
      end
    end
  end

  def list_all_documentaries
    puts "1. MURDERERS AND THEIR MOTHERS - SEASON 1 etc..."
    puts "2. CONFESSIONS OF CRIME } VOLUME 1-3 etc..."
    puts "3. THE SYSTEM: ESCAPE FROM DEATH ROW etc..."
    puts "4. GOING POSTAL (2009)"
    puts "5. THE CHICAGO RIPPERS etc..."
    puts "6. MY SON: THE SERIAL KILLER etc..."

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
    puts "Enter 'return' for main menu, or 'exit' to quit."
    input = nil
    while input != 'exit'
      list_all_categories
      input = gets.strip
      case input
      when "1"
        list_documentaries_by_category("Drugs")
      when "2"
        list_documentaries_by_category("Forensics & Profiling")
      when "3"
        list_documentaries_by_category("Gangs")
      when "4"
        list_documentaries_by_category("Historical")
      when "5"
        list_documentaries_by_category("Kidnap & Hostage")
      when "6"
        list_documentaries_by_category("Miscellaneous")
      when "7"
        list_documentaries_by_category("Murder")
      when "8"
        list_documentaries_by_category("Organized  Crime")
      when "9"
        list_documentaries_by_category("Prison")
      when "10"
        list_documentaries_by_category("Scam & Fraud")
      when "11"
        list_documentaries_by_category("Serial Killer")
      when "12"
        list_documentaries_by_category("Sexual")
      when "13"
        list_documentaries_by_category("Technological")
      when "14"
        list_documentaries_by_category("Theft & Robbery")
      when "15"
        list_documentaries_by_category("War & Terror")
      when "Return".downcase
        call
      end
    end
  end

  def list_documentaries_by_category(category)
    # functions below are fake and temporary just to see the menus work
    puts "#{category.upcase}"
    # just holder titles that don't relate to the category passed in as arg
    puts "1. MURDERERS AND THEIR MOTHERS - SEASON 1 etc..."
    puts "2. CONFESSIONS OF CRIME } VOLUME 1-3 etc..."
    puts "3. THE SYSTEM: ESCAPE FROM DEATH ROW etc..."
    puts "4. GOING POSTAL (2009)"
    puts "5. THE CHICAGO RIPPERS etc..."
    puts "6. MY SON: THE SERIAL KILLER etc..."

  end

  def categories
    @categories = []
  end

end
