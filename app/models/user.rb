class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}

  after_validation :generate_slug!

  def generate_slug!
    the_slug = to_slug(self.name)
    user = User.find_by slug: the_slug
    counter = 1

    while user && user != self
      if counter != 1
        arr = the_slug.split('-')
        arr.pop
        the_slug = arr.join('-')
      end
        the_slug += "-#{counter}"
        counter += 1
        user = User.find_by slug: the_slug
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

end