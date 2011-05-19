class SecurelyHashedAttributes::Coders::BCryptPasswordColumn
  RESCUE_ERRORS = [ArgumentError, BCrypt::Errors::InvalidHash]
  
  def self.dump(obj)
    BCrypt::Password.create(obj)
  end

  def self.load(bcrypt)
    return '' if bcrypt.nil?
    begin
      BCrypt::Password.new(bcrypt)
    rescue *RESCUE_ERRORS
      bcrypt
    end
  end
  
  SecurelyHashedAttributes::DEFAULT_ATTRIBUTE_OPTIONS[:with] = self
end
