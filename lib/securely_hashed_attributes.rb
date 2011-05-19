# Kind of necessary for, you know, everything else we do.
require 'bcrypt'
require 'active_record'

# The primary namespace of this gem
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

# Adds the singleton method
# {ActiveRecord::Base.securely_hashes securely_hashes} to +ActiveRecord::Base+
class ActiveRecord::Base
  class << self
    # Adds a secure hash serialization to a column with the help of +bcrypt+.
    # By default, +attrib+ will serve as both the attribute to serialize and
    # the name of the column that will hold the serialized value.  If you want
    # to serialize the value to a different column, use the +:to+ option.
    # Hashing of the value assigned to +attrib+ will not occur until the model
    # is persisted.
    #
    # @param [#to_sym] attrib attribute to serialize
    # @param [Hash] opts additional options
    # @option opts [#to_sym] :to The column to serialize +attrib+ to.  If this
    #   option is specified, a reader attribute will be created for +attrib+
    #   and a +<attrib>=+ method will be create that copies the assigned value
    #   to the specified column.
    # @option opts [#to_sym] :with (BCryptPasswordColumn)
    #   The coder to use to serialize and deserialize values assigned to +attrib+.
    # @see SecurelyHashedAttributes::Coders::BCryptPasswordColumn
    # @example
    #   class User < ActiveRecord::Base
    #     securely_hashes :password, :to => :password_hash
    #     securely_hashes :security_answer
    #   end
    #   
    #   new_user = User.new
    #   new_user.password = 'my password'
    #   new_user.security_answer = 'I am a turtle'
    #   new_user.save
    #   new_user.reload
    #   new_user.password_hash                         # => '$2a$10blahetcetc...'
    #   new_user.security_answer                       # => '$2a$10yaddayadda...'
    #   new_user.password_hash   == 'not my password'  # => false
    #   new_user.password_hash   == 'my password'      # => true
    #   new_user.security_answer == 'I am a duck'      # => false
    #   new_user.security_answer == 'I am a turtle'    # => true
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
end
