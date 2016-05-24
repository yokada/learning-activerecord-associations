## How to use these ruby scripy.

Installing repository.

```
$ git clone https://github.com/yokada/learning-activerecord-associations.git
$ cd learning-activerecord-associations
```

Start `irb` with `pry`.

```
$ irb has_many_02_relationships.rb
```

You can use some users, and trying following/followed relationships.

```
> u1 = User.create(name: 'name1')
> u2 = User.create(name: 'name2')
> u3 = User.create(name: 'name3')
```

u1 is following u2:

```
> u1.following_relationships.find_or_create_by(followed_id: u2.id)
```

u1 is following u3:

```
> u1.following_relationships.find_or_create_by(followed_id: u3.id)
```

Get follower users of its u2:

```
> u2.follower_users
```


