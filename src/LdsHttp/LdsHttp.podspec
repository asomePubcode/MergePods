
require_relative './LdsHttp.rb'

Pod::Spec.new do |s|
  s.name             = 'LdsHttp'
  s.version          = '1.1.2'
  s.summary          = 'A short description of LdsHttp.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/asomeLiao'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'asml' => 'asomeliao@foxmail.com' }
  s.source           = { :git => 'https://github.com/asomeLiao', :tag => s.version.to_s }

  LdsHttp.config(s,"",nil)
end
