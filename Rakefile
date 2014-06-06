# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'FavU'
  app.frameworks += ['Accounts', 'Social', 'Twitter']

  # configure motion-cocoapods
  app.pods do
    pod 'STTwitter', :git => 'https://github.com/nst/STTwitter.git'
    pod 'AFNetworking'
    pod 'LXReorderableCollectionViewFlowLayout'
  end

  # configure motion-redgreen
  app.redgreen_style = :full
end
