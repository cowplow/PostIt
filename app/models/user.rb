class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}

  after_validation :generate_slug

  def generate_slug
    self.slug = self.username.downcase

    0.upto(self.slug.size-1) do |char|
      if /[^0-9a-z]/.match(self.slug[char])
        self.slug[char] = '-'
      end
    end

    begin
      if /\-\-/.match(self.slug)
        self.slug.gsub!('--','-') 
      end

    end while /\-\-/.match(self.slug)
  end

  def to_param
    self.slug
  end

end