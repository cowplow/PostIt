module SlugableCtrembley
  extend ActiveSupport::Concern

  #need to add sluggable_column :title, :username, :name in the respective classes

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  module ClassMethods
    def slugable_column(col_name)
      self.slug_column = col_name
    end
  end

  def generate_slug!
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))
    obj = self.class.find_by slug: the_slug
    counter = 1

    while obj && obj != self
      if counter != 1
        arr = the_slug.split('-')
        arr.pop
        the_slug = arr.join('-')
      end
        the_slug += "-#{counter}"
        the_slug = to_slug(the_slug)
        counter += 1
        obj = self.class.find_by slug: the_slug
    end

    self.slug = the_slug
  end

  def to_slug(name)
    str = name.downcase
    
    str.strip

    str.gsub! /\s*[^a-z0-9]\s*/, "-"

    str.gsub! /-+/, "-"

    str
  end

  def to_param
    self.slug
  end

end