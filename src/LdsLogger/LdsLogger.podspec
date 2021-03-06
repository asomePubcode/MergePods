#
# Be sure to run `pod lib lint LdsLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

require_relative './LdsLogger.rb'

Pod::Spec.new do |s|
  s.name             = 'LdsLogger'
  s.version          = '1.1.1'
  s.summary          = 'A short description of LdsLogger.'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC

  s.homepage         = 'https://github.com/asomeLiao'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'asml' => 'asomeliao@foxmail.com' }
  s.source           = { :git => 'https://github.com/asomeLiao', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  LdsLogger.config(s,'',nil)
end
