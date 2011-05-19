require 'spec_helper'

describe SecurelyHashedAttributes::Coders::BCryptPasswordColumn do
  it "should dump a string as a bcrypt password hash" do
    hashed = SecurelyHashedAttributes::Coders::BCryptPasswordColumn.dump('my stringzy')
    hashed.should be_a_kind_of(BCrypt::Password)
  end
  
  it "should dump a non string to bcrypt by converting it to a string" do
    hashed = SecurelyHashedAttributes::Coders::BCryptPasswordColumn.dump([1, 2, 3])
    hashed.should be_a_kind_of(BCrypt::Password)
  end
  
  it "should load a bcrypt hash as a string" do
    hashed = SecurelyHashedAttributes::Coders::BCryptPasswordColumn.dump('my stringzy')
    loaded = SecurelyHashedAttributes::Coders::BCryptPasswordColumn.load(hashed)
    loaded.should be_a_kind_of(BCrypt::Password)
    loaded.should == 'my stringzy'
  end
  
  it "should load a nil as an empty string" do
    loaded = SecurelyHashedAttributes::Coders::BCryptPasswordColumn.load(nil)
    loaded.should_not be_a_kind_of(BCrypt::Password)
    loaded.should == ''
  end
  
  it "should load a non bcrypt hash as a plain string" do
    loaded = SecurelyHashedAttributes::Coders::BCryptPasswordColumn.load('sweet lameness')
    loaded.should_not be_a_kind_of(BCrypt::Password)
    loaded.should == 'sweet lameness'
  end
end
