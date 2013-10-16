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

## Contributing to join_cache

* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.

## Copyright

Copyright (c) 2013 Kevin Bongart. See LICENSE.txt for
further details.

