# Kind of necessary for, you know, everything else we do.
require 'bcrypt'
require 'active_record'

module SecurelyHashedAttributes
  # The default settings constant. Once the library is fully loaded,
  # +:with+ will still be +nil+, but +:to+ will be set to
  # {SecurelyHashedAttributes::Coders::BCryptPasswordColumn}
  DEFAULT_ATTRIBUTE_OPTIONS = {
    :to => nil,
    :with => nil
  }
end
require 'securely_hashed_attributes/version'
require 'securely_hashed_attributes/coders'

class << ActiveRecord::Base
  # Adds a secure hash serialization to a column with the help of `bcrypt`.
  # @param [#to_sym] attrib attribute to serialize
  # @param [Hash] opts additional options
  def securely_hashes attrib, opts={}
    opts = SecurelyHashedAttributes::DEFAULT_ATTRIBUTE_OPTIONS.merge opts
    attrib = attrib.to_sym
    if opts[:to]
      col = opts[:to].to_sym
      serialize col, opts[:with]

      attr_reader attrib      
      define_method :"#{attrib}=" do |val|
        instance_variable_set(:"@#{attrib}", val)
        self[col] = val
      end
    else
      serialize attrib, opts[:with]
    end
  end
end
