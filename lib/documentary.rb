require_relative "./true_crime"


class Documentary

  attr_accessor :title, :year, :category, :synopsis, :synopsis_url

  @@all = []

  def initialize(hash)
    hash.each do |key, value|
      self.send("#{key}=", value)
    end
    self.class.all << self
  end

  def self.all
    @@all
  end

  def self.destroy_all
    self.all.clear
  end

  def self.create_documentary_from_collection(array)
    array.each do |doc_attributes|
      documentary = self.new(doc_attributes)
    end
  end

  def self.sort_documentaries_by_category
    Category.all.each do |category_obj|
      self.all.each do |documentary|
        if documentary.category == category_obj.name
          documentary.category = category_obj
          unless category_obj.documentaries.include?(documentary)
            category_obj.documentaries << documentary
          end
        end
      end
    end
  end
end
