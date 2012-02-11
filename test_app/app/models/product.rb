class Product < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :category
  validates_presence_of :name, :code
  validates_length_of :name, :in => 3..10
  validates_length_of :code, :in => 3..10

  accepts_nested_attributes_for :category
end
