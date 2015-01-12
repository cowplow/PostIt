class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true

  after_validation :generate_slug!

  def generate_slug!
    the_slug = to_slug(self.name)
    cat = Category.find_by slug: the_slug
    counter = 1

    while cat && cat != self
      if counter != 1
        arr = the_slug.split('-')
        arr.pop
        the_slug = arr.join('-')
      end
        the_slug += "-#{counter}"
        counter += 1
        cat = Category.find_by slug: the_slug
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