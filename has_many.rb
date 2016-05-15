# http://guides.rubyonrails.org/association_basics.html

require 'active_record'
require 'pry'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.references :user # singular form
      t.string :title
      t.string :body
    end

    create_table :users do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :posts
  end
end

InitialSchema.migrate(:up)

class Post < ActiveRecord::Base
  belongs_to :user # singular form
end

class User < ActiveRecord::Base
  has_many :posts  # prural form
end

binding.pry
