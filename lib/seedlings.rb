require "seedlings/version"

# Seedlings.rb
#
# A Seeding system that handles all the annoying corner-cases for you.
class Seedlings
  attr_accessor :klass, :options, :data
  
  def self.plant klass, options, *data
    thang = new(klass, options, data)
    thang.plant!
  end
  
  def self.plant_and_return klass, options, data
    seedling = new(klass, options, [data])
    seedling.plant_and_return data
  end
  
  def initialize klass, options, data
    self.klass = klass
    self.options = { :update_existing => true }.merge(options)
    self.data = data
    adapt!
  end
  
  #
  # determine what manner of class we've been asked to seed and load the appropriate adapter.
  # Yes, I know it only does one thing now.
  # N.B. I'm open to more efficient suggestions here.
  def adapt!
    extend Seedlings::ActiveModel
  end
  
  #
  # Get this planting party started
  def plant!
    data.each do |the_data|
      find_and_update_model_with the_data unless the_data.nil?
    end
  end
  
  def plant_and_return the_data
    find_and_update_model_with the_data unless the_data.nil?
  end

  #
  # The base plugin for Seedlings: ActiveModel.
  # Use this if the class to be seeded has an AREL-like query interface
  module ActiveModel
    
    def constraints_for the_data
      constraints = []
      constraint_columns = options[:constrain] ? [options[:constrain]].flatten : [:id]
      unless the_data.keys & constraint_columns == constraint_columns
        puts "Couldn't find necessary constraints #{constraint_columns.inspect} in #{the_data.inspect}, skipping"
        return constraints
      end
      constraint_columns.each do |key|
        constraints << { key => the_data[key] } if the_data[key]
      end
      constraints
    end
    
    def find_model_with the_data
      finder = constraints_for(the_data).inject(klass) { |k, constraint| k.where(constraint) }
      finder.first
    end
    
    def find_and_update_model_with the_data
      object = find_model_with the_data
      if object
        puts "FOUND: #{object.inspect}"
        if !options[:update_existing]
          puts "  * skipping update as per options[:update_existing]"
        else
          puts "  * updating with #{the_data}"
          object.update_attributes(the_data)
        end
      else
        puts "NEW OBJECT: #{klass}.new(#{the_data.inspect})"
        object = klass.new(the_data)
        object.save!
      end
      puts
      object
    end
    
  end
  
end

