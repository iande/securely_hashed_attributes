# Kind of necessary for, you know, everything else we do.
require 'bcrypt'
require 'active_record'

module SecurelyHashedAttributes
  DEFAULT_ATTRIBUTE_OPTIONS = {
    :to => nil,
    :with => nil
  }
end
require 'securely_hashed_attributes/version'
require 'securely_hashed_attributes/coders'

# Boom, boom, add a method!
class << ActiveRecord::Base
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
