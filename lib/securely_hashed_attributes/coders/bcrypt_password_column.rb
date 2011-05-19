# This coder serializes strings to +BCrypt::Password+ instances which, as the
# name suggests, are suitable handlers for passwords.
class SecurelyHashedAttributes::Coders::BCryptPasswordColumn
  # A list of errors to handle when loading
  RESCUE_ERRORS = [ArgumentError, BCrypt::Errors::InvalidHash]
  
  # Wrap the given data in the warm blanket of a +BCrypt::Password+
  # @param [#to_s] str data to serialize
  # @return [BCrypt::Password]
  def self.dump str
    BCrypt::Password.create str
  end

  # Takes a String digest generated by +bcrypt+ and wraps it in a new
  # +BCrypt::Password+ for functionality beyond that of a simple +String+.
  # If +digest+ is +nil+, an empty string is returned.  If +bcrypt+ does not
  # recognize +digest+ as a valid hash, +digest+ itself is returned.
  # @param [String] digest a string digest generated by +bcrypt+
  # @return [BCrypt::Password, String]
  def self.load digest
    return '' if digest.nil?
    begin
      BCrypt::Password.new digest
    rescue *RESCUE_ERRORS
      digest
    end
  end
  
  SecurelyHashedAttributes::DEFAULT_ATTRIBUTE_OPTIONS[:with] = self
end
