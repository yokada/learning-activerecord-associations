# This is a ruby script to aim learning ActiveRecord Associations via Pry debugging as playground.
# http://guides.rubyonrails.org/association_basics.html
# http://guides.rubyonrails.org/v3.2/active_record_querying.html

require 'active_record'
require 'pry'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

#
# Create tables
#
class Schema < ActiveRecord::Migration
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
Schema.migrate(:up)


#
# Define models
#

class Post < ActiveRecord::Base
  belongs_to :user # singular form
end

class User < ActiveRecord::Base
  has_many :posts  # prural form
end

#
# How to use models
#

=begin

## Create posts via a user

user = User.create(name: 'name1')
user.posts.create(title: 'title1', body: 'body1')
user.posts.create(title: 'title2', body: 'body2')
user.posts.create(title: 'title3', body: 'body3')
user.posts.create(title: 'title4', body: 'body4')

## Retrieve posts via a user using Query Interface

user.posts
user.posts.find(1)
user.posts.find_by(title: 'title1')
user.posts.where(id: [1,2,3])
user.posts.where('title LIKE ?', '%1')
user.posts.count

## Create a user via a post

post = Post.create(title:'title1', body:'body1')
post.user = User.create(name:'n1')
post.user = User.create(name:'n2')
post.user = User.find(1)

=end


binding.pry
