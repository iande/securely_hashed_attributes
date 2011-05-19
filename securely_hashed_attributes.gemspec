# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "securely_hashed_attributes/version"

Gem::Specification.new do |s|
  s.name        = "securely_hashed_attributes"
  s.version     = SecurelyHashedAttributes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian D. Eccles"]
  s.email       = ["ian.eccles@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Add securely hashed attributes to your models}
  s.description = %q{Add securely hashed attributes to your models, serialized with BCrypt}

  s.rubyforge_project = "securely_hashed_attributes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
