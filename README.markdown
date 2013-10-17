# join_cache

Faster ActiveRecord associations using Rails cache.

## What?

Let's say you scaffolded your Rails app and ended up with this:

```ruby
class Employee < ActiveRecord::Base
  has_and_belongs_to_many :teams
end
```

Retrieving the teams of one employee generates an inner join:

```ruby
bob.teams
Team Load SELECT "teams".* FROM "teams" INNER JOIN "employees_teams" ON "teams"."id" = "employees_teams"."team_id" WHERE "employees_teams"."employee_id" = ?  [["employee_id", 1]]
```

The gem join_cache generates methods to store the team ids in cache:

```ruby
bob.cached_team_ids
=> [4, 8, 15, 16, 23, 42]

bob.cached_teams
=> Team.where(id: [4, 8, 15, 16, 23, 42])
=> Team Load SELECT "teams".* FROM "teams" WHERE "teams"."id" IN (4, 8, 15, 16, 23, 42)
```

## Usage

In your gemfile:

```ruby
gem 'joined_table'
```

In your model:

```ruby
class Employee < ActiveRecord::Base
  has_and_belongs_to_many :teams
  include JoinCache # make sure to add this *after* listing the associations
end
```

It also works with `has_many :through` associations!

Take a look at this [example app](https://github.com/KevinBongart/join_cache_example).

## TODO

* [Support callbacks: after_add and after_remove](https://github.com/KevinBongart/join_cache/issues/2)
* [Add tests](https://github.com/KevinBongart/join_cache/issues/3)

[View the full list](https://github.com/KevinBongart/join_cache/issues)

## Contributing to join_cache

* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.

## I came here looking for Johnny Cash

Here you go:

![Johnny Cash](http://i.imgur.com/jmt2geX.gif)

## Copyright

Copyright (c) 2013 Kevin Bongart. See LICENSE.txt for
further details.
