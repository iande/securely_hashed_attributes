## Overview

This gem provides a quick and dirty way to add secure hashing to your
ActiveRecord models.  It relies on the recent refactoring of
`ActiveRecord::Base::serialize` thus **Rails 3.1+** is **required**.

## Motivation

I wrote this gem in response to Aaron Patterson's request for a
`has_secure_password` implementation that uses the newfound flexibility of
`ActiveRecord::Base::serialize`.  I originally intended to refactor the
`has_secure_password` method in Rails 3.1, but that poses a problem that
stems from the fact that `has_secure_password` is defined in ActiveModel::SecurePassword,
while all of the column serialization jazz is part of `ActiveRecord::Base`.

Either `SecurePassword` would need to be moved to `ActiveRecord`, or all of
the `serialize` jazz would need to be moved to `ActiveModel`.  The first
approach is the easiest, and at the moment only `ActiveRecord::Base` mixes-in
the `ActiveModel::SecurePassword` module, but it still takes away the option
of using it in, say, `ActiveResource::Base`.  The second approach would be
a pretty involved undertaking, and while the work done by `serialize` and the
coders does not depend upon `ActiveRecord`, no actual serialization is
performed until the model is persisted.  As a result, it probably doesn't make
much sense to refactor `serialize` into `ActiveModel`.

In either case, such a refactoring would require some amount of pull amongst
the Rails community (both components mentioned were put in place by some
important Rails people) and unlike Jackie Treehorn, I don't pull shit in this
town.  So, I created this gem to illustrate how dead simple the new hotness
of `serialize` makes this feature.  It should work just fine with
`ActiveRecord`, but it was built as more of a proof of concept than anything
else.

### Usage

Here's an example of how you might use this gem:

    # Schema: users(:password_hash => String, :bollocks => String,
    #   :fancy_pants => String)
    class User < ActiveRecord::Base
      securely_hashes :password, :to => :password_hash
      securely_hashes :bollocks
    
      class AlternateCoder
        def self.dump some_value
          # ...
        end
      
        def self.load encoded
          # ...
        end
      end
    
      securely_hashes :fancy_pants, :with => AlternateCoder
    end

    some_user = User.new
    some_user.password    = 'super secret'
    some_user.bollocks    = 'something else to hash'
    some_user.fancy_pants = 'you get the idea'
    some_user.save
    some_user.reload
    some_user.password_hash # => $2a$10blahetcetc...
    some_user.bollocks      # => $2a$10yaddayadda...

When using the `:to => <column name>` option, the gem will create getters and
setters for the given attribute name and the setter will pass the value on
to the actual column.  So, in our example of

    securely_hashes :password, :to => :password_hash
    
the gem defined `password` and `password=` methods on our model automatically.
This behavior is important to note because it can clobber (or be clobbered) by
methods explicitly defined on the model. If the `:to => ...` option is not
used, no methods are created.

### Further Thoughts

Hopefully this gem serves its purpose of demonstrating how easy it is to do
some pretty cool shit with serialized columns in Rails 3.1.  You could easily
add a coder that handles encryption to securely persist data in a column and
semi-automagically work with the unencrypted data in your app.  It also
provides opportunities for leveraging features of your database of choice, as
Aaron Patterson demonstrated with his HStore coder at RailsConf 2011.
Although, you may not want to use `eval` to decode the data.

