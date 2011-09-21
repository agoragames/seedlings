require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new(ENV["MONGO_HOST"] || 'localhost')
MongoMapper.database = "seedlings_gem_test"

INVALID_DOCUMENT_ERROR = MongoMapper::DocumentNotValid

class Widget
  include MongoMapper::Document
  
  CONTEXTS = %w(hero columns)

  key :name, String
  key :context, String
    
  validates :name, :presence => true, :uniqueness => true
  validates :context, :inclusion => CONTEXTS

end

