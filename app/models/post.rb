class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  after_validation :generate_slug

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug
    self.slug = self.title.downcase

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