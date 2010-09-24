# -*- encoding: utf-8 -*-
require File.expand_path("../lib/appctl/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "appctl"
  s.version     = Appctl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bill Horsman"]
  s.email       = ["bill@logicalcobwebs.com"]
  s.homepage    = "http://rubygems.org/gems/appctl"
  s.summary     = "appctl-#{Appctl::VERSION}"
  s.description = "Automates branch switching, multiple databases and migrations"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
