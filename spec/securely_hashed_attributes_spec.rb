require 'spec_helper'

require 'active_record/connection_adapters/sqlite3_adapter'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

describe ActiveRecord::Base do
  class AlternateCoder
    def self.dump(*_); 'encoded'; end
    def self.load(*_); 'decoded'; end
  end
  
  let(:new_model) {
    HashingModel.new
  }
  
  with_model :hashing_model do
    table do |t|
      t.string :blathering
      t.string :password_hash
      t.string :chicken_fist_digest
      t.string :big_mclargehuge
    end
    
    model do
      attr_reader :stately_dutch, :portly
      alias :stately_dutch? :stately_dutch
      alias :portly? :portly
      
      securely_hashes :blathering, :with => AlternateCoder
      securely_hashes :password, :to => :password_hash
      securely_hashes :chicken_fist, :to => :chicken_fist_digest
      
      def chicken_fist=(bird)
        @stately_dutch = true
      end
      
      def rip_steakface=(beefy)
        @portly = true
      end
      
      securely_hashes :rip_steakface, :to => :big_mclargehuge
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
    new_model.reload
    new_model.password_hash.should_not be_empty
    new_model.password_hash.should be_a_kind_of(BCrypt::Password)
    new_model.password_hash.should == 'super duper'
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
  
  it "should clobber #rip_steakface=" do
    new_model.should_not be_portly
    new_model.rip_steakface = 'a string to hash'
    new_model.should_not be_portly
  end
  
  it "should has properly because it overwrote #rip_steakface=" do
    new_model.rip_steakface = 'a string to hash'
    new_model.save
    new_model.big_mclargehuge.should_not be_empty
  end
  
  it "should serialize :blathering with an alternate coder" do
    new_model.blathering = 'fancy pants'
    new_model.save
    new_model.reload
    new_model.blathering.should == 'decoded'
  end
end
