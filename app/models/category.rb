class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true

  after_validation :generate_slug

  def generate_slug
    self.slug = self.name.downcase

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