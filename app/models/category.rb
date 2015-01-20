class Category < ActiveRecord::Base
  include SlugableCtrembley
  
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true

  slugable_column :name

end