module LdsLogger
    def LdsLogger.localDependency(s,superDependency)
    end
    def LdsLogger.netDependency(s)
        s.dependency 'CocoaLumberjack'
        s.dependency 'FMDB'
    end
    def LdsLogger.config(spec,sourcePath,superDependency)
        spec.ios.deployment_target = '9.0'
        puts "[debug] code path #{sourcePath}Classes/*{.m,.h} #{File.dirname(__FILE__)}"
        spec.source_files = "#{sourcePath}Classes/*{.m,.h}"
        spec.resources = "#{sourcePath}Assets/**/*"
        spec.public_header_files = "#{sourcePath}Classes/*.h"
        self.netDependency(spec)
    end
end
