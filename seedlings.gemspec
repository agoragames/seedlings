# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "seedlings/version"

Gem::Specification.new do |s|
  s.name        = "seedlings"
  s.version     = Seedlings::VERSION
  s.authors     = ["Matt Wilson"]
  s.email       = ["mhw@hypomodern.com"]
  s.homepage    = ""
  s.summary     = "Simple seed data management"
  s.description = "An ActiveModel (MongoMapper/Mongoid/ActiveRecord 3+) compliant seed data handler for any ruby project."

  s.rubyforge_project = "seedlings"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency("rspec")
  s.add_development_dependency("mongo_mapper")
  s.add_development_dependency("mongoid")
  s.add_development_dependency("bson_ext")
  s.add_development_dependency("activerecord")
  s.add_development_dependency("sqlite3")
end
