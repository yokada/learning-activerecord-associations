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
    create_table :relationships do |t|
      t.references :follower, index: true
      t.references :followed, index: true
      t.timestamps null: false
      t.index [:follower_id, :followed_id], unique: true
    end
  end

  def self.down
    drop_table :users, :relationships
  end
end
Schema.migrate(:up)


#
# Define models
#

class User < ActiveRecord::Base
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :following_users, through: :following_relationships, source: :followed

  has_many :follower_relationships,  class_name: 'Relationship', foreign_key: 'followed_id'
  has_many :follower_users, through: :follower_relationships, source: :follower
end

class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
end


#
# How to use models
#

=begin

## Follow another user

user = User.create(name: 'name1')
user2 = User.create(name: 'name2')
user.following_relationships.create(follower_id: user2.id)
user.following_relationships.all
# SELECT "relationships".* FROM "relationships" WHERE "relationships"."follower_id" = ?
# [["follower_id", 1]]

user.following_users
# SELECT "users".* FROM "users"
# INNER JOIN "relationships"
# ON "users"."id" = "relationships"."followed_id"
# WHERE "relationships"."follower_id" = ?
# [["follower_id", 1]]

=end

binding.pry
