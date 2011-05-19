require 'spec_helper'

require 'active_record/connection_adapters/sqlite3_adapter'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

describe ActiveRecord::Base do
  class AlternateCoder
    def dump(*_); 'encoded'; end
    def load(*_); 'decoded'; end
  end
  
  let(:new_model) {
    HashingModel.new
  }
  
  with_model :hashing_model do
    table do |t|
      t.string :blathering
      t.string :password_hash
      t.string :chicken_fist_digest
    end
    
    model do
      attr_reader :stately_dutch
      alias :stately_dutch? :stately_dutch
      
      securely_hashes :blathering, :with => AlternateCoder
      securely_hashes :password, :to => :password_hash
      securely_hashes :chicken_fist, :to => :chicken_fist_digest
      
      def chicken_fist=(bird)
        @stately_dutch = true
      end
    end
  end
  
  before(:each) do
    HashingModel.delete_all
  end
  
  it "should create getters and setters for :password" do
    new_model.should respond_to(:password)
    new_model.should respond_to(:password=)
    new_model.password = 'super duper'
    new_model.password.should == 'super duper'
  end
  
  it "should serialize :password to :password_digest on save" do
    new_model.password = 'super duper'
    new_model.save
    old_model = HashingModel.find(new_model.id)
    old_model.password_hash.should_not be_empty
    old_model.password_hash.should be_a_kind_of(BCrypt::Password)
    old_model.password_hash.should == 'super duper'
  end
  
  it "should get clobbered by #chicken_fist=" do
    new_model.should_not be_stately_dutch
    new_model.chicken_fist = 'a string to hash'
    new_model.should be_stately_dutch
  end
  
  it "should not hash properly because of #chicken_fist=" do
    new_model.chicken_fist = 'a string to hash'
    new_model.save
    new_model.chicken_fist_digest.should be_empty
  end
end
