require_relative "../true_crime"


class Category
  attr_accessor :name
  attr_reader :documentaries

  @@all = []

  def initialize
    @documentaries = []
  end

  def self.all
    @@all
  end

  def self.destroy_all
    self.all.clear
  end

  def save
    self.class.all << self
  end

  def self.create
    category = Category.new
    category.save
    category
  end

  def self.create_by_name(category_name)
    category = self.create
    category.name = category_name
    category
  end

  def self.find_by_name(category_name)
    self.all.detect {|category| category.name == category_name}
  end

  def self.find_or_create_by_name(category_name)
    self.find_by_name(category_name) || self.create_by_name(category_name)
  end

  def self.alphabetical
    self.all.sort_by {|category| category.name}
  end

  def sort_documentaries
    self.documentaries.sort_by {|documentary| documentary.title}
  end

  def docs_count
    self.documentaries.count
  end
end
