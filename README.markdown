# join_cache

Faster ActiveRecord associations using Rails cache.

[![Gem Version](https://badge.fury.io/rb/join_cache.png)](http://badge.fury.io/rb/join_cache)
[![Build Status](https://travis-ci.org/KevinBongart/join_cache.png?branch=travis_ci)](https://travis-ci.org/KevinBongart/join_cache)

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
=> Team Load SELECT "teams".* FROM "teams" INNER JOIN "employees_teams" ON "teams"."id" = "employees_teams"."team_id" WHERE "employees_teams"."employee_id" = ?  [["employee_id", 1]]
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
gem 'join_cache'
```

In your model:

```ruby
class Employee < ActiveRecord::Base
  has_and_belongs_to_many :teams
  include JoinCache # make sure to add this *after* listing the associations
end
```

It also works with `has_many :through` associations!

```ruby
class Physician < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
  include JoinCache
end

freud.patients
=> Patient Load SELECT "patients".* FROM "patients" INNER JOIN "appointments" ON "patients"."id" = "appointments"."patient_id" WHERE "appointments"."physician_id" = ?  [["physician_id", 1]]

freud.cached_patient_ids
=> [4, 8, 15, 16, 23, 42]

freud.cached_patients
=> Patient.where(id: [4, 8, 15, 16, 23, 42])
=> Patient Load SELECT "patients".* FROM "patients" WHERE "patients"."id" IN (4, 8, 15, 16, 23, 42)
```

Take a look at this [example app](https://github.com/KevinBongart/join_cache_example).

## Performance

I ran [a very scientific study](http://i0.kym-cdn.com/photos/images/original/000/234/765/b7e.jpg) using Heroku, PostgreSQL, the [example app](https://github.com/KevinBongart/join_cache_example), its seeds.rb and speed.rake files.
Shorter means better:

![](http://f.cl.ly/items/3j0N0Y3j3d3B352x3009/screenshot%20320.png)

See? 30% faster!

## TODO

* [Support callbacks: after_add and after_remove](https://github.com/KevinBongart/join_cache/issues/2)
* [Support cached_ids for all collection associations](https://github.com/KevinBongart/join_cache/issues/5)

[View the full list](https://github.com/KevinBongart/join_cache/issues)

## Contributing to join_cache

* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.

## I came here looking for Johnny Cash

Here you go:

![Johnny Cash](http://screenshots.kevinbongart.net/PWYx.gif)

## Copyright

Copyright (c) 2013 Kevin Bongart. See LICENSE.txt for
further details.
