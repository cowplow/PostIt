class Post < ActiveRecord::Base
  include Voteable

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  after_validation :generate_slug

  def generate_slug!
    the_slug = to_slug(self.name)
    post = Post.find_by slug: the_slug
    counter = 1

    while post && post != self
      if counter != 1
        arr = the_slug.split('-')
        arr.pop
        the_slug = arr.join('-')
      end
        the_slug += "-#{counter}"
        the_slug = to_slug(the_slug)
        counter += 1
        post = Post.find_by slug: the_slug
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