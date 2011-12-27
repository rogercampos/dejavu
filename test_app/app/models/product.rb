class Product < ActiveRecord::Base
  validates_presence_of :name, :code
  validates_length_of :name, :in => 3..10
  validates_length_of :code, :in => 3..10
end
