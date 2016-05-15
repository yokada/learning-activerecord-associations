# This is a playground script for Single Table Inheritance (STI).

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
    create_table :users do |t|
      t.string :name
    end
    create_table :friendships do |t|
      t.references :following_user, index: true
      t.references :followed_user, index: true
      t.timestamps null: false
      t.index [:following_user_id, :followed_user_id], unique: true
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

class User < ActiveRecord::Base
  has_many :following_users, class_name: 'Friendship', foreign_key: 'following_user_id'
  has_many :followed_users,  class_name: 'Friendship', foreign_key: 'followed_user_id'
end

class Friendship < ActiveRecord::Base
  belongs_to :following_user, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'
end


#
# How to use models
#

=begin

## Follow another user

user.following_users.create(followed_user_id: 2)
#<Friendship:0x007fa329950140
 id: 1,
 following_user_id: 1,
 followed_user_id: 2,
 created_at: 2016-05-15 19:41:45 UTC,
 updated_at: 2016-05-15 19:41:45 UTC>


=end

binding.pry
