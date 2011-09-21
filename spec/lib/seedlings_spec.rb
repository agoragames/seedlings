require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Seedlings do
  let(:seeds) { Seedlings.new(Widget, { :constrain => :name }, []) }
  
  describe ".plant" do
    it "accepts the class to be seeded, options, and the seed data itself" do
      lambda {
        Seedlings.plant(Widget, { :constrain => :name })
      }.should_not raise_error
    end
    it "runs the seeding operation" do
      Widget.all.should == []
      Seedlings.plant(Widget, { :constrain => :name },
        { :name => "Basic text elements", :context => "hero" },
        { :name => "Social media", :context => "hero" },
        { :name => "Networks", :context => "hero" }
      )
      Widget.all.map { |wg| wg.name }.sort.should == ["Basic text elements", "Networks", "Social media"]
    end
  end
  
  describe ".plant_and_return" do
    let(:the_attrs) { { :name => "Basic text elements", :context => "hero" } }
    
    it "seeds and returns an object" do
      obj = Seedlings.plant_and_return(Widget, { :constrain => :name }, the_attrs)
      obj.should_not be_nil
      obj.name.should == the_attrs[:name]
      obj.context.should == the_attrs[:context]
    end
    it "doesn't create duplicates" do
      alt = Widget.create(the_attrs)
      neu = Seedlings.plant_and_return(Widget, { :constrain => :name }, the_attrs)
      
      neu.id.should == alt.id
      Widget.all.map { |wg| wg.id }.should == [alt.id]
    end
  end
  
  describe "#initialize" do
    it "stashes the class, options, and data as attributes" do
      seeds.klass.should == Widget
      seeds.options.should == { :constrain => :name }
      seeds.data.should == []
    end
  end
  
  describe "#adapt!" do
    it "extends the object with an appropriate adapter" do
      seeds.should_receive(:extend).with(Seedlings::ActiveModel)
      seeds.send(:adapt!)
    end
    describe "an adapter" do
      it "implements #find_model_with" do
        seeds.should respond_to(:find_model_with)
      end
      it "implements #find_and_update_model_with" do
        seeds.should respond_to(:find_and_update_model_with)
      end
      it "implements #constraints_for" do
        seeds.should respond_to(:constraints_for)
      end
    end
  end
  
  describe "#plant!" do
    it "plants a bunch of seedlings" do
      Widget.all.should == []
      seeds = Seedlings.new(Widget, { :constrain => :name }, [
        { :name => "Basic text elements", :context => "hero" },
        { :name => "Social media", :context => "hero" },
        { :name => "Networks", :context => "hero" }
      ])
      seeds.plant!
      Widget.all.map { |wg| wg.name }.sort.should == ["Basic text elements", "Networks", "Social media"]
    end
  end
  
end

describe Seedlings::ActiveModel do
  let(:seeds) { Seedlings.new(Widget, { :constrain => :name }, []) }
  
  describe "#constraints_for" do
    # hey, it could happen
    context "with no specified constraints" do
      before do
        seeds.options[:constrain] = nil
      end
      it "returns an empty array if given no data" do
        seeds.constraints_for({}).should == []
      end
      it "returns only one constraint: { :id => data[:id] } if given that data" do
        seeds.constraints_for({:id => 1}).should == [{ :id => 1 }]
      end
    end
    context "with one constraint specified" do
      it "returns an empty array if the data doesn't include the necessary constraint column" do
        seeds.constraints_for({:bob => "baz"}).should == []
      end
      it "returns an array with the correct constraint otherwise" do
        seeds.constraints_for({:name => "bar"}).should == [{:name => "bar"}]
      end
    end
    context "with more than one constraint" do
      before do
        seeds.options[:constrain] = [:name, :id]
      end
      it "returns an empty array if it cannot locate sufficient data" do
        seeds.constraints_for({:foo => "bar"}).should == []
      end
      it "returns correctly formatted constraints otherwise" do
        seeds.constraints_for({:name => "bar", :id => 7}).should == [{:name=>"bar"}, {:id=>7}]
      end
    end
  end
  
  describe "#find_and_update_model_with" do
    let(:the_attrs) { { :name => "Basic text elements", :context => "hero" } }
    let(:seedlings) { Seedlings.new(Widget, { :constrain => :name }, [] ) }

    context "when the seedling already exists" do
      before do
        @alt = Widget.create(the_attrs.merge(:context => "columns"))
      end
      it "updates the attributes of the object to match the seed data by default" do
        @alt.context.should == "columns"
        seedlings.find_and_update_model_with the_attrs
        Widget.where(name: "Basic text elements").first.context.should == "hero"
      end
      it "skips the update if you've given it the :dont_update_existing option" do
        seeds = Seedlings.new(Widget, { :constrain => :name, :dont_update_existing => true }, the_attrs )
        seeds.find_and_update_model_with the_attrs
        Widget.where(name: "Basic text elements").first.context.should == "columns"
      end
    end
    context "when the seedling doesn't exist" do
      it "creates a new record" do
        Widget.all.should == []
        obj = seedlings.find_and_update_model_with( the_attrs )
        obj.should be_valid
        Widget.all.map { |wg| wg.id }.should == [obj.id]
      end
      it "blows up, halting everything, on error" do
        lambda {
          seedlings.find_and_update_model_with( the_attrs.merge(:context => "INVALID VALUE AHOY") )
        }.should raise_error(INVALID_DOCUMENT_ERROR)
      end
    end
    
  end
  
end