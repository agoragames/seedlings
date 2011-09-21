# Seedlings

A little project to make seeding data easier to deal with across multiple ORMs.

**N.B.** This is early-release code that writes data to your database. While it is extracted from a live app, there may be cases where it blows up still :). Please test first. I don't want to hear about lost production data because you didn't try it in development first :).

## Usage

    gem "seedlings"

Install the gem.

There are two methods of note: `.plant` and `.plant_and_return`. They take 3 parameters:

* the Class to use (must support `ActiveModel`ish interface, like MongoMapper, Mongoid, ActiveRecord)
* options you want Seedlings to respect, of which there are two:
  * `:constrain` which takes a column name or array of column names that will be used to find the records, and
  * `:dont_update_existing`, which, if set to true, will cause Seedlings to skip updating existing records.
* the third parameter is that data you want seeded. `.plant` takes however many attribute hashes you give it. `.plant_and_return` takes only a single hash, but returns the resulting object.

Here's some examples:

```ruby
Seedlings.plant(Widget, { :constrain => :name }, 
  # your seed data goes here, as a bunch of hashes.
  # Make sure you include values for any constraint columns you've specified!
  { :name => "Gizwidget", :context => "science!" },
  { :name => "Somoflange", :context => "80s cartoons" },
  # ...
)
```

If some of your seed data depends on other records, switch up to `Seedlings.plant_and_return`, which only takes one attribute hash but returns the object so you can use it in other hashes later, e.g.

```ruby
parent_thing = Seedlings.plant_and_return(Thing, {}, { :name => "I'm a Parent!" })

Seedlings.plant(ChildThing, {}, 
  { :name => "Child Bit", :context => "docco", :parent => parent_thing },
  # ...
)
```

### Rails? Rails.

"Integration" with rails is as simple as sticking the gem in your `Gemfile` and calling `Seedlings.plant(...)` in `db/seeds.rb`. Then you use rake per normal: `rake db:seed`. Yep.

## Of Note

This is early code, ripped out from an upcoming project. It probably has some rough edges.

TODO:

* more and better integration tests
* a logging system that isn't `puts`-based :)
* rake tasks
* more options, etc, as desired

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Matt Wilson. See LICENSE for details.