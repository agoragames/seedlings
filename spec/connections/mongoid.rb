require 'mongoid'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("seedlings_gem_test")
end

INVALID_DOCUMENT_ERROR = Mongoid::Errors::Validations

class Widget
  include Mongoid::Document
  
  CONTEXTS = %w(hero columns)

  field :name, type: String
  field :context, type: String
    
  validates :name, :presence => true, :uniqueness => true
  validates :context, :inclusion => CONTEXTS

end