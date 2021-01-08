relativeSrcPath='.'
modules=[
    # "LdsCore",
    "LdsDebug",
    "LdsHttp",
    "LdsLogger", 
]

modules.each do |name|
    require_relative "#{relativeSrcPath}/#{name}/#{name}.rb"
end

module SDK
    def SDK.configForModuleName(name,spec)
        obj = Object::const_get("#{name}")
        spec.subspec "#{name}" do |ss|
            obj.config(ss,"#{name}/",spec.name)
        end
    end
end

Pod::Spec.new do |s|
    s.name='MergePodsSDK'
    s.version          = '0.0.1'
    s.summary          = 'A short description of MergePodsSDK.'
    s.description      = <<-DESC
  TODO: Add long description of the pod here.
                         DESC
    s.homepage         = 'https://github.com/asomeLiao'
    s.license          = { :type => 'MIT', :file => './MergePodsSDK/LICENSE' }
    s.author           = { 'asml' => 'asml' }
    s.source = { :git => 'xxx', :tag => s.version.to_s }
    s.ios.deployment_target = '9.0'
    s.watchos.deployment_target = '6.0'

    modules.each do |name|
        SDK.configForModuleName(name,s)
    end
    s.source_files = "MergePodsSDK/Classes/*.{h,m}"
end
  
