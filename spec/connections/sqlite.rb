require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => File.dirname(__FILE__) + "/test.sqlite3"
)

INVALID_DOCUMENT_ERROR = ActiveRecord::RecordInvalid

ActiveRecord::Schema.define :version => 0 do
  create_table :widgets, :force => true do |t|
    t.column :name, :string
    t.column :context, :string
  end
end

class Widget < ActiveRecord::Base

  CONTEXTS = %w(hero columns)

  validates :name, :presence => true, :uniqueness => true
  validates :context, :inclusion => CONTEXTS

end